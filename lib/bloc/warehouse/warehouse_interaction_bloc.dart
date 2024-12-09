import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/local_network_calls.dart';
import 'package:wmssimulator/models/area_response.dart';
import 'package:wmssimulator/models/company_model.dart';
import 'package:wmssimulator/models/facility_model.dart';
import 'package:wmssimulator/models/user_model.dart';

part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  JsInteropService? jsInteropService;
  WarehouseInteractionBloc({this.jsInteropService, required NetworkCalls customApi})
      : _customApi = customApi,
        super(WarehouseInteractionState.initial()) {
    on<SelectedObject>(_onSelectedObject);
    on<ModelLoaded>(_onModelLoaded);
    on<GetCompanyData>(_onGetCompanyData);
    on<SelectedCompanyValue>(_onSelectCompany);
    on<GetFaclityData>(_onGetFacilityData);
    on<SelectedFacilityValue>(_onSelectFacility);
    on<GetUsersData>(_onGetUsersData);
    on<FilterUsers>(_onFilterUsers);
    on<UpdateUserAccess>(_onUpdateUserAccess);
  }
  final NetworkCalls _customApi;
  final NetworkCalls _companyApi = NetworkCalls(AppConstants.WMS_URL, getIt<Dio>(),
      connectTimeout: 30, receiveTimeout: 30, maxRedirects: 5, username: 'nalsoft_adm', password: 'P@s\$w0rd2024');
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  void _onSelectedObject(SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.dataFromJS}');
    String? searchArea;
    if (event.dataFromJS.containsKey("area") && !event.dataFromJS["area"].toString().contains('compound')) {
      searchArea = event.dataFromJS["area"].toString()[0].toUpperCase() + event.dataFromJS["area"].toString().substring(1);
    } else if (event.dataFromJS.containsKey("bin")) {
      searchArea = "Storage";
    }

    final areaContainsStorage = event.dataFromJS["area"].toString().contains("storage");
    final selectedAreaContainsStorage = state.selectedSearchArea.toLowerCase().contains("storage");

    if (areaContainsStorage && !selectedAreaContainsStorage) {
      emit(state.copyWith(
        dataFromJS: {"object": "storagearea"},
        selectedSearchArea: searchArea ?? state.selectedSearchArea,
        searchText: event.clearSearchText == false ? state.searchText : "",
      ));
    } else if (areaContainsStorage) {
      emit(state.copyWith(
        selectedSearchArea: searchArea ?? state.selectedSearchArea,
      ));
    } else {
      emit(state.copyWith(
        dataFromJS: event.dataFromJS,
        selectedSearchArea: searchArea ?? state.selectedSearchArea,
        searchText: event.clearSearchText == false ? state.searchText : "",
      ));
    }
  }

  void _onModelLoaded(ModelLoaded event, Emitter<WarehouseInteractionState> emit) {
    print('event loading ${event.isLoaded}');
    emit(state.copyWith(isModelLoaded: event.isLoaded));
  }

  void _onGetCompanyData(GetCompanyData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getState: GetCompanyDataState.loading));
    try {
      await _companyApi.get(AppConstants.COMPANY).then((value) {
        print(value.response!.data);
        CompanyModel companyModel = CompanyModel.fromJson(value.response!.data);
        print(companyModel.results!);
        emit(state.copyWith(
            companyModel: companyModel,
            getState: GetCompanyDataState.success,
            selectedCompanyVal: companyModel.results!.where((e) => e.name! == 'M10 Company').first.name!));
        add(GetFaclityData(company_id: companyModel.results!.where((e) => e.name! == 'M10 Company').first.id!));
      });
    } catch (e) {
      print("error $e");
    }
  }

  void _onGetFacilityData(GetFaclityData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(facilityDataState: GetFacilityDataState.loading));
    try {
      await _companyApi.get(AppConstants.FACILITY, queryParameters: {'parent_company_id': event.company_id}).then((value) {
        print(value.response!.data);
        FacilityModel facilityModel = FacilityModel.fromJson(value.response!.data);
        print(facilityModel.results!);
        emit(state.copyWith(
            facilityModel: facilityModel, facilityDataState: GetFacilityDataState.success, selectedFacilityVal: facilityModel.results![0].name!));
      });
    } catch (e) {
      print("error $e");
    }
  }

  void _onSelectCompany(SelectedCompanyValue event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(selectedCompanyVal: event.comVal));
  }

  void _onSelectFacility(SelectedFacilityValue event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(selectedFacilityVal: event.facilityVal));
  }

  Future<void> _onGetUsersData(GetUsersData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getUsersState: GetUsers.loading));
    try {
      await getIt<NetworkCalls>().get(AppConstants.USERS).then((value) {
        AreaResponse<User> usersFromBD = AreaResponse.fromJson(jsonDecode(value.response!.data), (json) => User.fromJson(json));
        emit(state.copyWith(users: usersFromBD.data, filteredUsers: usersFromBD.data, getUsersState: GetUsers.success));
        for(int i = 0; i< state.filteredUsers!.length; i++ ){
          print(state.filteredUsers![i].access);
        }
      });
    } catch (e) {
      print("error $e");
      emit(state.copyWith(getUsersState: GetUsers.failure));
    }
  }

  void _onFilterUsers(FilterUsers event, Emitter<WarehouseInteractionState> emit) async {
    List<User> newFilteredUsers;

    if (event.searchText.isEmpty) {
      // Create a new list with copies of the original users
      newFilteredUsers = state.users!.map((user) => user.copy()).toList();
    } else {
      // Filter and create a new list with copies of the filtered users
      newFilteredUsers =
          state.users!.where((user) => user.username!.toLowerCase().contains(event.searchText.toLowerCase())).map((user) => user.copy()).toList();
    }
    emit(state.copyWith(filteredUsers: newFilteredUsers));
  }

  Future<void> _onUpdateUserAccess(UpdateUserAccess event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getUsersState: GetUsers.loading));
    try {
      await getIt<NetworkCalls>().post(AppConstants.USERS, data: {"data": event.updatedUsers.map((e) => e.toJson()).toList()}).then((apiResponse) {
        emit(state.copyWith(getUsersState: GetUsers.success));
      });
    } catch (e) {
      print("error $e");
      emit(state.copyWith(getUsersState: GetUsers.failure));
    }
  }
}

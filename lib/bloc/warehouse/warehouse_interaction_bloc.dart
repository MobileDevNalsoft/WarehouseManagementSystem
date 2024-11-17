
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/local_network_calls.dart';
import 'package:warehouse_3d/models/company_model.dart';
import 'package:warehouse_3d/models/facility_model.dart';


part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  JsInteropService? jsInteropService;
  WarehouseInteractionBloc({this.jsInteropService}) : super(WarehouseInteractionState.initial()) {
    on<SelectedObject>(_onSelectedObject);
    on<ModelLoaded>(_onModelLoaded);
    on<GetCompanyData>(_onGetCompanyData);
    on<SelectedCompanyValue> (_onSelectCompany);
      on<GetFaclityData>(_onGetFacilityData);
    on<SelectedFacilityValue> (_onSelectFacility);

  }
final NetworkCalls _companyApi = NetworkCalls(AppConstants.WMS_URL, getIt<Dio>(), connectTimeout: 30, receiveTimeout: 30, maxRedirects: 5,username: 'nalsoft_adm',password: 'P@s\$w0rd2024');
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();



  void _onSelectedObject(SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.dataFromJS}');
    String? searchArea;
    if(event.dataFromJS.containsKey("area") && !event.dataFromJS["area"].toString().contains('compound')){
      searchArea = event.dataFromJS["area"].toString()[0].toUpperCase()+event.dataFromJS["area"].toString().substring(1); 
    }
    else if(event.dataFromJS.containsKey("bin")){
      searchArea = "Bin";
    }
    emit(state.copyWith(dataFromJS: event.dataFromJS,selectedSearchArea: searchArea??state.selectedSearchArea,searchText: event.clearSearchText==true?"":state.searchText));
  }
  
  void _onModelLoaded(ModelLoaded event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.isLoaded}');
    emit(state.copyWith(isModelLoaded: event.isLoaded));
  }


  void _onGetCompanyData(GetCompanyData event,Emitter<WarehouseInteractionState> emit) async{
      emit(state.copyWith(getState: GetCompanyDataState.loading));
    try {
      await _companyApi.get(AppConstants.COMPANY).then((value) {

        print(value.response!.data);
        CompanyModel companyModel = CompanyModel.fromJson(value.response!.data);
        print(companyModel.results!);
        emit(state.copyWith(companyModel: companyModel, getState: GetCompanyDataState.success,selectedCompanyVal:companyModel.results![0].id!.toString() ));
      });
    } catch (e) {
      print("error $e");
    }

  }

  void _onGetFacilityData(GetFaclityData event,Emitter<WarehouseInteractionState> emit) async{
      emit(state.copyWith(facilityDataState:  GetFacilityDataState.loading));
    try {
      await _companyApi.get(AppConstants.FACILITY,queryParameters: {'parent_company_id':event.company_id}).then((value) {

        print(value.response!.data);
        FacilityModel facilityModel = FacilityModel.fromJson(value.response!.data);
        print(facilityModel.results!);
        emit(state.copyWith(facilityModel: facilityModel,facilityDataState: GetFacilityDataState.success,selectedFacilityVal:facilityModel.results![0].id!.toString() ));
      });
    } catch (e) {
      print("error $e");
    }

  }


   void _onSelectCompany(SelectedCompanyValue event,Emitter<WarehouseInteractionState> emit) async{
    emit(state.copyWith(selectedCompanyVal: event.comVal));
   }

   void _onSelectFacility(SelectedFacilityValue event,Emitter<WarehouseInteractionState> emit) async{
    emit(state.copyWith(selectedFacilityVal: event.facilityVal));
   }

}

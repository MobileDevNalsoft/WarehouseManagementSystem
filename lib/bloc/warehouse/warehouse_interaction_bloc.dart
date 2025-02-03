import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/local_network_calls.dart';
import 'package:wmssimulator/logger/logger.dart';
import 'package:wmssimulator/models/area_response.dart';
import 'package:wmssimulator/models/company_model.dart';
import 'package:wmssimulator/models/container_model.dart';
import 'package:wmssimulator/models/facility_model.dart';
import 'package:wmssimulator/models/overview_model.dart';
import 'package:wmssimulator/models/user_model.dart';

part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  JsInteropService? jsInteropService;
  final StreamController<List<Alert>> _alertController = StreamController<List<Alert>>.broadcast();
  Stream<List<Alert>> get alertStream => _alertController.stream.asBroadcastStream();
  final StreamController<int> _alertsCountController = StreamController<int>.broadcast();
  Stream<int> get alertsCountStream => _alertsCountController.stream.asBroadcastStream();
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
    on<GetAreasOverviewData>(_onGetAreasOverviewData);
    on<UpdateTaskId>(_onUpdateTaskId);
    on<Rendering>(_onRendering);
    on<Intercepting>(_onIntercepting);
    on<ResetAlertsCount>(_onClearAlerts);
    on<GetLPNLifeCycle>(_onGetLPNLifeCycle);
    _fetchAlerts(); // Initial fetch'
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchAlerts(); // Subsequent fetches every 10 seconds
    });
    on<GetTasks>(_onGetTasks);
    on<GetBinsForTask>(_onGetBinsForTask);
  }
  final NetworkCalls _customApi;
  final NetworkCalls _companyApi = NetworkCalls(AppConstants.WMS_URL, getIt<Dio>(),
      connectTimeout: 30, receiveTimeout: 30, maxRedirects: 5, username: 'nalsoft_adm', password: 'P@s\$w0rd2024');
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  void _onSelectedObject(SelectedObject event, Emitter<WarehouseInteractionState> emit) {
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
          alertsCount: state.alertsCount));
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

  Future<void> _onGetLPNLifeCycle(GetLPNLifeCycle event, Emitter<WarehouseInteractionState> emit) async {
    try {
      emit(state.copyWith(getLpnLifeCycleStatus: LPNLifeCycleStatus.loading));
      // await _customApi.getLPNLifeCycle(event.lpn).then((apiResponse) {
      // LPNLifeCycleResponse lpnLifeCycleResponse = LPNLifeCycleResponse.fromJson(jsonDecode(apiResponse.response!.data));
      emit(state.copyWith(lpnLifeCycle: state.lpnLifeCycle, getLpnLifeCycleStatus: LPNLifeCycleStatus.success));
      // });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getLpnLifeCycleStatus: LPNLifeCycleStatus.failure));
    }
  }

  void _onRendering(Rendering event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(isRendered: event.isRendered));
  }

  void _onIntercepting(Intercepting event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(intercepting: event.intercepting));
  }

  void _onModelLoaded(ModelLoaded event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(isModelLoaded: event.isLoaded));
  }

  void _onGetCompanyData(GetCompanyData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getState: GetCompanyDataState.loading));
    try {
      await _companyApi.get(AppConstants.COMPANY).then((value) {
        CompanyModel companyModel = CompanyModel.fromJson(value.response!.data);
        emit(state.copyWith(
            companyModel: companyModel,
            getState: GetCompanyDataState.success,
            selectedCompanyVal: companyModel.results!.where((e) => e.name! == 'M10 Company').first.name!));
        // add(GetFaclityData(company_id: companyModel.results!.where((e) => e.name! == 'M10 Company').first.id!));
      });
    } catch (e) {
      print("error $e");
    }
  }

  void _onGetFacilityData(GetFaclityData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(facilityDataState: GetFacilityDataState.loading));
    try {
      await _companyApi.get(AppConstants.FACILITY, queryParameters: {'parent_company_id': event.company_id}).then((value) {
        FacilityModel facilityModel = FacilityModel.fromJson(value.response!.data);
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
      await _customApi.get(AppConstants.USERS).then((value) {
        List<User> usersFromBD = AreaResponse.fromJson(jsonDecode(value.response!.data), (json) => User.fromJson(json))
            .data!
            .where((e) => e.username != sharedPreferences.getString('username'))
            .toList();
        emit(state.copyWith(users: usersFromBD, filteredUsers: usersFromBD, getUsersState: GetUsers.success));
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
      await _customApi.post(AppConstants.USERS, data: {"data": event.updatedUsers.map((e) => e.toJson()).toList()}).then((apiResponse) {
        emit(state.copyWith(getUsersState: GetUsers.success));
      });
    } catch (e) {
      Log.e(e);
      emit(state.copyWith(getUsersState: GetUsers.failure));
    }
  }

  Future<void> _fetchAlerts() async {
    try {
      await _customApi.get(AppConstants.ALERTS).then((apiResponse) {
        List<Alert> alerts = AreaResponse<Alert>.fromJson(jsonDecode(apiResponse.response!.data), (json) => Alert.fromJson(json)).data!;
        _alertController.sink.add(alerts);
        if (alerts.length > state.alertsCount && state.alertsCount != 0) {
          _alertsCountController.sink.add(alerts.length - state.alertsCount);
        } else {
          state.alertsCount = alerts.length;
        }
      });
    } catch (e) {
      Log.e(e);
    }
  }

  void _onClearAlerts(ResetAlertsCount event, Emitter<WarehouseInteractionState> emit) {
    _alertsCountController.sink.add(0);
  }

  Future<void> _onGetAreasOverviewData(GetAreasOverviewData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getAreasOveriviewDataState: AreasOverviewDataState.loading));
    try {
      await _customApi.get(AppConstants.ARES_OVERVIEW_DATA, queryParameters: {"facility_id": event.facilityID}).then((apiResponse) {
        OverviewResponse overviewResponse = OverviewResponse.fromJson(jsonDecode(apiResponse.response!.data));
        getIt<JsInteropService>().sendOverviewData(overviewResponse.data!);
        emit(state.copyWith(getAreasOveriviewDataState: AreasOverviewDataState.success));
      });
    } catch (e) {
      Log.e(e);
      emit(state.copyWith(getAreasOveriviewDataState: AreasOverviewDataState.failure));
    }
  }

  void _onUpdateTaskId(UpdateTaskId event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(selectedTaskId: event.taskId));
  }

  @override
  Future<void> close() {
    _alertController.close(); // Close the stream controller when bloc is closed
    return super.close();
  }

  Future<void> _onGetTasks(GetTasks event, Emitter<WarehouseInteractionState> emit) async {
    try {
      await _customApi
          .get(
        AppConstants.SHORTESTPATH_TASKS,
      )
          .then((apiResponse) {
        emit(state.copyWith(tasksForShoretestPath: List<String>.from(jsonDecode(apiResponse.response!.data)["data"]["taskNbrs"])));
        print("shortest path task  ${state.tasksForShoretestPath}");
      });
    } catch (e) {
      print("error in shoretest path $e");
      Log.e(e);
      // emit(state.copyWith(getUsersState: GetUsers.failure));
    }
  }

  Future<void> _onGetBinsForTask(GetBinsForTask event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getBinsForTaskStatus: GetBinsForTaskStatus.loading));

    try {
      await Future.delayed(
          Duration(seconds: 2),
          () async => {
                await _customApi.get(AppConstants.BINS_FOR_TASK, queryParameters: {"facility_id": "243", "task_nbr": event.taskNbr}).then((apiResponse) {
                  if (apiResponse.response!.statusCode == 200) {
                    List<String> bins = List<String>.from(jsonDecode(apiResponse.response!.data)["data"]["bins"]);
                    emit(state.copyWith(binsForTask: bins, getBinsForTaskStatus: GetBinsForTaskStatus.success));
                    print("bins for task  ${state.binsForTask}");

                    state.inAppWebViewController!.webStorage.localStorage.removeItem(key: "getShoretestPathForTask");
                    getIt<JsInteropService>().getShoretestPathForTask(state.binsForTask!);
                  } else {
                    emit(state.copyWith(binsForTask: [], getBinsForTaskStatus: GetBinsForTaskStatus.failure));
                  }
                })
              });
    } catch (e) {
      print("error in bin for task $e");
      Log.e(e);
      emit(state.copyWith(binsForTask: [], getBinsForTaskStatus: GetBinsForTaskStatus.failure));
    }
    emit(state.copyWith(getBinsForTaskStatus: GetBinsForTaskStatus.initial));
  }
}

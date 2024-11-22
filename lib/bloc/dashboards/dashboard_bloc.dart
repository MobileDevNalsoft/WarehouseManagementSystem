
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/logger/logger.dart';
import 'package:warehouse_3d/models/activity_area_model.dart';
import 'package:warehouse_3d/models/area_response.dart';
import 'package:warehouse_3d/models/dashboard_response.dart';
import 'package:warehouse_3d/models/dock_area_model.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_3d/models/inspection_area_model.dart';
import 'package:warehouse_3d/models/receiving_area_model.dart';
import 'package:warehouse_3d/models/staging_area_model.dart';
import 'package:warehouse_3d/models/storage_aisle_model.dart';
import 'package:warehouse_3d/models/yard_area_model.dart';
import '../../local_network_calls.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardsBloc extends Bloc<DashboardsEvent, DashboardsState> {
  JsInteropService? jsInteropService;
  DashboardsBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(DashboardsState.initial()) {
    on<DashboardChanged>(_onDashboardChanged);
    on<GetDockAppointments>(_onGetDockAppointments);
    on<UpdateDate>(_onUpdateDate);
    on<ToggleCalendar>(_onToggleCalendar);
    on<GetDockDashboardData>(_onGetDockDashboardData);
    on<GetReceivingDashboardData>(_onGetReceivingDashboardData);
    on<GetInspectionDashboardData>(_onGetInspectionDashboardData);
    on<GetActivityDashboardData>(_onGetActivityDashboardData);
    on<GetStagingDashboardData>(_onGetStagingDashboardData);
    on<GetStorageDashboardData>(_onGetStorageDashboardData);
    on<GetYardDashboardData>(_onGetYardDashboardData);
    on<ChangeLocType>(_onChangeLocationType);
  }
  final NetworkCalls _customApi;

  void _onDashboardChanged(DashboardChanged event, Emitter<DashboardsState> emit){
    emit(state.copyWith(index: event.index));
  }

  void _onUpdateDate(UpdateDate event, Emitter<DashboardsState> emit){
    emit(state.copyWith(appointmentsDate: event.date));
    add(GetDockAppointments(date: DateFormat('yyyy-MM-dd').format(event.date)));
  }

  void _onToggleCalendar(ToggleCalendar event, Emitter<DashboardsState> emit){
    emit(state.copyWith(toggleCalendar: event.toggleCalendar));
  }

  void _onChangeLocationType(ChangeLocType event, Emitter<DashboardsState> emit){
    emit(state.copyWith(selectedLocType: event.locType, storageDashboardData: state.storageDashboardData, getStorageDashboardState: state.getStorageDashboardState));
  }

  Future<void> _onGetDockAppointments(GetDockAppointments event, Emitter<DashboardsState> emit) async {
    try {
       emit(state.copyWith(getAppointmentsState: AppointmentsState.loading));
      await _customApi.get(AppConstants.DOCK_APPOINTMENTS,  queryParameters:{"facility_id": '243', 'date': event.date}).then((apiResponse) {
        AreaResponse<Appointment> dockAppointmentsResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => Appointment.fromJson(json));
        emit(state.copyWith(appointments: dockAppointmentsResponse.data!, getAppointmentsState: AppointmentsState.success));
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getAppointmentsState: AppointmentsState.failure));
    }
  }

  Future<void> _onGetDockDashboardData(GetDockDashboardData event, Emitter<DashboardsState> emit) async {
    try{
      emit(state.copyWith(getDockDashboardState: DockDashboardState.loading));
      await _customApi.get(AppConstants.DOCK_DASHBOARD,  queryParameters:{"facility_id": event.facilityID}).then((apiResponse) {
        print(apiResponse.response!.data);
        DashboardResponse<DockDashboard> dockDashboardResponse = DashboardResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => DockDashboard.fromJson(json));
        emit(state.copyWith(dockDashboardData: dockDashboardResponse.data!, getDockDashboardState:DockDashboardState.success));
      });
    } catch(e){
      Log.e(e.toString());
      emit(state.copyWith(getDockDashboardState: DockDashboardState.failure));
    }
  }

  void _onGetYardDashboardData(GetYardDashboardData event, Emitter<DashboardsState> emit) async {
    try {
      emit(state.copyWith(getYardDashboardState: YardDashboardState.loading));
      await _customApi
          .get(AppConstants.YARD_DASHBOARD,
              queryParameters: {"facility_id": event.facilityID, "l_date": '2024-10-21'})
          .then((apiResponse) {
        print(apiResponse.response!.data);
        DashboardResponse<YardDashboard> dockAreaResponse = DashboardResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => YardDashboard.fromJson(json));
        emit(state.copyWith(yardDashboardData: dockAreaResponse.data, getYardDashboardState: YardDashboardState.success));
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getYardDashboardState: YardDashboardState.failure));
    }
  }

  Future<void> _onGetReceivingDashboardData(GetReceivingDashboardData event, Emitter<DashboardsState> emit) async {
    try{
      emit(state.copyWith(getReceivingDashboardState: ReceivingDashboardState.loading));
      await _customApi.get(AppConstants.RECEIVING_DASHBOARD,  queryParameters:{"facility_id": event.facilityID, "date": '2024-10-24'}).then((apiResponse) {
        print(apiResponse.response!.data);
        DashboardResponse<ReceivingDashboard> receivingDashboardResponse = DashboardResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => ReceivingDashboard.fromJson(json));
        emit(state.copyWith(receivingDashboardData: receivingDashboardResponse.data!, getReceivingDashboardState:ReceivingDashboardState.success));
      });
    } catch(e){
      Log.e(e.toString());
      emit(state.copyWith(getReceivingDashboardState: ReceivingDashboardState.failure));
    }
  }

  Future<void> _onGetInspectionDashboardData(GetInspectionDashboardData event, Emitter<DashboardsState> emit) async {
    try{
      if(state.getInspectionDashboardState != InspectionDashboardState.success) emit(state.copyWith(getInspectionDashboardState: InspectionDashboardState.loading));
      await _customApi.get(AppConstants.INSPECTION_DASHBOARD,  queryParameters:{"facility_id": event.facilityID}).then((apiResponse) {
        print(apiResponse.response!.data);
        DashboardResponse<InspectionDashboard> inspectionDashboardResponse = DashboardResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => InspectionDashboard.fromJson(json));
        emit(state.copyWith(inspectionDashboardData: inspectionDashboardResponse.data!, getInspectionDashboardState:InspectionDashboardState.success));
      });
    } catch(e){
      Log.e(e.toString());
      emit(state.copyWith(getInspectionDashboardState: InspectionDashboardState.failure));
    }
  }

  Future<void> _onGetActivityDashboardData(GetActivityDashboardData event, Emitter<DashboardsState> emit) async {
    try{
      emit(state.copyWith(getActivityDashboardState: ActivityDashboardState.loading));
      await _customApi.get(AppConstants.ACTIVITY_DASHBOARD,  queryParameters:{"facility_id": event.facilityID, "date": '2024-10-24'}).then((apiResponse) {
        print(apiResponse.response!.data);
        DashboardResponse<ActivityDashboard> activityDashboardResponse = DashboardResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => ActivityDashboard.fromJson(json));
        emit(state.copyWith(activityDashboardData: activityDashboardResponse.data!, getActivityDashboardState:ActivityDashboardState.success));
      });
    } catch(e){
      Log.e(e.toString());
      emit(state.copyWith(getActivityDashboardState: ActivityDashboardState.failure));
    }
  }

  Future<void> _onGetStagingDashboardData(GetStagingDashboardData event, Emitter<DashboardsState> emit) async {
    try{
      emit(state.copyWith(getStagingDashboardState: StagingDashboardState.loading));
      await _customApi.get(AppConstants.STAGING_DASHBOARD,  queryParameters:{"facility_id": event.facilityID}).then((apiResponse) {
        print(apiResponse.response!.data);
        DashboardResponse<StagingDashboard> stagingDashboardResponse = DashboardResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => StagingDashboard.fromJson(json));
        emit(state.copyWith(stagingDashboardData: stagingDashboardResponse.data!, getStagingDashboardState:StagingDashboardState.success));
      });
    } catch(e){
      Log.e(e.toString());
      emit(state.copyWith(getStagingDashboardState: StagingDashboardState.failure));
    }
  }

  Future<void> _onGetStorageDashboardData(GetStorageDashboardData event, Emitter<DashboardsState> emit) async {
    try{
      if(state.getStorageDashboardState != StorageDashboardState.success) emit(state.copyWith(getStorageDashboardState: StorageDashboardState.loading));
      await _customApi.get(AppConstants.STORAGE_DASHBOARD,  queryParameters:{"facility_id": event.facilityID}).then((apiResponse) {
        print(apiResponse.response!.data);
        DashboardResponse<StorageDashboard> storageDashboardResponse = DashboardResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => StorageDashboard.fromJson(json));
        emit(state.copyWith(storageDashboardData: storageDashboardResponse.data!, getStorageDashboardState:StorageDashboardState.success, selectedLocType: storageDashboardResponse.data!.locationUtilization![0].locType!.replaceAll('"', '').split('/')[1]));
      });
    } catch(e){
      Log.e(e.toString());
      emit(state.copyWith(getStorageDashboardState: StorageDashboardState.failure));
    }
  }
}

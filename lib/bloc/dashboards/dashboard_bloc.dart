
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/logger/logger.dart';
import 'package:warehouse_3d/models/area_response.dart';
import 'package:warehouse_3d/models/dashboard_response.dart';
import 'package:warehouse_3d/models/dock_area_model.dart';
import 'package:intl/intl.dart';
import 'package:warehouse_3d/models/inspection_area_model.dart';
import 'package:warehouse_3d/models/receiving_area_model.dart';
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
      emit(state.copyWith(getInspectionDashboardState: InspectionDashboardState.loading));
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
}

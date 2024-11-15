
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
}

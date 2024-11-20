part of 'dashboard_bloc.dart';

enum GetDataState { initial, loading, success, failure }
enum DockDashboardState { initial, loading, success, failure}
enum ReceivingDashboardState { initial, loading, success, failure}
enum AppointmentsState { initial, loading, success, failure}

// ignore: must_be_immutable
final class DashboardsState {
  DashboardsState({this.getDataState, this.index, this.getDockDashboardState, this.dockDashboardData, this.getReceivingDashboardState, this.receivingDashboardData, this.appointments, this.getAppointmentsState, this.appointmentsDate, this.toggleCalendar});

  GetDataState? getDataState;
  DockDashboard? dockDashboardData;
  List<Appointment>? appointments;
  AppointmentsState? getAppointmentsState;
  DateTime? appointmentsDate;
  bool? toggleCalendar;
  DockDashboardState? getDockDashboardState;
  ReceivingDashboardState? getReceivingDashboardState;
  ReceivingDashboard? receivingDashboardData;
  int? index;

  factory DashboardsState.initial() {
    return DashboardsState(getDataState: GetDataState.initial, index: 6, getDockDashboardState: DockDashboardState.initial, appointments: [], getAppointmentsState: AppointmentsState.initial, appointmentsDate: DateTime.now(), toggleCalendar: false, getReceivingDashboardState: ReceivingDashboardState.initial);
  }

  DashboardsState copyWith({
    GetDataState? getDataState,
    int? index,
    DockDashboardState? getDockDashboardState, DockDashboard? dockDashboardData,
    ReceivingDashboardState? getReceivingDashboardState, ReceivingDashboard? receivingDashboardData,
    List<Appointment>? appointments,
    DateTime? appointmentsDate,
    bool? toggleCalendar,
    AppointmentsState? getAppointmentsState
  }) {
    return DashboardsState(getDataState: getDataState ?? this.getDataState, index: index ?? this.index, getDockDashboardState: getDockDashboardState ?? this.getDockDashboardState, dockDashboardData: dockDashboardData ?? this.dockDashboardData, appointments: appointments ?? this.appointments,appointmentsDate: appointmentsDate ?? this.appointmentsDate, getAppointmentsState: getAppointmentsState ?? this.getAppointmentsState, toggleCalendar: toggleCalendar ?? this.toggleCalendar, getReceivingDashboardState: getReceivingDashboardState ?? this.getReceivingDashboardState, receivingDashboardData: receivingDashboardData ?? this.receivingDashboardData);
  }
}

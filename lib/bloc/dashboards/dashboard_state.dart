part of 'dashboard_bloc.dart';

enum GetDataState { initial, loading, success, failure }
enum DockDashboardState { initial, loading, success, failure}
enum ReceivingDashboardState { initial, loading, success, failure}
enum InspectionDashboardState { initial, loading, success, failure}
enum ActivityDashboardState { initial, loading, success, failure}
enum AppointmentsState { initial, loading, success, failure}

// ignore: must_be_immutable
final class DashboardsState {
  DashboardsState({this.getDataState, this.index, this.getDockDashboardState, this.dockDashboardData, this.getReceivingDashboardState, this.receivingDashboardData, this.getInspectionDashboardState, this.inspectionDashboardData, this.getActivityDashboardState, this.activityDashboardData, this.appointments, this.getAppointmentsState, this.appointmentsDate, this.toggleCalendar});

  GetDataState? getDataState;
  DockDashboard? dockDashboardData;
  List<Appointment>? appointments;
  AppointmentsState? getAppointmentsState;
  DateTime? appointmentsDate;
  bool? toggleCalendar;
  DockDashboardState? getDockDashboardState;
  ReceivingDashboardState? getReceivingDashboardState;
  ReceivingDashboard? receivingDashboardData;
  InspectionDashboardState? getInspectionDashboardState;
  InspectionDashboard? inspectionDashboardData;
  ActivityDashboardState? getActivityDashboardState;
  ActivityDashboard? activityDashboardData;
  int? index;

  factory DashboardsState.initial() {
    return DashboardsState(getDataState: GetDataState.initial, index: 6, getDockDashboardState: DockDashboardState.initial, appointments: [], getAppointmentsState: AppointmentsState.initial, appointmentsDate: DateTime.now(), toggleCalendar: false, getReceivingDashboardState: ReceivingDashboardState.initial, getInspectionDashboardState: InspectionDashboardState.initial, getActivityDashboardState: ActivityDashboardState.initial);
  }

  DashboardsState copyWith({
    GetDataState? getDataState,
    int? index,
    DockDashboardState? getDockDashboardState, DockDashboard? dockDashboardData,
    ReceivingDashboardState? getReceivingDashboardState, ReceivingDashboard? receivingDashboardData,
    InspectionDashboardState? getInspectionDashboardState, InspectionDashboard? inspectionDashboardData,
    ActivityDashboardState? getActivityDashboardState, ActivityDashboard? activityDashboardData,
    List<Appointment>? appointments,
    DateTime? appointmentsDate,
    bool? toggleCalendar,
    AppointmentsState? getAppointmentsState
  }) {
    return DashboardsState(getDataState: getDataState ?? this.getDataState, index: index ?? this.index, getDockDashboardState: getDockDashboardState ?? this.getDockDashboardState, dockDashboardData: dockDashboardData ?? this.dockDashboardData, appointments: appointments ?? this.appointments,appointmentsDate: appointmentsDate ?? this.appointmentsDate, getAppointmentsState: getAppointmentsState ?? this.getAppointmentsState, toggleCalendar: toggleCalendar ?? this.toggleCalendar, getReceivingDashboardState: getReceivingDashboardState ?? this.getReceivingDashboardState, receivingDashboardData: receivingDashboardData ?? this.receivingDashboardData, getInspectionDashboardState: getInspectionDashboardState ?? this.getInspectionDashboardState, inspectionDashboardData: inspectionDashboardData ?? this.inspectionDashboardData, getActivityDashboardState: getActivityDashboardState ?? this.getActivityDashboardState, activityDashboardData: activityDashboardData ?? this.activityDashboardData);
  }
}

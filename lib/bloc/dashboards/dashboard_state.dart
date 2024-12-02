part of 'dashboard_bloc.dart';

enum DockDashboardState { initial, loading, success, failure}
enum ReceivingDashboardState { initial, loading, success, failure}
enum InspectionDashboardState { initial, loading, success, failure}
enum ActivityDashboardState { initial, loading, success, failure}
enum StagingDashboardState { initial, loading, success, failure}
enum StorageDashboardState { initial, loading, success, failure}
enum YardDashboardState { initial, loading, success, failure}
enum AppointmentsState { initial, loading, success, failure}

// ignore: must_be_immutable
final class DashboardsState {
  DashboardsState({this.index, this.getDockDashboardState, this.dockDashboardData, this.getReceivingDashboardState, this.receivingDashboardData, this.getInspectionDashboardState, this.inspectionDashboardData, this.getActivityDashboardState, this.activityDashboardData, this.getStagingDashboardState, this.stagingDashboardData, this.getStorageDashboardState, this.storageDashboardData, this.appointments, this.getAppointmentsState, this.appointmentsDate, this.toggleCalendar, this.selectedLocType, this.getYardDashboardState, this.yardDashboardData, this.elevates});

  DockDashboard? dockDashboardData;
  List<Appointment>? appointments;
  AppointmentsState? getAppointmentsState;
  DateTime? appointmentsDate;
  bool? toggleCalendar;
  YardDashboard? yardDashboardData;
  YardDashboardState? getYardDashboardState;
  DockDashboardState? getDockDashboardState;
  ReceivingDashboardState? getReceivingDashboardState;
  ReceivingDashboard? receivingDashboardData;
  InspectionDashboardState? getInspectionDashboardState;
  InspectionDashboard? inspectionDashboardData;
  ActivityDashboardState? getActivityDashboardState;
  ActivityDashboard? activityDashboardData;
  StagingDashboardState? getStagingDashboardState;
  StagingDashboard? stagingDashboardData;
  StorageDashboardState? getStorageDashboardState;
  StorageDashboard? storageDashboardData;
  String? selectedLocType;
  int? index;
  List<bool>? elevates;

  factory DashboardsState.initial() {
    return DashboardsState(index: 0, getDockDashboardState: DockDashboardState.initial, appointments: [], getAppointmentsState: AppointmentsState.initial, appointmentsDate: DateTime.now(), toggleCalendar: false, getReceivingDashboardState: ReceivingDashboardState.initial, getInspectionDashboardState: InspectionDashboardState.initial, getActivityDashboardState: ActivityDashboardState.initial, getStagingDashboardState: StagingDashboardState.initial, getStorageDashboardState: StorageDashboardState.initial, getYardDashboardState: YardDashboardState.initial, elevates: []);
  }

  DashboardsState copyWith({
    int? index,
    DockDashboardState? getDockDashboardState, DockDashboard? dockDashboardData,
    ReceivingDashboardState? getReceivingDashboardState, ReceivingDashboard? receivingDashboardData,
    InspectionDashboardState? getInspectionDashboardState, InspectionDashboard? inspectionDashboardData,
    ActivityDashboardState? getActivityDashboardState, ActivityDashboard? activityDashboardData,
    StagingDashboardState? getStagingDashboardState, StagingDashboard? stagingDashboardData,
    StorageDashboardState? getStorageDashboardState, StorageDashboard? storageDashboardData,
    YardDashboardState? getYardDashboardState, YardDashboard? yardDashboardData,
    String? selectedLocType,
    List<Appointment>? appointments,
    DateTime? appointmentsDate,
    bool? toggleCalendar,
    AppointmentsState? getAppointmentsState,
    List<bool>? elevates
  }) {
    return DashboardsState(index: index ?? this.index, getDockDashboardState: getDockDashboardState ?? this.getDockDashboardState, dockDashboardData: dockDashboardData ?? this.dockDashboardData, appointments: appointments ?? this.appointments,appointmentsDate: appointmentsDate ?? this.appointmentsDate, getAppointmentsState: getAppointmentsState ?? this.getAppointmentsState, toggleCalendar: toggleCalendar ?? this.toggleCalendar, getReceivingDashboardState: getReceivingDashboardState ?? this.getReceivingDashboardState, receivingDashboardData: receivingDashboardData ?? this.receivingDashboardData, getInspectionDashboardState: getInspectionDashboardState ?? this.getInspectionDashboardState, inspectionDashboardData: inspectionDashboardData ?? this.inspectionDashboardData, getActivityDashboardState: getActivityDashboardState ?? this.getActivityDashboardState, activityDashboardData: activityDashboardData ?? this.activityDashboardData, getStagingDashboardState: getStagingDashboardState ?? this.getStagingDashboardState, stagingDashboardData: stagingDashboardData ?? this.stagingDashboardData, getStorageDashboardState: getStorageDashboardState ?? this.getStorageDashboardState, storageDashboardData: storageDashboardData ?? this.storageDashboardData, getYardDashboardState: getYardDashboardState ?? this.getYardDashboardState, yardDashboardData: yardDashboardData ?? this.yardDashboardData, selectedLocType: selectedLocType ?? this.selectedLocType, elevates: elevates ?? this.elevates);
  }
}

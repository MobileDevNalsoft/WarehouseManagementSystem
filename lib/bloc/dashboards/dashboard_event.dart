part of 'dashboard_bloc.dart';

abstract class DashboardsEvent extends Equatable {
  const DashboardsEvent();
  @override
  List<Object> get props => [];
}

class DashboardChanged extends DashboardsEvent{
  int index;
  DashboardChanged({required this.index});

  @override
  List<Object> get props => [index];
}


class GetDockAppointments extends DashboardsEvent {
  String date;
  GetDockAppointments({required this.date});

  @override
  List<Object> get props => [date];
}

class GetDockDashboardData extends DashboardsEvent{
  int facilityID;
  GetDockDashboardData({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}

class GetReceivingDashboardData extends DashboardsEvent{
  int facilityID;
  GetReceivingDashboardData({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}

class UpdateDate extends DashboardsEvent{
  DateTime date;
  UpdateDate({required this.date});

  @override
  List<Object> get props => [date];
}

class ToggleCalendar extends DashboardsEvent{
  bool toggleCalendar;
  ToggleCalendar({required this.toggleCalendar});

  @override
  List<Object> get props => [toggleCalendar];
}

class ToggleDaywiseCalendar extends DashboardsEvent{
  bool toggleDaywiseCalendar;
  ToggleDaywiseCalendar({required this.toggleDaywiseCalendar});

  @override
  List<Object> get props => [toggleDaywiseCalendar];
}
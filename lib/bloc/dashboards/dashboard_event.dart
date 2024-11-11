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
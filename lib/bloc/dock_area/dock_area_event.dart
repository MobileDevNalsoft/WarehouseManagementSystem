part of 'dock_area_bloc.dart';

abstract class DockEvent extends Equatable {
  const DockEvent();
  @override
  List<Object> get props => [];
}

class GetDockAreaData extends DockEvent {
  const GetDockAreaData();
}
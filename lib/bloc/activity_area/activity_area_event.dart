part of 'activity_area_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
  @override
  List<Object> get props => [];
}

class GetActivityAreaData extends ActivityEvent {
  const GetActivityAreaData();
}
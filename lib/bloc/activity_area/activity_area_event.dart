part of 'activity_area_bloc.dart';

abstract class ActivityAreaEvent extends Equatable {
  const ActivityAreaEvent();
  @override
  List<Object> get props => [];
}

class GetActivityAreaData extends ActivityAreaEvent {
  const GetActivityAreaData();
}
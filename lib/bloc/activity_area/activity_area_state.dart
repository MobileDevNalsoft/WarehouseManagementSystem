part of 'activity_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class ActivityAreaState extends Equatable {
  ActivityAreaState({this.getDataState, this.activityAreaItems});

  GetDataState? getDataState;
  List<ActivityAreaItem>? activityAreaItems;

  factory ActivityAreaState.initial() {
    return ActivityAreaState(getDataState: GetDataState.initial, activityAreaItems: []);
  }

  ActivityAreaState copyWith({
    GetDataState? getDataState,
    List<ActivityAreaItem>? activityAreaItems,
  }) {
    return ActivityAreaState(getDataState: getDataState ?? this.getDataState, activityAreaItems: activityAreaItems ?? this.activityAreaItems);
  }

  @override
  List<Object?> get props => [getDataState, activityAreaItems];
}

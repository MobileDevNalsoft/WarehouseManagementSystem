part of 'activity_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class ActivityAreaState {
  ActivityAreaState({this.getDataState, this.activityAreaItems, this.pageNum, this.activityTasks});

  GetDataState? getDataState;
  List<ActivityAreaItem>? activityAreaItems;
  List<ActivityTaskItem>? activityTasks;
  int? pageNum;

  factory ActivityAreaState.initial() {
    return ActivityAreaState(
      getDataState: GetDataState.initial,
      activityAreaItems: [],
      activityTasks: [],
      pageNum: 0,
    );
  }

  ActivityAreaState copyWith({GetDataState? getDataState, List<ActivityAreaItem>? activityAreaItems, int? pageNum, List<ActivityTaskItem>? activityTasks}) {
    return ActivityAreaState(
        getDataState: getDataState ?? this.getDataState,
        activityAreaItems: activityAreaItems ?? this.activityAreaItems,
        pageNum: pageNum ?? this.pageNum,
        activityTasks: activityTasks ?? this.activityTasks);
  }
}

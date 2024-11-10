part of 'activity_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class ActivityAreaState extends Equatable {
  ActivityAreaState({this.getDataState, this.activityAreaItems, this.pageNum});

  GetDataState? getDataState;
  List<ActivityAreaItem>? activityAreaItems;
  int? pageNum;

  factory ActivityAreaState.initial() {
    return ActivityAreaState(getDataState: GetDataState.initial, activityAreaItems: [], pageNum: 0);
  }

  ActivityAreaState copyWith({
    GetDataState? getDataState,
    List<ActivityAreaItem>? activityAreaItems,
    int? pageNum
  }) {
    return ActivityAreaState(getDataState: getDataState ?? this.getDataState, activityAreaItems: activityAreaItems ?? this.activityAreaItems, pageNum: pageNum ?? this.pageNum);
  }

  @override
  List<Object?> get props => [getDataState, activityAreaItems, pageNum];
}

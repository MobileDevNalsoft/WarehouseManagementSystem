part of 'yard_bloc.dart';

enum YardAreaStatus { initial, loading, success, failure }

final class YardState {
  YardState({this.yardAreaItems, this.yardAreaStatus = YardAreaStatus.initial, this.pageNum,this.yardDashboard});

  List<YardAreaItem>? yardAreaItems;
  YardAreaStatus yardAreaStatus;
  YardDashboard? yardDashboard;
  int? pageNum;

  factory YardState.initial() {
    return YardState(yardAreaStatus: YardAreaStatus.initial, yardAreaItems: [], pageNum: 0);
  }

  YardState copyWith({List<YardAreaItem>? yardAreaItems, YardAreaStatus? yardAreaStatus, int? pageNum,YardDashboard? yardDashboard}) {
    return YardState(
        yardAreaItems: yardAreaItems ?? this.yardAreaItems, yardAreaStatus: yardAreaStatus ?? this.yardAreaStatus, pageNum: pageNum ?? this.pageNum,yardDashboard: yardDashboard ??this.yardDashboard);
  }
}

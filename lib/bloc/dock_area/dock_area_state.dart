part of 'dock_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class DockAreaState {
  DockAreaState({this.getDataState, this.dockAreaItems, this.pageNum, this.dockOutItems});

  GetDataState? getDataState;

  List<DockAreaItem>? dockAreaItems;
  List<DockOutItem>? dockOutItems;
  int? pageNum;

  factory DockAreaState.initial() {
    return DockAreaState(getDataState: GetDataState.initial, dockAreaItems: [], dockOutItems: [], pageNum: 0);
  }

  DockAreaState copyWith({GetDataState? getDataState, List<DockAreaItem>? dockAreaItems, int? pageNum, List<DockOutItem>? dockOutItems}) {
    return DockAreaState(
        getDataState: getDataState ?? this.getDataState,
        dockAreaItems: dockAreaItems ?? this.dockAreaItems,
        pageNum: pageNum ?? this.pageNum,
        dockOutItems: dockOutItems ?? this.dockOutItems);
  }
}

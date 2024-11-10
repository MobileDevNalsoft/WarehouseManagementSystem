part of 'dock_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class DockAreaState extends Equatable {
  DockAreaState({this.getDataState, this.dockAreaItems, this.pageNum});

  GetDataState? getDataState;
  List<DockAreaItem>? dockAreaItems;
  int? pageNum;

  factory DockAreaState.initial() {
    return DockAreaState(getDataState: GetDataState.initial, dockAreaItems: [], pageNum: 0);
  }

  DockAreaState copyWith({
    GetDataState? getDataState,
    List<DockAreaItem>? dockAreaItems,
    int? pageNum
  }) {
    return DockAreaState(getDataState: getDataState ?? this.getDataState, dockAreaItems: dockAreaItems ?? this.dockAreaItems, pageNum: pageNum ?? this.pageNum);
  }

  @override
  List<Object?> get props => [getDataState, dockAreaItems, pageNum];
}

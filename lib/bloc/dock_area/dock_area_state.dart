part of 'dock_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class DockAreaState extends Equatable {
  DockAreaState({this.getDataState, this.dockAreaItems});

  GetDataState? getDataState;
  List<DockAreaItem>? dockAreaItems;

  factory DockAreaState.initial() {
    return DockAreaState(getDataState: GetDataState.initial, dockAreaItems: []);
  }

  DockAreaState copyWith({
    GetDataState? getDataState,
    List<DockAreaItem>? dockAreaItems,
  }) {
    return DockAreaState(getDataState: getDataState ?? this.getDataState, dockAreaItems: dockAreaItems ?? this.dockAreaItems);
  }

  @override
  List<Object?> get props => [getDataState, dockAreaItems];
}

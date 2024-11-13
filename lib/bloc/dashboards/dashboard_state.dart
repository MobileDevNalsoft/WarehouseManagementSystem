part of 'dashboard_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class DashboardsState extends Equatable {
  DashboardsState({this.getDataState, this.index});

  GetDataState? getDataState;
  int? index;

  factory DashboardsState.initial() {
    return DashboardsState(getDataState: GetDataState.initial, index: 0);
  }

  DashboardsState copyWith({
    GetDataState? getDataState,
    int? index
  }) {
    return DashboardsState(getDataState: getDataState ?? this.getDataState, index: index ?? this.index);
  }

  @override
  List<Object?> get props => [getDataState, index];
}

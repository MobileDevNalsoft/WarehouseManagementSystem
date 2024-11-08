part of 'inspection_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class InspectionAreaState extends Equatable {
  InspectionAreaState({this.getDataState, this.inspectionAreaItems});

  GetDataState? getDataState;
  List<InspectionAreaItem>? inspectionAreaItems;

  factory InspectionAreaState.initial() {
    return InspectionAreaState(getDataState: GetDataState.initial, inspectionAreaItems: []);
  }

  InspectionAreaState copyWith({
    GetDataState? getDataState,
    List<InspectionAreaItem>? inspectionAreaItems,
  }) {
    return InspectionAreaState(getDataState: getDataState ?? this.getDataState, inspectionAreaItems: inspectionAreaItems ?? this.inspectionAreaItems);
  }

  @override
  List<Object?> get props => [getDataState, inspectionAreaItems];
}

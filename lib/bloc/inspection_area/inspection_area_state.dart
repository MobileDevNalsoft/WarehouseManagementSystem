part of 'inspection_area_bloc.dart';

enum GetDataState { initial, loading, success, failure }

// ignore: must_be_immutable
final class InspectionAreaState {
  InspectionAreaState({this.getDataState, this.inspectionAreaItems, this.pageNum});

  GetDataState? getDataState;
  int? pageNum;
  List<InspectionAreaItem>? inspectionAreaItems;

  factory InspectionAreaState.initial() {
    return InspectionAreaState(getDataState: GetDataState.initial, inspectionAreaItems: [], pageNum: 0);
  }

  InspectionAreaState copyWith({
    GetDataState? getDataState,
    List<InspectionAreaItem>? inspectionAreaItems,
    int? pageNum
  }) {
    return InspectionAreaState(getDataState: getDataState ?? this.getDataState, inspectionAreaItems: inspectionAreaItems ?? this.inspectionAreaItems, pageNum: pageNum ?? this.pageNum);
  }
}

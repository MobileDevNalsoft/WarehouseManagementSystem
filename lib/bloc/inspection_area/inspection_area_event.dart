part of 'inspection_area_bloc.dart';

abstract class InspectionEvent extends Equatable {
  const InspectionEvent();
  @override
  List<Object> get props => [];
}

class GetInspectionAreaData extends InspectionEvent {
  String? searchText;
  GetInspectionAreaData({this.searchText});
}
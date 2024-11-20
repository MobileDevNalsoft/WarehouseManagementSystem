part of 'yard_bloc.dart';

abstract class YardEvent extends Equatable {
  const YardEvent();
  @override
  List<Object> get props => [];
}

class GetYardData extends YardEvent{
  String? searchText;
  GetYardData({this.searchText});
}

class YardTruckExpanded extends YardEvent{
  int index;
   YardTruckExpanded({required this.index});
}

class GetYardDashboardData extends YardEvent{
   GetYardDashboardData();
}

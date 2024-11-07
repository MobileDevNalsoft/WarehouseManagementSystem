part of 'yard_bloc.dart';

abstract class YardEvent extends Equatable {
  const YardEvent();
  @override
  List<Object> get props => [];
}

class GetYardData extends YardEvent{
  const GetYardData();
}

class YardTruckExpanded extends YardEvent{
  int index;
   YardTruckExpanded({required this.index});
}
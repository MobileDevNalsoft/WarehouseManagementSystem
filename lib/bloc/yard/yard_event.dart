part of 'yard_bloc.dart';

abstract class YardEvent extends Equatable {
  const YardEvent();
  @override
  List<Object> get props => [];
}

// To get the data of the yard area. SearchText is only useful when it is passed else whole data is fetched
class GetYardData extends YardEvent {
  String? searchText;
  GetYardData({this.searchText});
}

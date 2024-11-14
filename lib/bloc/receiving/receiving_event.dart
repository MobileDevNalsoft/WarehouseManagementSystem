import 'package:equatable/equatable.dart';

abstract class ReceivingEvent  extends Equatable{
 const ReceivingEvent();
  @override
  List<Object> get props => [];

}

class GetReceivingData extends ReceivingEvent{
  String? searchText;
  GetReceivingData({this.searchText});
}
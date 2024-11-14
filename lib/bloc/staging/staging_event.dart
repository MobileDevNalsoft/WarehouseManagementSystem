import 'package:equatable/equatable.dart';

abstract class StagingEvent  extends Equatable{
 const StagingEvent();
  @override
  List<Object> get props => [];

}

class GetStagingData extends StagingEvent{
  String? searchText;
  GetStagingData({this.searchText});
}
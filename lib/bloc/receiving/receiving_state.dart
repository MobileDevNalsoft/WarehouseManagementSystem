import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/models/receiving_area_model.dart';

enum  ReceivingAreaStatus {initial, loading, success, failure }

final class ReceivingState extends Equatable{

ReceivingState({this.receivingStatus,this.receivingArea,this.pageNum,this.receiveList});

  ReceivingAreaStatus? receivingStatus;
  ReceivingArea? receivingArea;
  List<ReceiveData>? receiveList;
  int? pageNum;
 

  factory ReceivingState.initial() {
    return ReceivingState(receivingStatus: ReceivingAreaStatus.initial,pageNum: 0,receiveList: []);
  }

  

  ReceivingState copyWith({ReceivingAreaStatus? receivingStatus, ReceivingArea? receivingArea,int? pageNum,List<ReceiveData>? receiveList}) {
    return ReceivingState(receivingStatus: receivingStatus ?? this.receivingStatus,receivingArea: receivingArea?? this.receivingArea,pageNum: pageNum?? this.pageNum,receiveList: receiveList?? this.receiveList);
  }


  @override
  List<Object?> get props => [receivingStatus,receivingArea,pageNum,receiveList];
  
}

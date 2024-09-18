part of 'warehouse_interaction_bloc.dart';

final class WarehouseInteractionState {
  WarehouseInteractionState({this.index,this.selectedZone});

  int? index;
   String? selectedZone;

  factory WarehouseInteractionState.initial(){
    return WarehouseInteractionState(index: 0,selectedZone: "");
  }

  WarehouseInteractionState copyWith({int? index}){
    return WarehouseInteractionState(index: index ?? this.index);
  }
}

part of 'warehouse_interaction_bloc.dart';

final class WarehouseInteractionState {
  WarehouseInteractionState({this.index,this.selectedZone,this.hotspot=-1});

  int? index;
   String? selectedZone;
  int hotspot;
  factory WarehouseInteractionState.initial(){
    return WarehouseInteractionState(index: 0,selectedZone: "",hotspot: -1);
  }

  WarehouseInteractionState copyWith({int? index,int? hotspot}){
    return WarehouseInteractionState(index: index ?? this.index,hotspot: hotspot??this.hotspot);
  }
}

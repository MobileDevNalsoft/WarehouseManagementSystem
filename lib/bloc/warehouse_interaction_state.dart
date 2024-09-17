part of 'warehouse_interaction_bloc.dart';

final class WarehouseInteractionState {
  WarehouseInteractionState({this.index});

  int? index;

  factory WarehouseInteractionState.initial(){
    return WarehouseInteractionState(index: 0);
  }

  WarehouseInteractionState copyWith({int? index}){
    return WarehouseInteractionState(index: index ?? this.index);
  }
}

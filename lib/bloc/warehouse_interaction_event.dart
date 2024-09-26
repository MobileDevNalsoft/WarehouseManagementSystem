part of 'warehouse_interaction_bloc.dart';

@immutable
sealed class WarehouseInteractionEvent {}

class SelectedRackOfIndex extends WarehouseInteractionEvent {
  int index;
  String rackID;
  SelectedRackOfIndex({required this.index, required this.rackID});
}

class SelectedBinOfIndex extends WarehouseInteractionEvent {
  int index;
  SelectedBinOfIndex({required this.index});
}

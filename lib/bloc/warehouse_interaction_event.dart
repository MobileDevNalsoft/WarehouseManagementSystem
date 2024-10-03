part of 'warehouse_interaction_bloc.dart';

@immutable
sealed class WarehouseInteractionEvent {}

class SelectedRackOfIndex extends WarehouseInteractionEvent {
  int index;
  String rackID;
  SelectedRackOfIndex({required this.index, required this.rackID});
}

class SelectedBinID extends WarehouseInteractionEvent {
  String binID;
  SelectedBinID({required this.binID});
}

class SelectedObject extends WarehouseInteractionEvent {
  String? object;
  SelectedObject({required this.object});
}

class GetRacksData extends WarehouseInteractionEvent {

}
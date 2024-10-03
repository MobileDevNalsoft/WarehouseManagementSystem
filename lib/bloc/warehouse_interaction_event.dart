part of 'warehouse_interaction_bloc.dart';

@immutable
sealed class WarehouseInteractionEvent {}

class SelectedRackOfIndex extends WarehouseInteractionEvent {
  int index;
  String rackID;
  SelectedRackOfIndex({required this.index, required this.rackID});
}

class SelectedID extends WarehouseInteractionEvent {
  String ID;
  SelectedID({required this.ID});
}

class SelectedObject extends WarehouseInteractionEvent {
  String? object;
  SelectedObject({required this.object});
}

class GetRacksData extends WarehouseInteractionEvent {

}
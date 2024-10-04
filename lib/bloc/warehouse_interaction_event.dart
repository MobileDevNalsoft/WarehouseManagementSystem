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
  Map<String, dynamic> dataFromJS;
  SelectedObject({required this.dataFromJS});
}

class GetRacksData extends WarehouseInteractionEvent {

}

class SelectedRack extends WarehouseInteractionEvent{
  String rackID;
  SelectedRack({required this.rackID});
}

class SelectedBin extends WarehouseInteractionEvent{
  String binID;
  SelectedBin({required this.binID});
}

class SelectedArea extends WarehouseInteractionEvent{
  String areaName;
  SelectedArea({required this.areaName});
}
part of 'warehouse_interaction_bloc.dart';

@immutable
sealed class WarehouseInteractionEvent {}

class SelectedRackOfIndex extends WarehouseInteractionEvent{
  int index;
  SelectedRackOfIndex({required this.index});
}

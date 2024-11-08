part of 'warehouse_interaction_bloc.dart';

abstract class WarehouseInteractionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectedObject extends WarehouseInteractionEvent {
  final Map<String, dynamic> dataFromJS;
  SelectedObject({required this.dataFromJS});

  @override
  List<Object> get props => [dataFromJS];
}

class ModelLoaded extends WarehouseInteractionEvent {
  final bool isLoaded;
  ModelLoaded({required this.isLoaded});

  @override
  List<Object> get props => [isLoaded];
}

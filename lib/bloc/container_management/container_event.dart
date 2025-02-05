part of 'container_bloc.dart';

abstract class ContainerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetContainers extends ContainerEvent {
  int facility;
  GetContainers({required this.facility});

  @override
  List<Object> get props => [facility];
}

class OnHover extends ContainerEvent {
  bool isHovering;
  ContainerData? hoveredContainer;
  OnHover({required this.isHovering, this.hoveredContainer});

  @override
  List<Object> get props => [isHovering];
}

class SelectedContainer extends ContainerEvent {
  String containerNbr;
  SelectedContainer({required this.containerNbr});

  @override
  List<Object> get props => [containerNbr];
}

class SelectedToLocation extends ContainerEvent {
  String toLocation;
  SelectedToLocation({required this.toLocation});

  @override
  List<Object> get props => [toLocation];
}

class RelocateContainer extends ContainerEvent {
  String containerNbr;
  String toLocation;
  RelocateContainer({required this.containerNbr, required this.toLocation});

  @override
  List<Object> get props => [containerNbr, toLocation];
}

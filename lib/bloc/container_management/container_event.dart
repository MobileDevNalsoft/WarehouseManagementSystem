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

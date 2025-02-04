part of 'container_bloc.dart';

enum ContainerStatus { initial, loading, success, failure }

class ContainerState {
  ContainerState({this.containers, this.getContainerStatus, this.isHovering, this.hoveredContainer});

  List<ContainerData>? containers;
  ContainerData? hoveredContainer;
  ContainerStatus? getContainerStatus;
  bool? isHovering;

  factory ContainerState.initial() {
    return ContainerState(
        isHovering: false,
        containers: [
          ContainerData(
              lotNbr: 1,
              containerNbr: 'BCDS3256479',
              customer: 'SRAVAN',
              arrivalDate: DateTime(2025, 1, 30, 0, 0, 0),
              bound: 'IN',
              priority: true,
              status: 0,
              type: 0),
          ContainerData(
              lotNbr: 5,
              containerNbr: 'BCDS3256480',
              customer: 'JOHN',
              arrivalDate: DateTime(2025, 1, 31, 0, 0, 0),
              bound: 'OUT',
              priority: false,
              status: 1,
              type: 1),
          ContainerData(
              lotNbr: 10,
              containerNbr: 'BCDS3256481',
              customer: 'DOE',
              arrivalDate: DateTime(2025, 1, 29, 0, 0, 0),
              bound: 'IN',
              priority: true,
              status: 4,
              type: 2),
          ContainerData(
              lotNbr: 11,
              containerNbr: 'BCDS3256482',
              customer: 'JANE',
              arrivalDate: DateTime(2025, 1, 28, 0, 0, 0),
              bound: 'OUT',
              priority: true,
              status: 4,
              type: 0),
          ContainerData(
              lotNbr: 25,
              containerNbr: 'BCDS3256483',
              customer: 'SMITH',
              arrivalDate: DateTime(2025, 1, 25, 0, 0, 0),
              bound: 'IN',
              priority: false,
              status: 3,
              type: 2),
          ContainerData(
              lotNbr: 36,
              containerNbr: 'BCDS3256484',
              customer: 'BROWN',
              arrivalDate: DateTime(2025, 1, 31, 0, 0, 0),
              bound: 'OUT',
              priority: false,
              status: 1,
              type: 0),
          ContainerData(
              lotNbr: 17,
              containerNbr: 'BCDS3256485',
              customer: 'DAVIS',
              arrivalDate: DateTime(2025, 1, 17, 0, 0, 0),
              bound: 'IN',
              priority: true,
              status: 1,
              type: 1),
          ContainerData(
              lotNbr: 38,
              containerNbr: 'BCDS3256486',
              customer: 'MILLER',
              arrivalDate: DateTime(2025, 1, 28, 0, 0, 0),
              bound: 'OUT',
              priority: false,
              status: 0,
              type: 1),
          ContainerData(
              lotNbr: 9,
              containerNbr: 'BCDS3256487',
              customer: 'WILSON',
              arrivalDate: DateTime(2025, 1, 29, 0, 0, 0),
              bound: 'IN',
              priority: false,
              status: 0,
              type: 2),
          ContainerData(
              lotNbr: 40,
              containerNbr: 'BCDS3256488',
              customer: 'MOORE',
              arrivalDate: DateTime(2025, 1, 30, 0, 0, 0),
              bound: 'OUT',
              priority: false,
              status: 2,
              type: 2),
          ContainerData(
              lotNbr: 41,
              containerNbr: 'BCDS3256489',
              customer: 'TAYLOR',
              arrivalDate: DateTime(2025, 1, 29, 0, 0, 0),
              bound: 'IN',
              priority: true,
              status: 4,
              type: 1)
        ],
        getContainerStatus: ContainerStatus.initial);
  }

  ContainerState copyWith({List<ContainerData>? containers, ContainerStatus? getContainerStatus, bool? isHovering, ContainerData? hoveredContainer}) {
    return ContainerState(
        containers: containers ?? this.containers,
        getContainerStatus: getContainerStatus ?? this.getContainerStatus,
        hoveredContainer: hoveredContainer ?? this.hoveredContainer,
        isHovering: isHovering ?? this.isHovering);
  }
}

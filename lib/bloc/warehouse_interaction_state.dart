part of 'warehouse_interaction_bloc.dart';

final class WarehouseInteractionState {
  WarehouseInteractionState({this.index, this.zoneID, this.rackID, this.binIndex});

  int? index;
  int? binIndex;
  String? zoneID;
  String? rackID;

  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(index: 0, zoneID: 'Z1', rackID: 'R1', binIndex: 0);
  }

  WarehouseInteractionState copyWith({int? index, String? zoneID, String? rackID, int? binIndex}) {
    return WarehouseInteractionState(
        index: index ?? this.index, zoneID: zoneID ?? this.zoneID, rackID: rackID ?? this.rackID, binIndex: binIndex ?? this.binIndex);
  }
}

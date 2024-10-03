part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }

final class WarehouseInteractionState {
  WarehouseInteractionState({this.index, this.zoneID, this.rackID, this.selectedID,this.object,this.objectData, this.getWarehouseDataState, this.racksData, this.selectedRack});

  int? index;
  String? selectedID;
  Rack? selectedRack;
  String? zoneID;
  String? rackID;
  String? object;
  Map? objectData;
  GetRacksDataState? getWarehouseDataState;
  List<Rack>? racksData;

  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(index: 0, zoneID: 'Z1', rackID: 'R1', selectedID: 'null', getWarehouseDataState: GetRacksDataState.initial);
  }

  WarehouseInteractionState copyWith({int? index, String? zoneID, String? rackID, String? selectedID,String? object,Map? objectData, GetRacksDataState? getWarehouseDataState, List<Rack>? racksData}) {
    return WarehouseInteractionState(
        index: index ?? this.index, zoneID: zoneID ?? this.zoneID, rackID: rackID ?? this.rackID, selectedID: selectedID ?? this.selectedID,object: object??this.object,objectData: objectData??this.objectData, getWarehouseDataState: getWarehouseDataState ?? this.getWarehouseDataState, racksData: racksData ?? this.racksData);
  }
}

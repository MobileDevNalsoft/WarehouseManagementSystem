part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }

final class WarehouseInteractionState {
  WarehouseInteractionState({this.index, this.zoneID, this.rackID, this.selectedBinID,this.object,this.objectData, this.getWarehouseDataState, this.racksData});

  int? index;
  String? selectedBinID;
  String? zoneID;
  String? rackID;
  String? object;
  Map? objectData;
  GetRacksDataState? getWarehouseDataState;
  List<Rack>? racksData;

  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(index: 0, zoneID: 'Z1', rackID: 'R1', selectedBinID: 'null', getWarehouseDataState: GetRacksDataState.initial);
  }

  WarehouseInteractionState copyWith({int? index, String? zoneID, String? rackID, String? selectedBinID,String? object,Map? objectData, GetRacksDataState? getWarehouseDataState, List<Rack>? racksData}) {
    return WarehouseInteractionState(
        index: index ?? this.index, zoneID: zoneID ?? this.zoneID, rackID: rackID ?? this.rackID, selectedBinID: selectedBinID ?? this.selectedBinID,object: object??this.object,objectData: objectData??this.objectData, getWarehouseDataState: getWarehouseDataState ?? this.getWarehouseDataState, racksData: racksData ?? this.racksData);
  }
}

part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }
enum GetStagingAreaDataState { initial, loading, success, failure }
enum GetActivityAreaDataState { initial, loading, success, failure }
enum GetReceivingAreaDataState { initial, loading, success, failure }
enum GetInspectionAreaDataState { initial, loading, success, failure }

final class WarehouseInteractionState {
  WarehouseInteractionState(
      {this.index,
      this.zoneID,
      this.rackID,
      this.selectedID,
      this.objectData,
      this.getRacksDataState,
      this.racksData,
      this.selectedRack,
      this.selectedBin,
      this.dataFromJS,
      this.receivingArea,
      this.inspectionArea,
      this.activityArea,
      this.statingArea,
      this.getStagingAreaDataState,
      this.getActivityAreaDataState,
      this.getReceivingAreaState,
      this.getInspectionAreaDataState});

  int? index;
  String? selectedID;
  Rack? selectedRack;
  Bin? selectedBin;
  ReceivingArea? receivingArea;
  InspectionArea? inspectionArea;
  ActivityArea? activityArea;
  StatingArea? statingArea;
  String? zoneID;
  String? rackID;
  Map? objectData;
  Map<String, dynamic>? dataFromJS;
  GetRacksDataState? getRacksDataState;
  GetStagingAreaDataState? getStagingAreaDataState;
  GetActivityAreaDataState? getActivityAreaDataState;
  GetReceivingAreaDataState? getReceivingAreaState;
  GetInspectionAreaDataState? getInspectionAreaDataState;
  List<Rack>? racksData;

  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(
        index: 0,
        zoneID: 'Z1',
        rackID: 'R1',
        selectedID: 'null',
        getRacksDataState: GetRacksDataState.initial,
        dataFromJS: {"object": "null"});
  }

  WarehouseInteractionState copyWith(
      {int? index,
      String? zoneID,
      String? rackID,
      String? selectedID,
      bool? selectedObject,
      Map? objectData,
      GetRacksDataState? getRacksDataState,
      GetStagingAreaDataState? getStagingAreaDataState,
  GetActivityAreaDataState? getActivityAreaDataState,
  GetReceivingAreaDataState? getReceivingAreaState,
  GetInspectionAreaDataState? getInspectionAreaDataState,
      List<Rack>? racksData,
      Rack? selectedRack,
      Map<String, dynamic>? dataFromJS,
      Bin? selectedBin,
      ReceivingArea? receivingArea,
      InspectionArea? inspectionArea,
      ActivityArea? activityArea,
      StatingArea? statingArea}) {
    return WarehouseInteractionState(
        index: index ?? this.index,
        zoneID: zoneID ?? this.zoneID,
        rackID: rackID ?? this.rackID,
        selectedID: selectedID ?? this.selectedID,
        objectData: objectData ?? this.objectData,
        getRacksDataState: getRacksDataState ?? this.getRacksDataState,
        getStagingAreaDataState: getStagingAreaDataState ?? this.getStagingAreaDataState,
        getActivityAreaDataState: getActivityAreaDataState ?? this.getActivityAreaDataState,
        getReceivingAreaState: getReceivingAreaState ?? getReceivingAreaState,
        getInspectionAreaDataState: getInspectionAreaDataState ?? this.getInspectionAreaDataState,
        racksData: racksData ?? this.racksData,
        selectedRack: selectedRack ?? this.selectedRack,
        dataFromJS: dataFromJS ?? this.dataFromJS,
        selectedBin: selectedBin ?? this.selectedBin,
        receivingArea: receivingArea ?? this.receivingArea,
        inspectionArea: inspectionArea ?? this.inspectionArea,
        activityArea: activityArea ?? this.activityArea,
        statingArea: statingArea ?? this.statingArea);
  }
}

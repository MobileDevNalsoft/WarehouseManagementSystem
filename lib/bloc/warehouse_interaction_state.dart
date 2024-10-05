part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }

enum GetStagingAreaDataState { initial, loading, success, failure }

enum GetActivityAreaDataState { initial, loading, success, failure }

enum GetReceivingAreaDataState { initial, loading, success, failure }

enum GetInspectionAreaDataState { initial, loading, success, failure }

final class WarehouseInteractionState extends Equatable{
  WarehouseInteractionState(
      {this.getRacksDataState,
      this.racksData,
      this.selectedRack,
      this.selectedBin,
      this.dataFromJS,
      this.receivingArea,
      this.inspectionArea,
      this.activityArea,
      this.stagingArea,
      this.getStagingAreaDataState,
      this.getActivityAreaDataState,
      this.getReceivingAreaDataState,
      this.getInspectionAreaDataState});

  Rack? selectedRack;
  Bin? selectedBin;
  ReceivingArea? receivingArea;
  InspectionArea? inspectionArea;
  ActivityArea? activityArea;
  StagingArea? stagingArea;
  Map<String, dynamic>? dataFromJS;
  GetRacksDataState? getRacksDataState;
  GetStagingAreaDataState? getStagingAreaDataState;
  GetActivityAreaDataState? getActivityAreaDataState;
  GetReceivingAreaDataState? getReceivingAreaDataState;
  GetInspectionAreaDataState? getInspectionAreaDataState;
  List<Rack>? racksData;

  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(
        getRacksDataState: GetRacksDataState.initial,
        getStagingAreaDataState: GetStagingAreaDataState.initial,
        getActivityAreaDataState: GetActivityAreaDataState.initial,
        getReceivingAreaDataState: GetReceivingAreaDataState.initial,
        getInspectionAreaDataState: GetInspectionAreaDataState.initial,
        dataFromJS: const {"object": "null"});
  }

  WarehouseInteractionState copyWith(
      {GetRacksDataState? getRacksDataState,
      GetStagingAreaDataState? getStagingAreaDataState,
      GetActivityAreaDataState? getActivityAreaDataState,
      GetReceivingAreaDataState? getReceivingAreaDataState,
      GetInspectionAreaDataState? getInspectionAreaDataState,
      List<Rack>? racksData,
      Rack? selectedRack,
      Map<String, dynamic>? dataFromJS,
      Bin? selectedBin,
      ReceivingArea? receivingArea,
      InspectionArea? inspectionArea,
      ActivityArea? activityArea,
      StagingArea? stagingArea}) {
    return WarehouseInteractionState(
        getRacksDataState: getRacksDataState ?? this.getRacksDataState,
        getStagingAreaDataState:
            getStagingAreaDataState ?? this.getStagingAreaDataState,
        getActivityAreaDataState:
            getActivityAreaDataState ?? this.getActivityAreaDataState,
        getReceivingAreaDataState: getReceivingAreaDataState ?? this.getReceivingAreaDataState,
        getInspectionAreaDataState:
            getInspectionAreaDataState ?? this.getInspectionAreaDataState,
        racksData: racksData ?? this.racksData,
        selectedRack: selectedRack ?? this.selectedRack,
        dataFromJS: dataFromJS ?? this.dataFromJS,
        selectedBin: selectedBin ?? this.selectedBin,
        receivingArea: receivingArea ?? this.receivingArea,
        inspectionArea: inspectionArea ?? this.inspectionArea,
        activityArea: activityArea ?? this.activityArea,
        stagingArea: stagingArea ?? this.stagingArea);
  }

  @override
  List<Object?> get props => [
        selectedRack,
        selectedBin,
        receivingArea,
        inspectionArea,
        activityArea,
        stagingArea,
        dataFromJS,
        getRacksDataState,
        getStagingAreaDataState,
        getActivityAreaDataState,
        getReceivingAreaDataState,
        getInspectionAreaDataState,
        racksData
      ];
}

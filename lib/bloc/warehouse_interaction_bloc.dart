import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:three_js/three_js.dart';
import 'package:warehouse_3d/models/activity_area_model.dart';
import 'package:warehouse_3d/models/inspection_area_model.dart';
import 'package:warehouse_3d/models/rack_model.dart';
import 'package:warehouse_3d/models/receiving_area_model.dart';
import 'package:warehouse_3d/models/staging_area_model.dart';

import '../logger/logger.dart';

part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc
    extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  WarehouseInteractionBloc() : super(WarehouseInteractionState.initial()) {
    on<SelectedRackOfIndex>(_onSelectedRackOfIndex);
    on<SelectedID>(_onSelectedID);
    on<SelectedObject>(_onSelectedObject);
    on<GetRacksData>(_onGetRacksData);
    on<SelectedRack>(_onSelectedRack);
    on<SelectedBin>(_onSelectedBin);
    on<SelectedArea>(_onSelectedArea);
  }

  void _onSelectedRack(
      SelectedRack event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(
        selectedRack:
            state.racksData!.where((e) => e.rackID == event.rackID).first));
  }

  void _onSelectedBin(
      SelectedBin event, Emitter<WarehouseInteractionState> emit) {
    print('selected rack in selected bin ${state.selectedRack}');
    emit(state.copyWith(
        selectedBin: state.selectedRack!.bins!
            .where((e) => e.binID == event.binID)
            .first));
    print('selected bin ${state.selectedBin}');
  }

  Future<void> _onSelectedArea(
      SelectedArea event, Emitter<WarehouseInteractionState> emit) async {
    if (event.areaName == 'stagingArea') {
      emit(state.copyWith(getStagingAreaDataState: GetStagingAreaDataState.loading));
      await rootBundle.loadString("assets/jsons/staging_area.json").then(
        (value) {
          Log.d(value);
          emit(state.copyWith(
              statingArea: StatingArea.fromJson(jsonDecode(value)),
              getStagingAreaDataState: GetStagingAreaDataState.success));
          print('staging data ${state.statingArea}');
        },
      ).onError(
        (error, stackTrace) {
          emit(state.copyWith(getStagingAreaDataState: GetStagingAreaDataState.failure));
        },
      );
    } else if (event.areaName == 'activityArea') {
      emit(state.copyWith(getActivityAreaDataState: GetActivityAreaDataState.loading));
      await rootBundle.loadString("assets/jsons/activity_area.json").then(
        (value) {
          Log.d(value);
          emit(state.copyWith(
              activityArea: ActivityArea.fromJson(jsonDecode(value)),
              getActivityAreaDataState: GetActivityAreaDataState.success));
          print('activity data ${state.activityArea}');
        },
      ).onError(
        (error, stackTrace) {
          emit(state.copyWith(getActivityAreaDataState: GetActivityAreaDataState.failure));
        },
      );
    } else if (event.areaName == 'receivingArea') {
      emit(state.copyWith(getReceivingAreaState: GetReceivingAreaDataState.loading));
      await rootBundle.loadString("assets/jsons/receiving_area.json").then(
        (value) {
          Log.d(value);
          emit(state.copyWith(
              receivingArea: ReceivingArea.fromJson(jsonDecode(value)),
              getReceivingAreaState: GetReceivingAreaDataState.success));
          print('receiving data ${state.receivingArea}');
        },
      ).onError(
        (error, stackTrace) {
          emit(state.copyWith(getReceivingAreaState: GetReceivingAreaDataState.failure));
        },
      );
    } else {
      emit(state.copyWith(getInspectionAreaDataState: GetInspectionAreaDataState.loading));
      await rootBundle.loadString("assets/jsons/inspection_area.json").then(
        (value) {
          Log.d(value);
          emit(state.copyWith(
              inspectionArea: InspectionArea.fromJson(jsonDecode(value)),
              getInspectionAreaDataState: GetInspectionAreaDataState.success));
          print('inspection data ${state.inspectionArea}');
        },
      ).onError(
        (error, stackTrace) {
          emit(state.copyWith(getInspectionAreaDataState: GetInspectionAreaDataState.failure));
        },
      );
    }
  }

  void _onSelectedRackOfIndex(
      SelectedRackOfIndex event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(index: event.index, rackID: event.rackID));
  }

  void _onSelectedID(
      SelectedID event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(selectedID: event.ID));
    if (event.ID.contains('rack')) {
      emit(state.copyWith(
          selectedRack: state.racksData!
              .where((e) => e.rackID == state.selectedID)
              .first));
    } else {
      print('selected rack ${state.selectedRack}');
      emit(state.copyWith(
          selectedBin: state.selectedRack!.bins!
              .where((e) => e.binID == state.selectedID)
              .first));
      print('selected bin ${state.selectedBin}');
    }
  }

  void _onSelectedObject(
      SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.dataFromJS}');
    emit(state.copyWith(dataFromJS: event.dataFromJS));
    if (state.dataFromJS!.keys.first != 'object') {
      if (state.getRacksDataState == GetRacksDataState.initial) {
        add(GetRacksData());
      }
    }
  }

  Future<void> _onGetRacksData(
      GetRacksData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getRacksDataState: GetRacksDataState.loading));
    await rootBundle.loadString("assets/jsons/racks.json").then(
      (value) {
        Log.d(value);
        emit(state.copyWith(
            racksData: (jsonDecode(value)["racks"] as List)
                .map((e) => Rack.fromJson(e))
                .toList(),
            getRacksDataState: GetRacksDataState.success));
        print('racks data ${state.racksData}');
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(getRacksDataState: GetRacksDataState.failure));
      },
    );
  }
}

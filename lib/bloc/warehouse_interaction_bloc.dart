import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:warehouse_3d/js_inter.dart';
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
  JsInteropService? jsInteropService;
  WarehouseInteractionBloc({this.jsInteropService}) : super(WarehouseInteractionState.initial()) {
    on<SelectedObject>(_onSelectedObject);
    on<GetRacksData>(_onGetRacksData);
    on<SelectedRack>(_onSelectedRack);
    on<SelectedBin>(_onSelectedBin);
    on<GetStagingAreaData>(_onGetStagingAreaData);
    on<GetActivityAreaData>(_onGetActivityAreaData);
    on<GetReceivingAreaData>(_onGetReceivingAreaData);
    on<GetInspectionAreaData>(_onGetInspectionAreaData);
  }

  void _onSelectedRack(
      SelectedRack event, Emitter<WarehouseInteractionState> emit) {
    print('racks data on selected rack ${state.racksData}');
    emit(state.copyWith(
        selectedRack:
            state.racksData!.where((e) => e.rackID == event.rackID).first));
    jsInteropService!.isRackDataLoaded(true);
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

  Future<void> _onGetStagingAreaData(
      GetStagingAreaData event, Emitter<WarehouseInteractionState> emit) async {
      emit(state.copyWith(getStagingAreaDataState: GetStagingAreaDataState.loading));
      await rootBundle.loadString("assets/jsons/staging_area.json").then(
        (value) {
          Log.d(value);
          emit(state.copyWith(
              stagingArea: StagingArea.fromJson(jsonDecode(value)),
              getStagingAreaDataState: GetStagingAreaDataState.success));
          print('staging data ${state.stagingArea}');
        },
      ).onError(
        (error, stackTrace) {
          emit(state.copyWith(getStagingAreaDataState: GetStagingAreaDataState.failure));
        },
      );
  }

  Future<void> _onGetActivityAreaData(
      GetActivityAreaData event, Emitter<WarehouseInteractionState> emit) async {
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
  }

  Future<void> _onGetReceivingAreaData(
      GetReceivingAreaData event, Emitter<WarehouseInteractionState> emit) async {
      emit(state.copyWith(getReceivingAreaDataState: GetReceivingAreaDataState.loading));
      await rootBundle.loadString("assets/jsons/receiving_area.json").then(
        (value) {
          Log.d(value);
          emit(state.copyWith(
              receivingArea: ReceivingArea.fromJson(jsonDecode(value)),
              getReceivingAreaDataState: GetReceivingAreaDataState.success));
          print('receiving data ${state.receivingArea}');
        },
      ).onError(
        (error, stackTrace) {
           print(error.toString());
          emit(state.copyWith(getReceivingAreaDataState: GetReceivingAreaDataState.failure));
        },
      );
  }

  Future<void> _onGetInspectionAreaData(
      GetInspectionAreaData event, Emitter<WarehouseInteractionState> emit) async {
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

  void _onSelectedObject(
      SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.dataFromJS}');
    emit(state.copyWith(dataFromJS: event.dataFromJS));
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

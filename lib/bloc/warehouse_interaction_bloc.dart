import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:three_js/three_js.dart';
import 'package:warehouse_3d/models/rack_model.dart';

import '../logger/logger.dart';

part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  WarehouseInteractionBloc() : super(WarehouseInteractionState.initial()) {
    on<SelectedRackOfIndex>(_onSelectedRackOfIndex);
    on<SelectedBinID>(_onSelectedBinID);
    on<SelectedObject>(_onSelectedObject);
    on<GetRacksData>(_onGetRacksData);
  }

  void _onSelectedRackOfIndex(SelectedRackOfIndex event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(index: event.index, rackID: event.rackID));
  }

  void _onSelectedBinID(SelectedBinID event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(selectedBinID: event.binID));
  }

  void _onSelectedObject(SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    
    emit(state.copyWith(object: event.object));
  }

  Future<void> _onGetRacksData(GetRacksData event, Emitter<WarehouseInteractionState> emit) async {
    emit(state.copyWith(getWarehouseDataState: GetRacksDataState.loading));
    await rootBundle.loadString("assets/jsons/racks.json").then(
      (value) {
        Log.d(value);
        emit(state.copyWith(racksData: (jsonDecode(value)["racks"] as List).map((e) => Rack.fromJson(jsonDecode(value)["racks"])).toList(), getWarehouseDataState: GetRacksDataState.success));
      },
    ).onError(
      (error, stackTrace) {
        emit(state.copyWith(getWarehouseDataState: GetRacksDataState.failure));
      },
    );
  }
}

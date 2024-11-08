import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/models/activity_area_model.dart';
import 'package:warehouse_3d/models/inspection_area_model.dart';
import 'package:warehouse_3d/models/rack_model.dart';
import 'package:warehouse_3d/models/receiving_area_model.dart';
import 'package:warehouse_3d/models/staging_area_model.dart';

import '../../logger/logger.dart';

part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  JsInteropService? jsInteropService;
  WarehouseInteractionBloc({this.jsInteropService}) : super(WarehouseInteractionState.initial()) {
    on<SelectedObject>(_onSelectedObject);
    on<ModelLoaded>(_onModelLoaded);

  }

  void _onSelectedObject(SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.dataFromJS}');
    emit(state.copyWith(dataFromJS: event.dataFromJS));
  }
  
  void _onModelLoaded(ModelLoaded event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.isLoaded}');
    emit(state.copyWith(isModelLoaded: event.isLoaded));
  }

}

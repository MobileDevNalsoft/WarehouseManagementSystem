import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  WarehouseInteractionBloc() : super(WarehouseInteractionState.initial()) {
    on<SelectedRackOfIndex>(_onSelectedRackOfIndex);
    on<SelectedBinOfIndex>(_onSelectedBinOfIndex);
    on<SelectedObject>(_onSelectedObject);
  }

  void _onSelectedRackOfIndex(SelectedRackOfIndex event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(index: event.index, rackID: event.rackID));
  }

  void _onSelectedBinOfIndex(SelectedBinOfIndex event, Emitter<WarehouseInteractionState> emit) {
    emit(state.copyWith(binIndex: event.index));
  }
  
  void _onSelectedObject(SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    
    emit(state.copyWith(object: event.object));
  }
  
}

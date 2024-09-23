import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  WarehouseInteractionBloc() : super(WarehouseInteractionState.initial()) {
    on<SelectedRackOfIndex>(_onSelectedRackOfIndex);
    on<HotspotCreated>(_onHotspotCreated);
    
  }

  void _onSelectedRackOfIndex(SelectedRackOfIndex event, Emitter<WarehouseInteractionState> emit){
    emit(state.copyWith(index: event.index));
  }

    void _onHotspotCreated(HotspotCreated event, Emitter<WarehouseInteractionState> emit){
    emit(state.copyWith(hotspot: event.hotspot));
  }
}

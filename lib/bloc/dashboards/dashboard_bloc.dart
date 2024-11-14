
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';

import '../../local_network_calls.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardsBloc extends Bloc<DashboardsEvent, DashboardsState> {
  JsInteropService? jsInteropService;
  DashboardsBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(DashboardsState.initial()) {
    on<DashboardChanged>(_onDashboardChanged);
  }
  final NetworkCalls _customApi;

  void _onDashboardChanged(DashboardChanged event, Emitter<DashboardsState> emit){
    emit(state.copyWith(index: event.index));
  }
}

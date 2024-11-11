import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/logger/logger.dart';
import 'package:warehouse_3d/models/activity_area_model.dart';
import 'package:warehouse_3d/network_util.dart';

import '../../local_network_calls.dart';
import '../../models/area_response.dart';

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

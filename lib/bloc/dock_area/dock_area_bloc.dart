import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/logger/logger.dart';
import 'package:warehouse_3d/models/dock_area_model.dart';

import '../../local_network_calls.dart';
import '../../models/area_response.dart';

part 'dock_area_event.dart';
part 'dock_area_state.dart';

class DockAreaBloc extends Bloc<DockEvent, DockAreaState> {
  JsInteropService? jsInteropService;
  DockAreaBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(DockAreaState.initial()) {
    on<GetDockAreaData>(_onGetDockAreaData);
  }
  final NetworkCalls _customApi;

  Future<void> _onGetDockAreaData(GetDockAreaData event, Emitter<DockAreaState> emit) async {
    try {
      await _customApi.get(AppConstants.DOCK_AREA, queryParameters: {"facility_id": 243, "page_num": state.pageNum}).then((apiResponse) {
        AreaResponse<DockAreaItem> dockAreaResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => DockAreaItem.fromJson(json));
        state.dockAreaItems!.addAll(dockAreaResponse.data!);
        state.getDataState = GetDataState.initial;
        emit(state.copyWith(dockAreaItems: state.dockAreaItems, getDataState: GetDataState.success));
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getDataState: GetDataState.failure));
    }
  }
}

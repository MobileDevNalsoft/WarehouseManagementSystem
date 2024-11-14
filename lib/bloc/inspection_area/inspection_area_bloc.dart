import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/logger/logger.dart';

import '../../local_network_calls.dart';
import '../../models/area_response.dart';
import '../../models/inspection_area_model.dart';

part 'inspection_area_event.dart';
part 'inspection_area_state.dart';

class InspectionAreaBloc extends Bloc<InspectionEvent, InspectionAreaState> {
  JsInteropService? jsInteropService;
  InspectionAreaBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(InspectionAreaState.initial()) {
    on<GetInspectionAreaData>(_onGetInspectionAreaData);
  }
  final NetworkCalls _customApi;

  Future<void> _onGetInspectionAreaData(GetInspectionAreaData event, Emitter<InspectionAreaState> emit) async {
    try {
      await _customApi.get(AppConstants.INSPECTION_AREA, queryParameters: {"facility_id": 243, "page_num": state.pageNum}).then((apiResponse) {
        AreaResponse<InspectionAreaItem> dockAreaResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => InspectionAreaItem.fromJson(json));
        state.inspectionAreaItems!.addAll(dockAreaResponse.data!);
        emit(state.copyWith(inspectionAreaItems: state.inspectionAreaItems, getDataState: GetDataState.success));
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getDataState: GetDataState.failure));
    }
  }
}

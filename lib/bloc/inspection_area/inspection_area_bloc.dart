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
    List<dynamic> checkList = ["Not Empty"];
    int pageNum = 0;

    while (checkList.isNotEmpty) {
      try {
        emit(state.copyWith(getDataState: GetDataState.initial));
        await _customApi
            .get(event.searchText!=null ? AppConstants.SEARCH : AppConstants.INSPECTION_AREA,
                queryParameters: event.searchText!=null
                    ? {"search_text": event.searchText, "search_area": "INSPECTION", "facility_id": '243', "page_num": pageNum}
                    : {"facility_id": '243', "page_num": pageNum})
            .then((apiResponse) {
          AreaResponse<InspectionAreaItem> inspectionAreaResponse =
              AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => InspectionAreaItem.fromJson(json));
          state.inspectionAreaItems!.addAll(inspectionAreaResponse.data!);
          emit(state.copyWith(inspectionAreaItems: state.inspectionAreaItems, getDataState: GetDataState.success));
          // emit(state.copyWith(getDataState: GetDataState.initial));
          checkList = jsonDecode(apiResponse.response!.data)["data"];
          pageNum += 1;
        });
      } catch (e) {
        Log.e(e.toString());
      }
    }
  }
}

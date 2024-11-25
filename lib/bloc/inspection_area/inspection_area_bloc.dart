import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/logger/logger.dart';

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
      emit(state.copyWith(getDataState: GetDataState.initial,inspectionAreaItems: state.pageNum==0?[]:state.inspectionAreaItems));
      await _customApi.get( (event.searchText != null && event.searchText!="")? AppConstants.SEARCH : AppConstants.INSPECTION_AREA,
                queryParameters: (event.searchText!=null && event.searchText!="")
                    ? {"search_text": event.searchText, "search_area": "INSPECTION", "facility_id": '243', "page_num": state.pageNum}
                    : {"facility_id": '243', "page_num": state.pageNum}).then((apiResponse) {
        AreaResponse<InspectionAreaItem> dockAreaResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => InspectionAreaItem.fromJson(json));
        if(state.pageNum==0){

        state.inspectionAreaItems = dockAreaResponse.data!;
        }
        else{
          state.inspectionAreaItems!.addAll(dockAreaResponse.data!);
        }

        emit(state.copyWith(inspectionAreaItems: state.inspectionAreaItems, getDataState: GetDataState.success));
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getDataState: GetDataState.failure));
    }
  }
}

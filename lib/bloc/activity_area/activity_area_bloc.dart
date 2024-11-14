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

part 'activity_area_event.dart';
part 'activity_area_state.dart';

class ActivityAreaBloc extends Bloc<ActivityAreaEvent, ActivityAreaState> {
  JsInteropService? jsInteropService;
  ActivityAreaBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(ActivityAreaState.initial()) {
    on<GetActivityAreaData>(_onGetActivityAreaData);
  }
  final NetworkCalls _customApi;

  Future<void> _onGetActivityAreaData(GetActivityAreaData event, Emitter<ActivityAreaState> emit) async {
    try {
      emit(state.copyWith(getDataState: GetDataState.initial));
      await _customApi.get(event.searchText!=null ? AppConstants.SEARCH :AppConstants.ACTIVITY_AREA, queryParameters:event.searchText!=null
                    ? {"search_text": event.searchText, "search_area": "ACTIVITY", "facility_id": '243', "page_num": state.pageNum}: {"facility_id": 243, "page_num": state.pageNum}).then((apiResponse) {
        AreaResponse<ActivityAreaItem> activityAreaResponse =
            AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => ActivityAreaItem.fromJson(json));
        if(state.pageNum==0){
        state.activityAreaItems= activityAreaResponse.data!;  
        }
        else{
        state.activityAreaItems!.addAll(activityAreaResponse.data!);
        }    
        state.getDataState = GetDataState.initial;
        emit(state.copyWith(activityAreaItems: state.activityAreaItems, getDataState: GetDataState.success));
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getDataState: GetDataState.failure));
    }
  }
}

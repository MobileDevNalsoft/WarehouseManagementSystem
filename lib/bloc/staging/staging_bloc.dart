import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/staging/staging_event.dart';
import 'package:wmssimulator/bloc/staging/staging_state.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/models/area_response.dart';
import 'package:wmssimulator/models/staging_area_model.dart';

import '../../local_network_calls.dart';

class StagingBloc  extends Bloc<StagingEvent,StagingState>{

  StagingBloc({required NetworkCalls customApi}) : _customApi = customApi,super(StagingState.initial()){
    on<GetStagingData>(_onGetStagingData);
  }


  final NetworkCalls _customApi;


  void _onGetStagingData(GetStagingData event, Emitter<StagingState> emit) async {
    try {
      emit(state.copyWith(stagingStatus:StagingAreaStatus.initial,stagingList: state.pageNum==0?[]: state.stagingList!));
      await _customApi.get(
        (event.searchText!=null&& event.searchText!="") ? AppConstants.SEARCH :
        AppConstants.STAGING_AREA,
        queryParameters: (event.searchText != null && event.searchText!="")
                    ? {"search_text": event.searchText, "search_area": "STAGING", "facility_id": '243', "page_num": state.pageNum}: {"facility_id": 243},
    ).then((value) {
       AreaResponse<StagingAreaItem> stagingAreaData = AreaResponse.fromJson(jsonDecode(value.response!.data), (json) => StagingAreaItem.fromJson(json));
        if (state.pageNum == 0) {
          state.stagingList = stagingAreaData.data;
        } else {
          state.stagingList!.addAll(stagingAreaData.data!);
        }

        emit(state.copyWith(stagingStatus: StagingAreaStatus.success, stagingList: state.stagingList!));
       
      });
    } catch (e) {
      print("error $e");
    }
  }
}
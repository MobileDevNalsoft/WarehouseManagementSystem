import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_3d/bloc/staging/staging_event.dart';
import 'package:warehouse_3d/bloc/staging/staging_state.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/models/staging_area_model.dart';

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
        event.searchText!=null ? AppConstants.SEARCH :
        AppConstants.STAGING_AREA,
        queryParameters:event.searchText!=null
                    ? {"search_text": event.searchText, "search_area": "STAGING", "facility_id": '243', "page_num": state.pageNum}: {"facility_id": 243, "page_num": state.pageNum},
    ).then((value) {
       StagingArea stagingArea = StagingArea.fromJson(jsonDecode(value.response!.data));
       if(state.pageNum==0){
      state.stagingList=stagingArea.data!;
       }
       else{
       state.stagingList!.addAll(stagingArea.data!);
       }
       emit(state.copyWith(stagingArea: stagingArea,stagingStatus:StagingAreaStatus.success,stagingList: state.stagingList!));
       
      });
    } catch (e) {
      print("error $e");
    }
  }
}
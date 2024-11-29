import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_event.dart';
import 'package:wmssimulator/bloc/receiving/receiving_state.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/models/receiving_area_model.dart';

import '../../local_network_calls.dart';

class ReceivingBloc extends Bloc<ReceivingEvent, ReceivingState> {
  ReceivingBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(ReceivingState.initial()) {
    on<GetReceivingData>(_onGetReceivingData);
  }

  final NetworkCalls _customApi;

  void _onGetReceivingData(GetReceivingData event, Emitter<ReceivingState> emit) async {
    try {
      if(state.pageNum == 0){
        emit(state.copyWith(receiveList: [], receivingStatus: ReceivingAreaStatus.initial));
      }
      await _customApi
          .get(
         (event.searchText != null && event.searchText!="")? AppConstants.SEARCH : AppConstants.RECEIVING_AREA,
        queryParameters: (event.searchText != null&& event.searchText!="")
            ? {"search_text": event.searchText, "search_area": "RECEIVING", "facility_id": '243', "page_num": state.pageNum}
            : {"facility_id": 243, "page_num": state.pageNum},
      )
          .then((value) {
        ReceivingArea receivingArea = ReceivingArea.fromJson(jsonDecode(value.response!.data));
        if (state.pageNum == 0) {
          state.receiveList = receivingArea.data;
        } else {
          state.receiveList!.addAll(receivingArea.data!);
        }

        emit(state.copyWith(receivingArea: receivingArea, receivingStatus: ReceivingAreaStatus.success, receiveList: state.receiveList!));
      });
    } catch (e) {
      print("error $e");
    }
  }
}


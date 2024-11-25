import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/models/dashboard_response.dart';
import 'package:wmssimulator/models/yard_area_model.dart';

import '../../local_network_calls.dart';
import '../../logger/logger.dart';
import '../../models/area_response.dart';

part 'yard_event.dart';
part 'yard_state.dart';

class YardBloc extends Bloc<YardEvent, YardState> {
  YardBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(YardState.initial()) {
    on<GetYardData>(_onGetYardData);
  }
  final NetworkCalls _customApi;

  void _onGetYardData(GetYardData event, Emitter<YardState> emit) async {
    try {
      await _customApi
          .get((event.searchText != null&& event.searchText!="") ? AppConstants.SEARCH : AppConstants.YARD_AREA,
              queryParameters: (event.searchText != null && event.searchText!="")
                  ? {"search_text": event.searchText, "search_area": "YARD", "facility_id": '243', "page_num": state.pageNum}
                  : {"facility_id": 243, "page_num": state.pageNum})
          .then((apiResponse) {
        AreaResponse<YardAreaItem> dockAreaResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => YardAreaItem.fromJson(json));

        if (state.pageNum == 0) {
          state.yardAreaItems = dockAreaResponse.data;
        } else {
          state.yardAreaItems!.addAll(dockAreaResponse.data!);
        }
        emit(state.copyWith(yardAreaItems: state.yardAreaItems, yardAreaStatus: YardAreaStatus.success));
        getIt<JsInteropService>().setNumberOfTrucks(state.yardAreaItems!.length.toString());
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(yardAreaStatus: YardAreaStatus.failure));
    }
  }

}

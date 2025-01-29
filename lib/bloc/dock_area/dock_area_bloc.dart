import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/logger/logger.dart';
import 'package:wmssimulator/models/dock_area_model.dart';

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
    on<GetDockOutAreaData>(_onGetDockOutAreaData);
  }
  final NetworkCalls _customApi;

  Future<void> _onGetDockAreaData(GetDockAreaData event, Emitter<DockAreaState> emit) async {
    try {
      emit(state.copyWith(dockAreaItems: state.pageNum == 0 ? [] : state.dockAreaItems, getDataState: GetDataState.initial));
      await _customApi
          .get((event.searchText != null && event.searchText != "") ? AppConstants.SEARCH : AppConstants.DOCK_AREA,
              queryParameters: (event.searchText != null && event.searchText != "")
                  ? {"search_text": event.searchText, "search_area": event.searchArea, "facility_id": '243', "page_num": state.pageNum}
                  : {"facility_id": 243})
          .then((apiResponse) {
        AreaResponse<DockAreaItem> dockAreaResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => DockAreaItem.fromJson(json));
        if (state.pageNum == 0) {
          state.dockAreaItems = dockAreaResponse.data!;
        } else {
          state.dockAreaItems!.addAll(dockAreaResponse.data!);
        }
        List<Map<String, dynamic>> trucksData = [];
        (jsonDecode(apiResponse.response!.data)['data'] as List<dynamic>).forEach((e) {
          trucksData.add({'truck_no': e.keys.first, 'vendor': e.values.first.first.keys.first, 'asn': e.values.first.first.values.first.first['asn']});
        });
        if (apiResponse.response?.data != null) {
          getIt<JsInteropService>().sendTrucksData(jsonEncode(trucksData));
        }
        emit(state.copyWith(dockAreaItems: state.dockAreaItems, getDataState: GetDataState.success));
        getIt<JsInteropService>().setNumberOfTrucks("DI_0");
        getIt<JsInteropService>().setNumberOfTrucks('DI_${state.dockAreaItems!.length.toString()}');
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getDataState: GetDataState.failure));
    }
  }

  Future<void> _onGetDockOutAreaData(GetDockOutAreaData event, Emitter<DockAreaState> emit) async {
    try {
      emit(state.copyWith(dockAreaItems: state.pageNum == 0 ? [] : state.dockAreaItems, getDataState: GetDataState.initial));
      await _customApi
          .get((event.searchText != null && event.searchText != "") ? AppConstants.SEARCH : AppConstants.DOCK_AREA_OUT,
              queryParameters: (event.searchText != null && event.searchText != "")
                  ? {"search_text": event.searchText, "search_area": event.searchArea, "facility_id": '243', "page_num": state.pageNum}
                  : {"facility_id": 243})
          .then((apiResponse) {
        AreaResponse<DockAreaOut> dockAreaOutResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => DockAreaOut.fromJson(json));
        state.dockAreaOut = dockAreaOutResponse.data!;
     
        emit(state.copyWith(dockAreaOut: state.dockAreaOut, getDataState: GetDataState.success));
     
      });
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getDataState: GetDataState.failure));
    }
  }



}

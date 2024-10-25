import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/models/yard_area_model.dart';

import '../../local_network_calls.dart';

part 'yard_event.dart';
part 'yard_state.dart';

class YardBloc extends Bloc<YardEvent, YardState> {
  YardBloc() : super(YardState.initial()) {
    on<AddYardData>(_onAddYardData);
  }
  NetworkCalls _customApi = NetworkCalls(AppConstants.BASEURL, Dio(), connectTimeout: 30, receiveTimeout: 30,username: "nalsoft_adm",password: "P@s\$w0rd2024");
  AppConstants appConstants = getIt<AppConstants>();

  void _onAddYardData(AddYardData event, Emitter<YardState> emit) async {
    print("inside bloc");
    try {
      await _customApi.get(
        AppConstants.INVENTORY_HISTORY,
        queryParameters: {"company_id": 399, "facility_id": 243, "history_activity_id": 81, "status_id": 0, "to_location__contains": "YD"},
    ).then((value) {
      print(value.response!.data["results"].runtimeType);
        YardArea yardArea = YardArea.fromJson(value.response!.data);
        print(" response ${yardArea.resultCount}");
        emit( state.copyWith(yardAreaStatus: YardAreaStatus.success,   yardArea: yardArea));
        getIt<JsInteropService>().setNumberOfTrucks(state.yardArea!.resultCount.toString());
        print("yard area status ${state.yardAreaStatus}");
        
        
      });
    } catch (e) {
      print("error ${e}");
    }
  }
}

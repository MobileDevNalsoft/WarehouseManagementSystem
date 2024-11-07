import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/models/yard_area_model.dart';

import '../../local_network_calls.dart';

part 'yard_event.dart';
part 'yard_state.dart';

class YardBloc extends Bloc<YardEvent, YardState> {
  YardBloc({required NetworkCalls customApi}) : _customApi = customApi,super(YardState.initial()) {
    on<GetYardData>(_onGetYardData);
  }
  final NetworkCalls _customApi;

  void _onGetYardData(GetYardData event, Emitter<YardState> emit) async {
    try {
      await _customApi.get(
        AppConstants.YARD_AREA,
        queryParameters: {"facility_id": 243, "page_num": 0},
    ).then((value) {
      print(jsonDecode(value.response!.data)["data"]);
        // YardArea yardArea = YardArea.fromJson(value.response!.data);
        // print(" response ${yardArea.resultCount}");
        // emit( state.copyWith(yardAreaStatus: YardAreaStatus.success,   yardArea: yardArea));
        // getIt<JsInteropService>().setNumberOfTrucks(state.yardArea!.resultCount.toString());
        // print("yard area status ${state.yardAreaStatus}");
      });
    } catch (e) {
      print("error ${e}");
    }
  }
}

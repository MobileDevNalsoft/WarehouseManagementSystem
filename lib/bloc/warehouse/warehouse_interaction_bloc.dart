
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/local_network_calls.dart';


part 'warehouse_interaction_event.dart';
part 'warehouse_interaction_state.dart';

class WarehouseInteractionBloc extends Bloc<WarehouseInteractionEvent, WarehouseInteractionState> {
  JsInteropService? jsInteropService;
  WarehouseInteractionBloc({this.jsInteropService}) : super(WarehouseInteractionState.initial()) {
    on<SelectedObject>(_onSelectedObject);
    on<ModelLoaded>(_onModelLoaded);

  }
final NetworkCalls _companyApi = NetworkCalls(AppConstants.WMS_URL, getIt<Dio>(), connectTimeout: 30, receiveTimeout: 30, maxRedirects: 5);
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  void _onSelectedObject(SelectedObject event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.dataFromJS}');
    emit(state.copyWith(dataFromJS: event.dataFromJS));
  }
  
  void _onModelLoaded(ModelLoaded event, Emitter<WarehouseInteractionState> emit) {
    print('event ${event.isLoaded}');
    emit(state.copyWith(isModelLoaded: event.isLoaded));
  }
  

}

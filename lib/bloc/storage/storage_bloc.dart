import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/models/storage_area_model.dart';

import '../../local_network_calls.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc() : super(StorageState.initial()) {
    on<AddStorageAreaData>(_onAddStorageAreaData);
  }

NetworkCalls _customApi = NetworkCalls(AppConstants.BASEURL, getIt<Dio>(), connectTimeout: 30, receiveTimeout: 30,username: "nalsoft_adm",password: "P@s\$w0rd2024");
  AppConstants appConstants = getIt<AppConstants>();

  void _onAddStorageAreaData(AddStorageAreaData event,Emitter<StorageState> emit)async{
    try{
      await _customApi.get(AppConstants.LOCATION,queryParameters: {"aisle":event.selectedRack}).then((value){
           print(value.response!.data["results"].runtimeType);
        StorageArea storageArea = StorageArea.fromJson(value.response!.data);
        print(" response ${storageArea.resultCount}");
        emit( state.copyWith(storageArea: storageArea,storageAreaStatus: StorageAreaStatus.success));
      });
    }
    catch(e){
      print("error $e");
    }
  }
}

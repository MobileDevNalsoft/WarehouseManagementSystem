import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/models/storage_aisle_model.dart';

import '../../local_network_calls.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc({required NetworkCalls customApi}) :  _customApi = customApi,super(StorageState.initial()) {
    on<AddStorageAreaData>(_onAddStorageAreaData);
  }
  final NetworkCalls _customApi;

  void _onAddStorageAreaData(AddStorageAreaData event,Emitter<StorageState> emit)async{
    try{
      await _customApi.get(AppConstants.STORAGE_AISLE, queryParameters: {"facility_id":"243", "aisle":event.selectedRack,"page_num":0}).then((value){
         emit( state.copyWith(storageArea: null,storageAreaStatus: StorageAreaStatus.initial));            
        StorageAisle storageArea = StorageAisle.fromJson(jsonDecode(value.response!.data));
        print(storageArea.data);
        emit( state.copyWith(storageArea: storageArea,storageAreaStatus: StorageAreaStatus.success));
      });
    }
    catch(e){
      print("error $e");
    }
  }
}

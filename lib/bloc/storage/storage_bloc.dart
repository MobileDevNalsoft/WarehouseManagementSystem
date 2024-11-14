import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/models/storage_aisle_model.dart';
import 'package:warehouse_3d/models/storage_bin.dart';

import '../../local_network_calls.dart';
import '../../models/area_response.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc({required NetworkCalls customApi}) :  _customApi = customApi,super(StorageState.initial()) {
    on<AddStorageAreaData>(_onAddStorageAreaData);
    on<GetBinData>(_onGetBinData);
  }
  final NetworkCalls _customApi;

  void _onAddStorageAreaData(AddStorageAreaData event,Emitter<StorageState> emit)async{
    emit( state.copyWith(storageArea: null,storageAreaStatus: StorageAreaStatus.initial)); 
    try{
       
      await _customApi.get(AppConstants.STORAGE_AISLE, queryParameters: {"facility_id":"243", "aisle":event.selectedRack,"page_num":0}).then((value){
        StorageAisle storageArea = StorageAisle.fromJson(jsonDecode(value.response!.data));
        print(storageArea.data);
        emit( state.copyWith(storageArea: storageArea,storageAreaStatus: StorageAreaStatus.success));
      });
    }
    catch(e){
      print("error $e");
    }
  }

  void _onGetBinData(GetBinData event,Emitter<StorageState> emit) async{
    emit( state.copyWith(storageBinStatus: StorageBinStatus.loading));   
    try{
        await _customApi.get(AppConstants.STORAGE_BIN, queryParameters: {"facility_id":"243", "barcode":event.selectedBin.toUpperCase(),"page_num":0}).then((apiResponse){      
            AreaResponse<StorageBinItem> storageBinResponse = AreaResponse.fromJson(jsonDecode(apiResponse.response!.data), (json) => StorageBinItem.fromJson(json));
            state.storageBinItems!.addAll(storageBinResponse.data!);
            emit( state.copyWith(storageBinItems: state.storageBinItems,storageBinStatus: StorageBinStatus.success));
      });
    }
    catch(e){
      print("error $e");
    }
  }
}


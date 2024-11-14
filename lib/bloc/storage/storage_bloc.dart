import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:warehouse_3d/constants/app_constants.dart';
import 'package:warehouse_3d/models/storage_aisle_list_model.dart';
import 'package:warehouse_3d/models/storage_aisle_model.dart';
import 'package:warehouse_3d/models/storage_bin.dart';

import '../../local_network_calls.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc({required NetworkCalls customApi}) :  _customApi = customApi,super(StorageState.initial()) {
    on<AddStorageAreaData>(_onAddStorageAreaData);
    on<GetBinData>(_onGetBinData);
    on<AddStorageAislesData>(_onAddStorageAislesData);
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
    emit( state.copyWith(storageBinStatus: StorageBinStatus.initial,storageBin: null));   
    try{
        await _customApi.get(event.searchText!=null?AppConstants.SEARCH : AppConstants.STORAGE_BIN, queryParameters:event.searchText!=null? {"search_text": event.searchText, "search_area": "STORAGE_BIN", "facility_id": '243', "page_num": 0} : {"facility_id":"243", "barcode":event.selectedBin!.toUpperCase(),"page_num":0}).then((value){      
            StorageBin storageBin = StorageBin.fromJson(jsonDecode(value.response!.data));
            print(storageBin.data);
            emit( state.copyWith(storageBin: storageBin,storageBinStatus: StorageBinStatus.success));
      });
    }
    catch(e){
      print("error $e");
    }
  }



  void _onAddStorageAislesData(AddStorageAislesData event,Emitter<StorageState> emit)async{
    emit( state.copyWith(storageArea: null,storageAreaStatus: StorageAreaStatus.initial)); 
    try{
      await _customApi.get(AppConstants.SEARCH, queryParameters: {"facility_id":"243","search_area":"STORAGE_AISLE", "search_text": event.searchText, "page_num":0}).then((value){
        ListOfStorageAisles storageAisles = ListOfStorageAisles.fromJson(jsonDecode(value.response!.data));
        print(storageAisles.data);
        emit( state.copyWith(storageAisles: storageAisles,storageAreaStatus: StorageAreaStatus.success));
      });
    }
    catch(e){
      print("error $e");
    }
  }
}


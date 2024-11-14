part of 'storage_bloc.dart';

enum  StorageAreaStatus {initial, loading, success, failure }
enum  StorageBinStatus {initial, loading, success, failure }

final class StorageState {
  
  StorageState({this.storageArea,this.storageAreaStatus,this.storageBin,this.storageBinStatus, this.storageAisles,this.pageNum});

  StorageAisle? storageArea;
  StorageAreaStatus? storageAreaStatus;
  StorageBin? storageBin;
  ListOfStorageAisles? storageAisles;
  int? pageNum;
  StorageBinStatus? storageBinStatus;

  factory StorageState.initial(){
  return StorageState(storageAreaStatus: StorageAreaStatus.initial, storageBinStatus: StorageBinStatus.initial);
}
  StorageState copyWith({StorageAisle? storageArea,StorageAreaStatus? storageAreaStatus,StorageBin? storageBin,StorageBinStatus? storageBinStatus,ListOfStorageAisles? storageAisles ,int? pageNum }){
    return StorageState(storageArea: storageArea??this.storageArea,storageAreaStatus:storageAreaStatus??this.storageAreaStatus,storageBin: storageBin??this.storageBin,storageBinStatus: storageBinStatus??this.storageBinStatus, pageNum: pageNum ?? this.pageNum,storageAisles:storageAisles??this.storageAisles);
  }


}


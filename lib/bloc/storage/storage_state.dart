part of 'storage_bloc.dart';

enum  StorageAreaStatus {initial, loading, success, failure }
enum  StorageBinStatus {initial, loading, success, failure }

final class StorageState extends Equatable {

  StorageAisle? storageArea;
  StorageAreaStatus? storageAreaStatus;
  StorageBin? storageBin; 
  StorageBinStatus? storageBinStatus;
  StorageState({this.storageArea,this.storageAreaStatus,this.storageBin,this.storageBinStatus});

  StorageState copyWith({StorageAisle? storageArea,StorageAreaStatus? storageAreaStatus,StorageBin? storageBin,StorageBinStatus? storageBinStatus }){
    return StorageState(storageArea: storageArea??this.storageArea,storageAreaStatus:storageAreaStatus??this.storageAreaStatus,storageBin: storageBin??this.storageBin,storageBinStatus: storageBinStatus??this.storageBinStatus);
  }


  factory StorageState.initial(){
  return StorageState();
}
  @override
  List<Object?> get props => [
    storageArea,
    storageAreaStatus,
    storageBin,
    storageBinStatus
  ];
}


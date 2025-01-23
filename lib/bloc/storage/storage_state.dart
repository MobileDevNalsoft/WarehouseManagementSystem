part of 'storage_bloc.dart';

enum StorageAreaStatus { initial, loading, success, failure }

enum StorageBinStatus { initial, loading, success, failure }

final class StorageState {
  StorageState({this.storageArea, this.storageAreaStatus, this.storageBinStatus, this.storageAisles, this.pageNum, this.storageBinItems,this.binsStatus});

  StorageAisle? storageArea;
  StorageAreaStatus? storageAreaStatus;

  List<StorageBinItem>? storageBinItems;
  ListOfStorageAisles? storageAisles;
  int? pageNum;
  StorageBinStatus? storageBinStatus;
  Map<String, dynamic>? binsStatus;

  factory StorageState.initial() {
    return StorageState(storageAreaStatus: StorageAreaStatus.initial, storageBinStatus: StorageBinStatus.initial, storageBinItems: [], pageNum: 0);
  }
  StorageState copyWith(
      {StorageAisle? storageArea,
      StorageAreaStatus? storageAreaStatus,
      List<StorageBinItem>? storageBinItems,
      StorageBinStatus? storageBinStatus,
      int? pageNum,
      ListOfStorageAisles? storageAisles,
      Map<String, dynamic>? binsStatus
      }) {
    return StorageState(
        storageArea: storageArea ?? this.storageArea,
        storageAreaStatus: storageAreaStatus ?? this.storageAreaStatus,
        storageBinItems: storageBinItems ?? this.storageBinItems,
        storageBinStatus: storageBinStatus ?? this.storageBinStatus,
        pageNum: pageNum ?? this.pageNum,
        storageAisles: storageAisles ?? this.storageAisles,
        binsStatus: binsStatus??this.binsStatus
        );
  }
}

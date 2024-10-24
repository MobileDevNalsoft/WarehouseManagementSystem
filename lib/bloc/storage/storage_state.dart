part of 'storage_bloc.dart';

enum  StorageAreaStatus {initial, loading, success, failure }

final class StorageState extends Equatable {

  StorageArea? storageArea;
  StorageAreaStatus? storageAreaStatus;
  StorageState({this.storageArea,this.storageAreaStatus});

  StorageState copyWith({StorageArea? storageArea,StorageAreaStatus? storageAreaStatus }){
    return StorageState(storageArea: storageArea??this.storageArea,storageAreaStatus:storageAreaStatus??this.storageAreaStatus );
  }


  factory StorageState.initial(){
  return StorageState();
}
  @override
  List<Object?> get props => [
    storageArea,
    storageAreaStatus
  ];
}


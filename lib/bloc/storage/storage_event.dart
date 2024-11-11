part of 'storage_bloc.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();


  @override
  List<Object> get props => [];
}
class AddStorageAreaData extends StorageEvent{
  String selectedRack;
 AddStorageAreaData({required this.selectedRack});
}

class GetBinData extends StorageEvent{
  String selectedBin;
 GetBinData({required this.selectedBin});
}
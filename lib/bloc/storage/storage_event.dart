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
  String? selectedBin;
  String? searchText;
 GetBinData({this.selectedBin,this.searchText});
}

class AddStorageAislesData extends StorageEvent{
  String searchText;
 AddStorageAislesData({required this.searchText});
}
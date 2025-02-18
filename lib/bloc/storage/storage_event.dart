part of 'storage_bloc.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object> get props => [];
}

//Gets the rack's data from the selected storage area rack.  
class AddStorageAreaData extends StorageEvent {
  String selectedRack;
  AddStorageAreaData({required this.selectedRack});
}

// To get the data of the selected bin.
// searchText to be when selectedBin is passed.
// SearchText is valid only when it is passed else whole data is fetched.
class GetBinData extends StorageEvent {
  String? selectedBin;
  String? searchText;
  GetBinData({this.selectedBin, this.searchText});
}

//Fetches  quanitity present in the storage area bins and providing the color based on the qauntity.  
class GetBinsStatus extends StorageEvent {
  GetBinsStatus();
}

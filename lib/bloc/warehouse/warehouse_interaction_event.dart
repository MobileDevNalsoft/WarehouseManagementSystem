part of 'warehouse_interaction_bloc.dart';


abstract class WarehouseInteractionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectedObject extends WarehouseInteractionEvent {
  final Map<String, dynamic> dataFromJS;
  bool? clearSearchText;
  SelectedObject({required this.dataFromJS,this.clearSearchText});

  @override
  List<Object> get props => [dataFromJS];
}



class GetCompanyData extends WarehouseInteractionEvent{

  GetCompanyData();
}

class GetFaclityData extends WarehouseInteractionEvent{
  final int company_id;

  GetFaclityData({required this.company_id});
    @override
  List<Object> get props => [company_id];
}
class SelectedCompanyValue extends WarehouseInteractionEvent {
  final String comVal;

   SelectedCompanyValue({required this.comVal});

  @override
  List<Object> get props => [comVal];
}
class SelectedFacilityValue extends WarehouseInteractionEvent {
  final String facilityVal;

   SelectedFacilityValue({required this.facilityVal});

  @override
  List<Object> get props => [facilityVal];
}
class ModelLoaded extends WarehouseInteractionEvent {
  final bool isLoaded;
  ModelLoaded({required this.isLoaded});

  @override
  List<Object> get props => [isLoaded];
}

class GetUsersData extends WarehouseInteractionEvent{}

class FilterUsers extends WarehouseInteractionEvent{
  final String searchText;
  FilterUsers({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

class UpdateUserAccess extends WarehouseInteractionEvent{
  final List<User> updatedUsers;
  UpdateUserAccess({required this.updatedUsers});

  @override
  List<Object> get props => [updatedUsers];
}

class GetAlerts extends WarehouseInteractionEvent{}

class GetAreasOverviewData extends WarehouseInteractionEvent{
  final int facilityID;
  GetAreasOverviewData({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}
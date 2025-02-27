part of 'warehouse_interaction_bloc.dart';

abstract class WarehouseInteractionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// this event is called when an object is selected in the warehouse
class SelectedObject extends WarehouseInteractionEvent {
  final Map<String, dynamic> dataFromJS;
  bool? clearSearchText;
  SelectedObject({required this.dataFromJS, this.clearSearchText});

  @override
  List<Object> get props => [dataFromJS];
}

class GetCompanyData extends WarehouseInteractionEvent {
  GetCompanyData();
}

class GetFaclityData extends WarehouseInteractionEvent {
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

// Emitted when the model is loaded 100%
class ModelLoaded extends WarehouseInteractionEvent {
  final bool isLoaded;
  ModelLoaded({required this.isLoaded});

  @override
  List<Object> get props => [isLoaded];
}

// Gets the users data
class GetUsersData extends WarehouseInteractionEvent {}

class FilterUsers extends WarehouseInteractionEvent {
  final String searchText;
  FilterUsers({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

class UpdateUserAccess extends WarehouseInteractionEvent {
  final List<User> updatedUsers;
  UpdateUserAccess({required this.updatedUsers});

  @override
  List<Object> get props => [updatedUsers];
}

class ResetAlertsCount extends WarehouseInteractionEvent {}

class GetAreasOverviewData extends WarehouseInteractionEvent {
  final int facilityID;
  GetAreasOverviewData({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}

class Rendering extends WarehouseInteractionEvent {
  bool isRendered;
  Rendering({required this.isRendered});

  @override
  List<Object> get props => [isRendered];
}

// To enable PointerInterceptor when the dropdowns are hovered
class Intercepting extends WarehouseInteractionEvent {
  final bool intercepting;
  Intercepting({required this.intercepting});

  @override
  List<Object> get props => [intercepting];
}

// To get LPN Lifecycle data based on the lpn number
class GetLPNLifeCycle extends WarehouseInteractionEvent {
  int facilityID;
  int companyID;
  String lpnNbr;
  GetLPNLifeCycle({required this.facilityID, required this.companyID, required this.lpnNbr});

  @override
  List<Object> get props => [facilityID, companyID, lpnNbr];
}

class GetLPNS extends WarehouseInteractionEvent {
  int facilityID;
  GetLPNS({required this.facilityID});

  @override
  List<Object> get props => [facilityID];
}

// To get the tasks along with the bins to calculate the shortest path.
class GetTasks extends WarehouseInteractionEvent {
  GetTasks();
}

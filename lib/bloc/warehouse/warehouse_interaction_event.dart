part of 'warehouse_interaction_bloc.dart';

abstract class WarehouseInteractionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectedObject extends WarehouseInteractionEvent {
  final Map<String, dynamic> dataFromJS;
  SelectedObject({required this.dataFromJS});

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



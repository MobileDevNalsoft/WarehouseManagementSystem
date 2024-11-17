part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }


enum GetStagingAreaDataState { initial, loading, success, failure }

enum GetActivityAreaDataState { initial, loading, success, failure }

enum GetReceivingAreaDataState { initial, loading, success, failure }

enum GetInspectionAreaDataState { initial, loading, success, failure }
enum  GetCompanyDataState {initial, loading, success, failure }
enum GetFacilityDataState{initial, loading, success, failure}
// ignore: must_be_immutable
final class WarehouseInteractionState{
  WarehouseInteractionState({required this.dataFromJS, this.inAppWebViewController, this.isModelLoaded = false, this.selectedSearchArea = "storagearea", this.searchText,this.getState = GetCompanyDataState.initial,this.companyModel,this.selectedCompanyVal,this.facilityModel,this.facilityDataState = GetFacilityDataState.initial,this.selectedFacilityVal});

  Map<String, dynamic> dataFromJS;
  InAppWebViewController? inAppWebViewController;
  bool isModelLoaded;
  String selectedSearchArea;
  String? searchText;
  CompanyModel? companyModel;
  FacilityModel? facilityModel;
  GetCompanyDataState? getState;
  GetFacilityDataState? facilityDataState;
  String? selectedCompanyVal;
  String? selectedFacilityVal;
  TextEditingController searchController = TextEditingController();
  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(dataFromJS: {"object": "null"}, isModelLoaded: false,getState: GetCompanyDataState.initial,facilityDataState: GetFacilityDataState.initial);
  }

  WarehouseInteractionState copyWith({Map<String, dynamic>? dataFromJS, bool? isModelLoaded, String? selectedSearchArea, String? searchText,GetCompanyDataState? getState,CompanyModel? companyModel,String? selectedCompanyVal,FacilityModel? facilityModel,GetFacilityDataState? facilityDataState,String? selectedFacilityVal}) {
    return WarehouseInteractionState(
        dataFromJS: dataFromJS ?? this.dataFromJS,
        isModelLoaded: isModelLoaded ?? this.isModelLoaded,
        inAppWebViewController: inAppWebViewController,
        selectedSearchArea: selectedSearchArea ?? this.selectedSearchArea,
        searchText: searchText ?? this.searchText,
        getState: getState?? this.getState,
        companyModel: companyModel??this.companyModel,
        selectedCompanyVal : selectedCompanyVal?? this.selectedCompanyVal,
        facilityModel: facilityModel?? this.facilityModel,
        facilityDataState: facilityDataState??this.facilityDataState,
        selectedFacilityVal :selectedFacilityVal?? this.selectedFacilityVal
        
        );
  }

  @override
  List<Object?> get props => [
        dataFromJS,
        inAppWebViewController,
        isModelLoaded,
        selectedSearchArea,
        searchText,
        getState,
        companyModel,
        selectedCompanyVal,
        facilityModel,
        facilityDataState,
        selectedFacilityVal
      ];
}

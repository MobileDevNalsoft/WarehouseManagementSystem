part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }


enum GetStagingAreaDataState { initial, loading, success, failure }

enum GetActivityAreaDataState { initial, loading, success, failure }

enum GetReceivingAreaDataState { initial, loading, success, failure }

enum GetInspectionAreaDataState { initial, loading, success, failure }
enum  GetCompanyDataState {initial, loading, success, failure }
enum GetFacilityDataState{initial, loading, success, failure}
enum GetUsers{initial, loading, success, failure}
enum GetUserInfo{initial, loading, success, failure}
enum AlertsStatus {initial, loading, success, failure}
// ignore: must_be_immutable
final class WarehouseInteractionState{
  WarehouseInteractionState({required this.dataFromJS, this.inAppWebViewController, this.isModelLoaded = false, this.selectedSearchArea = "Storagearea", this.searchText,this.getState = GetCompanyDataState.initial,
  this.companyModel,this.selectedCompanyVal,this.facilityModel,this.facilityDataState = GetFacilityDataState.initial,this.selectedFacilityVal, this.getUserInfoState, this.getUsersState, this.userInfo, this.users, this.filteredUsers,this.getAlertsStatus, this.alerts});

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
  GetUsers? getUsersState;
  GetUserInfo? getUserInfoState;
  User? userInfo;
  List<User>? users;
  List<User>? filteredUsers;
  AlertsStatus? getAlertsStatus;
  List<Alert>? alerts;
  // TextEditingController searchController;
  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(dataFromJS: {"object": "null"}, isModelLoaded: false,getState: GetCompanyDataState.initial,facilityDataState: GetFacilityDataState.initial,companyModel: CompanyModel(results: [CompanyResults(name: "M10 Company"),CompanyResults(name: "Demo"),CompanyResults(name: "Demo Customer1"),CompanyResults(name: "Demo Customer2"),CompanyResults(name: "SUM Compnay"),CompanyResults(name: "VIM Company")],),selectedCompanyVal: "M10 Company"
    ,facilityModel: FacilityModel(results: [FacilityResults(name: "Duty-Paid Warehouse"),FacilityResults(name: "Duty-Free Warehouse"),]),selectedFacilityVal: "Duty-Paid Warehouse", getUserInfoState: GetUserInfo.initial, getUsersState: GetUsers.initial, users : [], filteredUsers: [], getAlertsStatus: AlertsStatus.initial, alerts: []
    );
  }

  WarehouseInteractionState copyWith({Map<String, dynamic>? dataFromJS, bool? isModelLoaded, String? selectedSearchArea, String? searchText,GetCompanyDataState? getState,CompanyModel? companyModel,String? selectedCompanyVal,FacilityModel? facilityModel,GetFacilityDataState? facilityDataState,String? selectedFacilityVal, GetUserInfo? getUserInfoState, GetUsers? getUsersState, User? userInfo, List<User>? users, List<User>? filteredUsers,AlertsStatus? getAlertsStatus, List<Alert>? alerts}) {
    return WarehouseInteractionState(
        dataFromJS: dataFromJS ?? this.dataFromJS,
        isModelLoaded: isModelLoaded ?? this.isModelLoaded,
        inAppWebViewController: inAppWebViewController,
        selectedSearchArea: selectedSearchArea ?? this.selectedSearchArea,
        searchText: searchText ?? this.searchText,
        // searchController: searchController,
        getState: getState?? this.getState,
        companyModel: companyModel??this.companyModel,
        selectedCompanyVal : selectedCompanyVal?? this.selectedCompanyVal,
        facilityModel: facilityModel?? this.facilityModel,
        facilityDataState: facilityDataState??this.facilityDataState,
        selectedFacilityVal :selectedFacilityVal?? this.selectedFacilityVal,
        getUserInfoState: getUserInfoState ?? this.getUserInfoState,
        getUsersState: getUsersState ?? this.getUsersState,
        userInfo: userInfo ?? this.userInfo,
        users: users ?? this.users,
        filteredUsers: filteredUsers ?? this.filteredUsers,
        getAlertsStatus: getAlertsStatus ?? this.getAlertsStatus,
        alerts: alerts ?? this.alerts
        );
  }

}

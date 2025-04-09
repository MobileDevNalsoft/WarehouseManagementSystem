part of 'warehouse_interaction_bloc.dart';

enum GetRacksDataState { initial, loading, success, failure }

enum GetStagingAreaDataState { initial, loading, success, failure }

enum GetActivityAreaDataState { initial, loading, success, failure }

enum GetReceivingAreaDataState { initial, loading, success, failure }

enum AreasOverviewDataState { initial, loading, success, failure }

enum GetInspectionAreaDataState { initial, loading, success, failure }

enum GetCompanyDataState { initial, loading, success, failure }

enum GetFacilityDataState { initial, loading, success, failure }

enum GetUsers { initial, loading, success, failure }

enum GetUserInfo { initial, loading, success, failure }

enum LPNLifeCycleStatus { initial, loading, success, failure }

enum LPNSStatus { initial, loading, success, failure }

enum GetBinsForTaskStatus { initial, loading, success, failure }

// ignore: must_be_immutable
final class WarehouseInteractionState {
  WarehouseInteractionState({
    required this.dataFromJS,
    this.inAppWebViewController,
    this.isModelLoaded = false,
    this.intercepting = true,
    this.isRendered,
    this.selectedSearchArea = "Storagearea",
    this.searchText,
    this.getState = GetCompanyDataState.initial,
    this.companyModel,
    this.selectedCompanyVal,
    this.facilityModel,
    this.facilityDataState = GetFacilityDataState.initial,
    this.selectedFacilityVal,
    this.lpnLifeCycle,
    this.getUserInfoState,
    this.getUsersState,
    this.getLpnLifeCycleStatus,
    this.userInfo,
    this.users,
    this.filteredUsers,
    this.alerts,
    this.getAreasOveriviewDataState,
    this.selectedTaskId,
    this.taskIds,
    this.tasksForShoretestPath,
    this.getLPNSStatus,
    this.lpns,
    this.alertsCount = 0,
    this.binsForTask,
    this.getBinsForTaskStatus,
  });

  Map<String, dynamic> dataFromJS;
  InAppWebViewController? inAppWebViewController;
  bool isModelLoaded;
  bool? isRendered;
  String selectedSearchArea;
  LPNLifeCycleStatus? getLpnLifeCycleStatus;
  List<LPNStatus>? lpnLifeCycle;
  LPNSStatus? getLPNSStatus;
  List<String>? lpns;
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
  List<Alert>? alerts;
  AreasOverviewDataState? getAreasOveriviewDataState;
  String? selectedTaskId;
  List<String>? taskIds;
  bool? intercepting;
  int alertsCount;
  Map<String, dynamic>? tasksForShoretestPath;
  List<String>? binsForTask;
  GetBinsForTaskStatus? getBinsForTaskStatus;
  // TextEditingController searchController;
  factory WarehouseInteractionState.initial() {
    return WarehouseInteractionState(
      dataFromJS: {"object": "null"},
      isModelLoaded: false,
      intercepting: false,
      getState: GetCompanyDataState.initial,
      facilityDataState: GetFacilityDataState.initial,
      companyModel: CompanyModel(
        results: [
          CompanyResults(name: "M10 Company", id: 1),
          CompanyResults(name: "Demo", id: 2),
          CompanyResults(name: "Demo Customer1", id: 3),
          CompanyResults(name: "Demo Customer2"),
          CompanyResults(name: "SUM Compnay", id: 4),
          CompanyResults(name: "VIM Company", id: 5)
        ],
      ),
      selectedCompanyVal: "M10 Company",
      facilityModel: FacilityModel(results: [
        FacilityResults(name: "Duty-Paid Warehouse", id: 1),
        FacilityResults(name: "Duty-Free Warehouse", id: 2),
      ]),
      selectedFacilityVal: "Duty-Paid Warehouse",
      getUserInfoState: GetUserInfo.initial,
      getUsersState: GetUsers.initial,
      getLPNSStatus: LPNSStatus.initial,
      users: [],
      filteredUsers: [],
      lpns: [],
      alerts: [],
      getAreasOveriviewDataState: AreasOverviewDataState.initial,
      alertsCount: 0,
      taskIds: ["task1", "task2", "task3", "task4"],
      getLpnLifeCycleStatus: LPNLifeCycleStatus.initial,
   lpnLifeCycle: [
        LPNStatus(status: 'Received', user: 'Rohith', date: '2025-03-10 06:28:01 AM', area: 'RECEIVING'),
        LPNStatus(status: 'Quality Check', user: 'Sravan', date: '2025-03-10 11:26:01 AM', area: 'INSPECTION'),
        LPNStatus(status: 'Located', user: 'Madhan', date: '2025-03-10 01:00:01 PM', area: 'STORAGE'),
        LPNStatus(status: 'Allocated', user: 'Sanjit', date: '2025-03-14 09:28:01 AM', area: 'ACTIVITY'),
        LPNStatus(status: 'Picked', user: 'Mani', date: '2025-03-14 10:40:21 AM', area: 'ACTIVITY'),
        LPNStatus(status: 'Packed', user: 'Sravan', date: '2025-03-14 11:40:01 AM', area: 'STAGING'),
        LPNStatus(status: 'Loaded', user: 'Sanjit', date: '2025-03-14 03:20:01 PM', area: 'STAGING'),
        LPNStatus(status: 'Shipped', user: 'Arvind', date: '2025-03-14 05:28:01 PM', area: 'STAGING')
      ],
      tasksForShoretestPath: {},
      binsForTask: [],
      getBinsForTaskStatus: GetBinsForTaskStatus.initial,

    );
  }

  WarehouseInteractionState copyWith(
      {Map<String, dynamic>? dataFromJS,
      bool? isModelLoaded,
      bool? isRendered,
      bool? intercepting,
      String? selectedSearchArea,
      String? searchText,
      GetCompanyDataState? getState,
      List<LPNStatus>? lpnLifeCycle,
      CompanyModel? companyModel,
      String? selectedCompanyVal,
      FacilityModel? facilityModel,
      GetFacilityDataState? facilityDataState,
      LPNSStatus? getLPNSStatus,
      String? selectedFacilityVal,
      GetUserInfo? getUserInfoState,
      GetUsers? getUsersState,
      User? userInfo,
      List<User>? users,
      List<User>? filteredUsers,
      List<String>? lpns,
      List<Alert>? alerts,
      AreasOverviewDataState? getAreasOveriviewDataState,
      String? selectedTaskId,
      LPNLifeCycleStatus? getLpnLifeCycleStatus,
      Map<String, dynamic>? tasksForShoretestPath,
      int? alertsCount,
      List<String>? binsForTask,
      GetBinsForTaskStatus? getBinsForTaskStatus}) {
    return WarehouseInteractionState(
      dataFromJS: dataFromJS ?? this.dataFromJS,
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      intercepting: intercepting ?? this.intercepting,
      inAppWebViewController: inAppWebViewController,
      selectedSearchArea: selectedSearchArea ?? this.selectedSearchArea,
      searchText: searchText ?? this.searchText,
      // searchController: searchController,
      getLPNSStatus: getLPNSStatus ?? this.getLPNSStatus,
      lpns: lpns ?? this.lpns,
      getState: getState ?? this.getState,
      companyModel: companyModel ?? this.companyModel,
      selectedCompanyVal: selectedCompanyVal ?? this.selectedCompanyVal,
      facilityModel: facilityModel ?? this.facilityModel,
      facilityDataState: facilityDataState ?? this.facilityDataState,
      selectedFacilityVal: selectedFacilityVal ?? this.selectedFacilityVal,
      getUserInfoState: getUserInfoState ?? this.getUserInfoState,
      getUsersState: getUsersState ?? this.getUsersState,
      getLpnLifeCycleStatus: getLpnLifeCycleStatus ?? this.getLpnLifeCycleStatus,
      // lpnLifeCycle: lpnLifeCycle ?? this.lpnLifeCycle,
      lpnLifeCycle: this.lpnLifeCycle,
      userInfo: userInfo ?? this.userInfo,
      users: users ?? this.users,
      isRendered: isRendered ?? this.isRendered,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      alerts: alerts ?? this.alerts,
      getAreasOveriviewDataState: getAreasOveriviewDataState ?? this.getAreasOveriviewDataState,
      selectedTaskId: selectedTaskId ?? this.selectedTaskId,
      alertsCount: alertsCount ?? this.alertsCount,
      tasksForShoretestPath: tasksForShoretestPath ?? this.tasksForShoretestPath,
      binsForTask: binsForTask ?? this.binsForTask,
      getBinsForTaskStatus: getBinsForTaskStatus ?? this.getBinsForTaskStatus,
    );
  }
}

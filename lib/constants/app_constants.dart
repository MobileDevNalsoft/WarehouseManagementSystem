import 'dart:convert';

class AppConstants {
  // authentication constants
  static const IDCS_URL = "https://idcs-ceca8ff48a7341bebbe31aba04db25b2.identity.oraclecloud.com/";

  static const WMS_URL = "https://tg1.wms.ocs.oraclecloud.com:443/emg_test/wms/lgfapi/v10/entity/";

  static const String GET_OCI_TOKEN = "oauth2/v1/token";
  static const String AUTHENCTICATE_USER_NAME = "sso/v1/sdk/authenticate";

  // idcs credentials
  static const String AUTHENTICATION_USERNAME = 'a07dc2a022db4c458397118abb543e57';
  static const String AUTHENTICATION_PASSWORD = 'bf06245f-33ae-4b6c-9d0e-27fc0d89f514';

  static const Map<String, String> TOKEN_DATA = {
    'grant_type': 'client_credentials',
    'scope': 'urn:opc:idm:__myscopes__',
  };

  static Map<String, String> TOKEN_METHODHEADERS = {
    'Authorization': 'Basic ${base64.encode(utf8.encode('$AUTHENTICATION_USERNAME:$AUTHENTICATION_PASSWORD'))}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static const GOOGLE_MAPS_API_KEY = "AIzaSyAVj-M7IeRW2u9xndAMvqxg94Luwalip38";
  static const GOOGLE_MAP_API = "https://maps.googleapis.com/maps/api/directions/json";
  static const FIREBASE_FUNCTION_DURECTIONS = "https://app-zcx33l2yiq-uc.a.run.app/directions";

  // api credentials
  static const String APIUSERNAME = "NALSOFT";
  static const String APIPASSWORD = "Nalsoft@123";

  // api credentials
  static const String WMSUSERNAME = "nalsoft_adm";
  static const String WMSPASSWORD = 'P@s\$w0rd2024';
  // urls
  static const APEX_URL = 'https://paas.nalsoft.net:4443/ords/xxwms/wms/';

  static const INVENTORY_HISTORY = 'inventory_history/';
  static const LOCATION = 'location/';
  static const COMPANY = 'company/';
  static const FACILITY = 'facility/';
  static const USERS = 'users';
  static const USERINFO = 'user_info';
  static const ALERTS = 'get_alerts';
  static const ARES_OVERVIEW_DATA = 'areas_overview_data';

  // methods
  static const ACTIVITY_AREA = 'activity_area';
  static const ACTIVITY_AREA_TASKS = 'activity_area_tasks';
  static const INSPECTION_AREA = 'inspection_area';
  static const DOCK_AREA = 'dock_area';
  static const DOCK_AREA_OUT = 'dock_out';

  static const YARD_AREA = 'yard_area';
  static const RECEIVING_AREA = 'receiving_area';
  static const STAGING_AREA = 'staging_area';
  static const STORAGE_AISLE = 'storage_aisle';
  static const STORAGE_BIN = 'storage_bin';
  static const SEARCH = 'search';
  static const DOCK_DASHBOARD = 'dock_dashboard';
  static const DOCK_APPOINTMENTS = 'dock_appointments';
  static const YARD_DASHBOARD = 'yard_dashboard';
  static const RECEIVING_DASHBOARD = 'receiving_dashboard';
  static const INSPECTION_DASHBOARD = 'inspection_dashboard';
  static const ACTIVITY_DASHBOARD = 'activity_dashboard';
  static const STAGING_DASHBOARD = 'staging_dashboard';
  static const STORAGE_DASHBOARD = 'storage_dashboard';
  static const STORAGE_DRILLDOWN = 'storage_drilldown';
  static const STAGING_DRILLDOWN = 'staging_drilldown';
  static const BINS_STATUS = 'bins_status';
  static const QUALITYCHECK_TASKS = 'get_lpns_for_quality_check';

  static const QUALITYCHECK_COMPLETED_TASKS = 'get_completed_quality_check_lpns';
  static const CYCLECOUNT_TASKS = 'cyclecount_tasks';
  static const CONTAINERS = 'get_containers';
  static const QUALITYCHECK_BULK_APPROVE = 'iblpn/bulk_qc_approve';
  static const QUALITYCHECK_BULK_REJECT = 'iblpn/bulk_qc_reject';
  static const SHORTESTPATH_TASKS = 'get_tasks_with_bins';

  static const BINS_FOR_TASK = 'get_bins_for_task';
  static const WORK_QUEUE = 'get_work_queue';
  static const LPN_LIFECYCLE = 'lpn_lifecycle';
  static const GET_LPNS = 'get_lpns';
}

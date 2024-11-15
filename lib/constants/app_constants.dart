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
      'Authorization':
          'Basic ${base64.encode(utf8.encode('$AUTHENTICATION_USERNAME:$AUTHENTICATION_PASSWORD'))}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

  // api credentials
  static const String APIUSERNAME = "NALSOFT";
  static const String APIPASSWORD = "Nalsoft@123";

  // urls
  static const APEX_URL = 'https://paas.nalsoft.net:4443/ords/xxwms/wms/';
  static const BASEURL = 'https://paas.nalsoft.net:4443/ords/xxwms/wms/';

  static const INVENTORY_HISTORY = 'inventory_history/';
  static const LOCATION = 'location/';
  static const COMPANY = 'company/';
  static const FACILITY = 'facility/';
   
  // methods
  static const ACTIVITY_AREA = 'activity_area';
  static const INSPECTION_AREA = 'inspection_area';
  static const DOCK_AREA = 'dock_area';
  static const YARD_AREA = 'yard_area';
  static const RECEIVING_AREA = 'receiving_area';
  static const STAGING_AREA = 'staging_area';
  static const STORAGE_AISLE = 'storage_aisle';
  static const STORAGE_BIN = 'storage_bin';
  static const SEARCH = 'search';
}

 

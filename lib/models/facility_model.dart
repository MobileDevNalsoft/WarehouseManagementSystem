class FacilityModel {
  int? resultCount;
  int? pageCount;
  int? pageNbr;
  int? nextPage;
  int? previousPage;
  List<Results>? results;

  FacilityModel(
      {this.resultCount,
      this.pageCount,
      this.pageNbr,
      this.nextPage,
      this.previousPage,
      this.results});

  FacilityModel.fromJson(Map<String, dynamic> json) {
    resultCount = json['result_count'];
    pageCount = json['page_count'];
    pageNbr = json['page_nbr'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result_count'] = this.resultCount;
    data['page_count'] = this.pageCount;
    data['page_nbr'] = this.pageNbr;
    data['next_page'] = this.nextPage;
    data['previous_page'] = this.previousPage;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? url;
  String? createUser;
  String? createTs;
  String? modUser;
  String? modTs;
  String? code;
  FacilityTypeId? facilityTypeId;
  FacilityTypeId? parentCompanyId;
  String? name;
  String? address1;
  String? address2;
  String? address3;
  String? locality;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? phoneNbr;
  String? email;
  String? contact;
  String? lang;
  String? defaultShipViaCode;
  FacilityTypeId? timeZoneId;
  String? bonusAmtPerUser;
  int? priority;
  bool? acceptTransferShipmentFlg;
  bool? wmsManagedFlg;
  String? custField1;
  String? custField2;
  String? custField3;
  String? custField4;
  String? custField5;
  String? latitude;
  String? longitude;

  Results(
      {this.id,
      this.url,
      this.createUser,
      this.createTs,
      this.modUser,
      this.modTs,
      this.code,
      this.facilityTypeId,
      this.parentCompanyId,
      this.name,
      this.address1,
      this.address2,
      this.address3,
      this.locality,
      this.city,
      this.state,
      this.zip,
      this.country,
      this.phoneNbr,
      this.email,
      this.contact,
      this.lang,
      this.defaultShipViaCode,
      this.timeZoneId,
      this.bonusAmtPerUser,
      this.priority,
      this.acceptTransferShipmentFlg,
      this.wmsManagedFlg,
      this.custField1,
      this.custField2,
      this.custField3,
      this.custField4,
      this.custField5,
      this.latitude,
      this.longitude});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    createUser = json['create_user'];
    createTs = json['create_ts'];
    modUser = json['mod_user'];
    modTs = json['mod_ts'];
    code = json['code'];
    facilityTypeId = json['facility_type_id'] != null
        ? new FacilityTypeId.fromJson(json['facility_type_id'])
        : null;
    parentCompanyId = json['parent_company_id'] != null
        ? new FacilityTypeId.fromJson(json['parent_company_id'])
        : null;
    name = json['name'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    address3 = json['address_3'];
    locality = json['locality'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    phoneNbr = json['phone_nbr'];
    email = json['email'];
    contact = json['contact'];
    lang = json['lang'];
    defaultShipViaCode = json['default_ship_via_code'];
    timeZoneId = json['time_zone_id'] != null
        ? new FacilityTypeId.fromJson(json['time_zone_id'])
        : null;
    bonusAmtPerUser = json['bonus_amt_per_user'];
    priority = json['priority'];
    acceptTransferShipmentFlg = json['accept_transfer_shipment_flg'];
    wmsManagedFlg = json['wms_managed_flg'];
    custField1 = json['cust_field_1'];
    custField2 = json['cust_field_2'];
    custField3 = json['cust_field_3'];
    custField4 = json['cust_field_4'];
    custField5 = json['cust_field_5'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['create_user'] = this.createUser;
    data['create_ts'] = this.createTs;
    data['mod_user'] = this.modUser;
    data['mod_ts'] = this.modTs;
    data['code'] = this.code;
    if (this.facilityTypeId != null) {
      data['facility_type_id'] = this.facilityTypeId!.toJson();
    }
    if (this.parentCompanyId != null) {
      data['parent_company_id'] = this.parentCompanyId!.toJson();
    }
    data['name'] = this.name;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['address_3'] = this.address3;
    data['locality'] = this.locality;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['phone_nbr'] = this.phoneNbr;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['lang'] = this.lang;
    data['default_ship_via_code'] = this.defaultShipViaCode;
    if (this.timeZoneId != null) {
      data['time_zone_id'] = this.timeZoneId!.toJson();
    }
    data['bonus_amt_per_user'] = this.bonusAmtPerUser;
    data['priority'] = this.priority;
    data['accept_transfer_shipment_flg'] = this.acceptTransferShipmentFlg;
    data['wms_managed_flg'] = this.wmsManagedFlg;
    data['cust_field_1'] = this.custField1;
    data['cust_field_2'] = this.custField2;
    data['cust_field_3'] = this.custField3;
    data['cust_field_4'] = this.custField4;
    data['cust_field_5'] = this.custField5;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class FacilityTypeId {
  int? id;
  String? key;
  String? url;

  FacilityTypeId({this.id, this.key, this.url});

  FacilityTypeId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['url'] = this.url;
    return data;
  }
}
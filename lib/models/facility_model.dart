class FacilityModel {
  int? resultCount;
  int? pageCount;
  int? pageNbr;
  int? nextPage;
  int? previousPage;
  List<FacilityResults>? results;

  FacilityModel({this.resultCount, this.pageCount, this.pageNbr, this.nextPage, this.previousPage, this.results});

  FacilityModel.fromJson(Map<String, dynamic> json) {
    resultCount = json['result_count'];
    pageCount = json['page_count'];
    pageNbr = json['page_nbr'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
    if (json['results'] != null) {
      results = <FacilityResults>[];
      json['results'].forEach((v) {
        results!.add(FacilityResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result_count'] = resultCount;
    data['page_count'] = pageCount;
    data['page_nbr'] = pageNbr;
    data['next_page'] = nextPage;
    data['previous_page'] = previousPage;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FacilityResults {
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

  FacilityResults(
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

  FacilityResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    createUser = json['create_user'];
    createTs = json['create_ts'];
    modUser = json['mod_user'];
    modTs = json['mod_ts'];
    code = json['code'];
    facilityTypeId = json['facility_type_id'] != null ? FacilityTypeId.fromJson(json['facility_type_id']) : null;
    parentCompanyId = json['parent_company_id'] != null ? FacilityTypeId.fromJson(json['parent_company_id']) : null;
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
    timeZoneId = json['time_zone_id'] != null ? FacilityTypeId.fromJson(json['time_zone_id']) : null;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['create_user'] = createUser;
    data['create_ts'] = createTs;
    data['mod_user'] = modUser;
    data['mod_ts'] = modTs;
    data['code'] = code;
    if (facilityTypeId != null) {
      data['facility_type_id'] = facilityTypeId!.toJson();
    }
    if (parentCompanyId != null) {
      data['parent_company_id'] = parentCompanyId!.toJson();
    }
    data['name'] = name;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['address_3'] = address3;
    data['locality'] = locality;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    data['country'] = country;
    data['phone_nbr'] = phoneNbr;
    data['email'] = email;
    data['contact'] = contact;
    data['lang'] = lang;
    data['default_ship_via_code'] = defaultShipViaCode;
    if (timeZoneId != null) {
      data['time_zone_id'] = timeZoneId!.toJson();
    }
    data['bonus_amt_per_user'] = bonusAmtPerUser;
    data['priority'] = priority;
    data['accept_transfer_shipment_flg'] = acceptTransferShipmentFlg;
    data['wms_managed_flg'] = wmsManagedFlg;
    data['cust_field_1'] = custField1;
    data['cust_field_2'] = custField2;
    data['cust_field_3'] = custField3;
    data['cust_field_4'] = custField4;
    data['cust_field_5'] = custField5;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['url'] = url;
    return data;
  }
}

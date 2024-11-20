class CompanyModel {
  int? resultCount;
  int? pageCount;
  int? pageNbr;
  int? nextPage;
  int? previousPage;
  List<CompanyResults>? results;

  CompanyModel(
      {this.resultCount,
      this.pageCount,
      this.pageNbr,
      this.nextPage,
      this.previousPage,  
      this.results});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    resultCount = json['result_count'];
    pageCount = json['page_count'];
    pageNbr = json['page_nbr'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
    if (json['results'] != null) {
      results = <CompanyResults>[];
      json['results'].forEach((v) {
        results!.add(new CompanyResults.fromJson(v));
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

class CompanyResults {
  int? id;
  String? url;
  String? createUser;
  String? createTs;
  String? modUser;
  String? modTs;
  String? code;
  CompanyTypeId? companyTypeId;
  bool? activeFlg;
  CompanyTypeId? parentCompanyId;
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
  String? univId1;
  String? ediPartnerNbr;
  String? employerNbr;
  int? maxAllowedQtyDecimalScale;
  int? maxAllowedWtVolDimDecimalScale;
  String? custField1;
  String? custField2;
  String? custField3;
  String? custField4;
  String? custField5;

  CompanyResults(
      {this.id,
      this.url,
      this.createUser,
      this.createTs,
      this.modUser,
      this.modTs,
      this.code,
      this.companyTypeId,
      this.activeFlg,
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
      this.univId1,
      this.ediPartnerNbr,
      this.employerNbr,
      this.maxAllowedQtyDecimalScale,
      this.maxAllowedWtVolDimDecimalScale,
      this.custField1,
      this.custField2,
      this.custField3,
      this.custField4,
      this.custField5});

  CompanyResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    createUser = json['create_user'];
    createTs = json['create_ts'];
    modUser = json['mod_user'];
    modTs = json['mod_ts'];
    code = json['code'];
    companyTypeId = json['company_type_id'] != null
        ? new CompanyTypeId.fromJson(json['company_type_id'])
        : null;
    activeFlg = json['active_flg'];
    parentCompanyId = json['parent_company_id'] != null
        ? new CompanyTypeId.fromJson(json['parent_company_id'])
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
    univId1 = json['univ_id_1'];
    ediPartnerNbr = json['edi_partner_nbr'];
    employerNbr = json['employer_nbr'];
    maxAllowedQtyDecimalScale = json['max_allowed_qty_decimal_scale'];
    maxAllowedWtVolDimDecimalScale =
        json['max_allowed_wt_vol_dim_decimal_scale'];
    custField1 = json['cust_field_1'];
    custField2 = json['cust_field_2'];
    custField3 = json['cust_field_3'];
    custField4 = json['cust_field_4'];
    custField5 = json['cust_field_5'];
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
    if (this.companyTypeId != null) {
      data['company_type_id'] = this.companyTypeId!.toJson();
    }
    data['active_flg'] = this.activeFlg;
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
    data['univ_id_1'] = this.univId1;
    data['edi_partner_nbr'] = this.ediPartnerNbr;
    data['employer_nbr'] = this.employerNbr;
    data['max_allowed_qty_decimal_scale'] = this.maxAllowedQtyDecimalScale;
    data['max_allowed_wt_vol_dim_decimal_scale'] =
        this.maxAllowedWtVolDimDecimalScale;
    data['cust_field_1'] = this.custField1;
    data['cust_field_2'] = this.custField2;
    data['cust_field_3'] = this.custField3;
    data['cust_field_4'] = this.custField4;
    data['cust_field_5'] = this.custField5;
    return data;
  }
}

class CompanyTypeId {
  int? id;
  String? key;
  String? url;

  CompanyTypeId({this.id, this.key, this.url});

  CompanyTypeId.fromJson(Map<String, dynamic> json) {
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
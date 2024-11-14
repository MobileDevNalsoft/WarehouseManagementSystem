class ListOfStorageAisles {
  int? responseCode;
  String? responseMessage;
  List<Data>? data;

  ListOfStorageAisles({this.responseCode, this.responseMessage, this.data});

  ListOfStorageAisles.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_message'] = this.responseMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? area;
  String? aisle;
  String? locationCategory;
  String? barcode;

  Data({this.area, this.aisle, this.locationCategory, this.barcode});

  Data.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    aisle = json['aisle'];
    locationCategory = json['location_category'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['aisle'] = this.aisle;
    data['location_category'] = this.locationCategory;
    data['barcode'] = this.barcode;
    return data;
  }
}

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['response_message'] = responseMessage;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['area'] = area;
    data['aisle'] = aisle;
    data['location_category'] = locationCategory;
    data['barcode'] = barcode;
    return data;
  }
}

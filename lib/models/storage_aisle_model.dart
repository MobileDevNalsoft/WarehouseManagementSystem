class StorageAisle {
  int? responseCode;
  String? responseMessage;
  List<Data>? data;

  StorageAisle({this.responseCode, this.responseMessage, this.data});

  StorageAisle.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? area;
  String? aisle;
  String? bay;
  String? level;
  String? position;
  String? barcode;
  String? locationCategory;

  Data(
      {this.id,
      this.area,
      this.aisle,
      this.bay,
      this.level,
      this.position,
      this.barcode,
      this.locationCategory});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    area = json['area'];
    aisle = json['aisle'];
    bay = json['bay'];
    level = json['level'];
    position = json['position'];
    barcode = json['barcode'];
    locationCategory = json['location_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area'] = this.area;
    data['aisle'] = this.aisle;
    data['bay'] = this.bay;
    data['level'] = this.level;
    data['position'] = this.position;
    data['barcode'] = this.barcode;
    data['location_category'] = this.locationCategory;
    return data;
  }
}

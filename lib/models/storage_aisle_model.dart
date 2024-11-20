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
        data!.add(Data.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['area'] = area;
    data['aisle'] = aisle;
    data['bay'] = bay;
    data['level'] = level;
    data['position'] = position;
    data['barcode'] = barcode;
    data['location_category'] = locationCategory;
    return data;
  }
}


class StorageDashboard{
  StorageDashboard.fromJson(Map<String, dynamic> json){
    
  }
}
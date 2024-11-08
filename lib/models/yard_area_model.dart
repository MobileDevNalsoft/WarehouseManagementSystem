class YardArea {
  int? responseCode;
  String? responseMessage;
  List<Data>? data;

  YardArea({this.responseCode, this.responseMessage, this.data});

  YardArea.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? vehicleLocation;
  String? truckNbr;
  String? vehicleEntryTime;
  String? seqNbr;
  String? shipmentNbr;
  String? poNbr;
  String? vendorCode;

  Data(
      {this.id,
      this.vehicleLocation,
      this.truckNbr,
      this.vehicleEntryTime,
      this.seqNbr,
      this.shipmentNbr,
      this.poNbr,
      this.vendorCode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleLocation = json['vehicle_location'];
    truckNbr = json['truck_nbr'];
    vehicleEntryTime = json['vehicle_entry_time'];
    seqNbr = json['seq_nbr'];
    shipmentNbr = json['shipment_nbr'];
    poNbr = json['po_nbr'];
    vendorCode = json['vendor_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_location'] = this.vehicleLocation;
    data['truck_nbr'] = this.truckNbr;
    data['vehicle_entry_time'] = this.vehicleEntryTime;
    data['seq_nbr'] = this.seqNbr;
    data['shipment_nbr'] = this.shipmentNbr;
    data['po_nbr'] = this.poNbr;
    data['vendor_code'] = this.vendorCode;
    return data;
  }
}

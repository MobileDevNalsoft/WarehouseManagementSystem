class StorageBin {
  int? responseCode;
  String? responseMessage;
  List<Data>? data;

  StorageBin({this.responseCode, this.responseMessage, this.data});

  StorageBin.fromJson(Map<String, dynamic> json) {
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
  String? containerNbr;
  String? locationKey;
  String? serialNbrKey;
  String? batchNbrKey;
  String? rcvdShipmentKey;
  String? refPoNbr;
  String? vendor;
  String? putawaytypeKey;
  String? itemKey;
  String? currQty;
  String? currLocationId;
  String? manufactureDate;
  String? expiryDate;

  Data(
      {this.containerNbr,
      this.locationKey,
      this.serialNbrKey,
      this.batchNbrKey,
      this.rcvdShipmentKey,
      this.refPoNbr,
      this.vendor,
      this.putawaytypeKey,
      this.itemKey,
      this.currQty,
      this.currLocationId,
      this.manufactureDate,
      this.expiryDate});

  Data.fromJson(Map<String, dynamic> json) {
    containerNbr = json['container_nbr'];
    locationKey = json['location_key'];
    serialNbrKey = json['serial_nbr_key'];
    batchNbrKey = json['batch_nbr_id'];
    rcvdShipmentKey = json['rcvd_shipment_key'];
    refPoNbr = json['ref_po_nbr'];
    vendor = json['vendor'];
    putawaytypeKey = json['putawaytype_key'];
    itemKey = json['item_key'];
    currQty = json['curr_qty'];
    currLocationId = json['curr_location_id'];
    manufactureDate = json['manufacture_date'];
    expiryDate = json['expiry_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['container_nbr'] = this.containerNbr;
    data['location_key'] = this.locationKey;
    data['serial_nbr_key'] = this.serialNbrKey;
    data['batch_nbr_id'] = this.batchNbrKey;
    data['rcvd_shipment_key'] = this.rcvdShipmentKey;
    data['ref_po_nbr'] = this.refPoNbr;
    data['vendor'] = this.vendor;
    data['putawaytype_key'] = this.putawaytypeKey;
    data['item_key'] = this.itemKey;
    data['curr_qty'] = this.currQty;
    data['curr_location_id'] = this.currLocationId;
    data['manufacture_date'] = this.manufactureDate;
    data['expiry_date'] = this.expiryDate;
    return data;
  }
}

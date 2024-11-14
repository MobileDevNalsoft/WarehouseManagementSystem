class YardAreaItem {
  int? id;
  String? vehicleLocation;
  String? truckNbr;
  String? vehicleEntryTime;
  String? seqNbr;
  String? shipmentNbr;
  String? poNbr;
  String? vendorCode;

  YardAreaItem(
      {this.id,
      this.vehicleLocation,
      this.truckNbr,
      this.vehicleEntryTime,
      this.seqNbr,
      this.shipmentNbr,
      this.poNbr,
      this.vendorCode});

  YardAreaItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleLocation = json['vehicle_location'];
    truckNbr = json['truck_nbr'];
    vehicleEntryTime = json['vehicle_entry_time'];
    seqNbr = json['seq_nbr'];
    shipmentNbr = json['shipment_nbr'];
    poNbr = json['po_nbr'];
    vendorCode = json['vendor_code'];
  }
}

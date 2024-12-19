class StorageBinItem {
  String? containerNbr;
  String? locationKey;
  String? serialNbrKey;
  String? batchNbrID;
  String? rcvdShipmentKey;
  String? refPoNbr;
  String? vendor;
  String? putawaytypeKey;
  String? itemKey;
  String? currQty;
  String? currLocationId;
  String? manufactureDate;
  String? expiryDate;

  StorageBinItem(
      {this.containerNbr,
      this.locationKey,
      this.serialNbrKey,
      this.batchNbrID,
      this.rcvdShipmentKey,
      this.refPoNbr,
      this.vendor,
      this.putawaytypeKey,
      this.itemKey,
      this.currQty,
      this.currLocationId,
      this.manufactureDate,
      this.expiryDate});

  StorageBinItem.fromJson(Map<String, dynamic> json) {
    containerNbr = json['container_nbr'] ?? '';
    locationKey = json['location_key'] ?? '';
    serialNbrKey = json['serial_nbr_key'] ?? '';
    batchNbrID = json['batch_nbr_id'] ?? '';
    rcvdShipmentKey = json['rcvd_shipment_key'] ?? '';
    refPoNbr = json['ref_po_nbr'] ?? '';
    vendor = json['vendor'] ?? '';
    putawaytypeKey = json['putawaytype_key'] ?? '';
    itemKey = json['item_key'] ?? '';
    currQty = json['curr_qty'] ?? '';
    currLocationId = json['curr_location_id'] ?? '';
    manufactureDate = json['manufacture_date'] ?? '';
    expiryDate = json['expiry_date'] ?? '';
  }
}

class WarehouseUtilization {
  List<String>? available;
  List<String>? occupied;
  WarehouseUtilization({this.available, this.occupied});

  WarehouseUtilization.fromJson(Map<String, dynamic> json){
    available = (json['available_bins'] as List).map((e) => (e as Map).values.first as String).toList();
    occupied = (json['occupied_bins'] as List).map((e) => (e as Map).values.first as String).toList();
  }
}

class InventorySummary {
  List<String>? inStock;
  List<String>? runningOutOfStock;
  List<String>? outOfStock;
  InventorySummary({this.inStock, this.runningOutOfStock, this.outOfStock});

  InventorySummary.fromJson(Map<String, dynamic> json){
    inStock = (json['in_stock'] as List).map((e) => (e as Map).values.first as String).toList();
    runningOutOfStock = (json['running_out_of_stock'] as List).map((e) => (e as Map).values.first as String).toList();
    outOfStock = (json['out_of_stock'] as List).map((e) => (e as Map).values.first as String).toList();
  }
}
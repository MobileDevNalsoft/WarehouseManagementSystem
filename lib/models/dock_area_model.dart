class DockAreaItem {
  String? dockType;
  String? truckNum;
  String? asn;
  String? poNum;
  String? vendor;
  String? checkInTS;
  int? qty;
  DockAreaItem({this.dockType, this.truckNum, this.asn, this.poNum, this.vendor, this.checkInTS, this.qty});

  DockAreaItem.fromJson(Map<String, dynamic> json) {
    dockType = json['dock_type'];
    truckNum = json['truck_number'];
    asn = json['asn'];
    poNum = json['po_nbr'];
    vendor = json['vendor'];
    checkInTS = json['checkin_ts'];
    qty = int.parse(json['qty']);
  }
}
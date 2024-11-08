class InspectionAreaItem {
  String? asn;
  String? poNum;
  String? vendor;
  String? lpnNum;
  String? item;
  int? qty;
  InspectionAreaItem({this.asn, this.poNum, this.vendor, this.lpnNum, this.item, this.qty});

  InspectionAreaItem.fromJson(Map<String, dynamic> json) {
    asn = json['asn'];
    poNum = json['po_num'];
    vendor = json['vendor'];
    lpnNum = json['lpn_num'];
    item = json['item'];
    qty = int.parse(json['qty']);
  }
}

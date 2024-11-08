class ActivityAreaItem {
  String? workOrderNum;
  String? workOrderType;
  String? item;
  int? qty;
  ActivityAreaItem({this.workOrderNum, this.workOrderType, this.item, this.qty});

  ActivityAreaItem.fromJson(Map<String, dynamic> json) {
    workOrderNum = json['work_order_num'];
    workOrderType = json['work_order_type'];
    item = json['item'];
    qty = int.parse(json['qty']);
  }
}
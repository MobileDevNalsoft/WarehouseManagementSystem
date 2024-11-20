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


class InspectionDashboard{
  List<StatusCount>? totalQualityStatus;
  String? materialQuality;
  List<StatusCount>? daywiseQualitySummary;

  InspectionDashboard({this.totalQualityStatus, this.materialQuality, this.daywiseQualitySummary});

  InspectionDashboard.fromJson(Map<String, dynamic> json){
    totalQualityStatus = (json['total_quality_status'] as List).map((e) => StatusCount.fromJson(e)).toList();
    materialQuality = json['material_quality'];
    daywiseQualitySummary = (json['daywise_quality_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
  }
}

class StatusCount{
  String? status;
  int? count;
  StatusCount({this.status, this.count});

  StatusCount.fromJson(Map<String, dynamic> json){
    status = json.keys.first;
    count = json.values.first;
  }
}

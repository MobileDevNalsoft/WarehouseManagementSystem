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
  List<StatusCount>? todayQualityStatus;
  String? materialQuality;
  List<StatusCount>? daywiseQualitySummary;
  double? qualityEfficiency;
  List<SupplierQuality>? supplierQuality;
  InspectionDashboard({this.todayQualityStatus, this.materialQuality, this.daywiseQualitySummary, this.qualityEfficiency});

  InspectionDashboard.fromJson(Map<String, dynamic> json){
    todayQualityStatus = (json['today_quality_status'] as List).map((e) => StatusCount.fromJson(e)).toList();
    materialQuality = json['material_quality'];
    daywiseQualitySummary = (json['daywise_quality_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    qualityEfficiency = json['quality_efficiency'];
    supplierQuality = (json['supplier_quality'] as List).map((e) => SupplierQuality.fromJson(e)).toList();
  }
}

class StatusCount{
  String? status;
  int? count;
  StatusCount({this.status, this.count});

  StatusCount.fromJson(Map<String, dynamic> json){
    status = json.keys.first;
    count = json.values.first.toInt();
  }
}


class SupplierQuality{
  String? supplier;
  double? quality;
  SupplierQuality({this.supplier, this.quality});

  SupplierQuality.fromJson(Map<String, dynamic> json){
    supplier = json.keys.first;
    quality = json.values.first;
  }
}

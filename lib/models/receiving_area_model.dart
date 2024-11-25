import 'package:wmssimulator/models/inspection_area_model.dart';

class ReceivingArea {
  int? responseCode;
  String? responseMessage;
  List<ReceiveData>? data;

  ReceivingArea({this.responseCode, this.responseMessage, this.data});

  ReceivingArea.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = <ReceiveData>[];
      json['data'].forEach((v) {
        data!.add( ReceiveData.fromJson(v));
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

class   ReceiveData {
  String? asn;
  String? poNum;
  String? vendor;
  String? item;
  String? qty;

  ReceiveData({this.asn, this.poNum, this.vendor, this.item, this.qty});

  ReceiveData.fromJson(Map<String, dynamic> json) {
    asn = json['asn'];
    poNum = json['po_num'];
    vendor = json['vendor'];
    item = json['item'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asn'] = asn;
    data['po_num'] = poNum;
    data['vendor'] = vendor;
    data['item'] = item;
    data['qty'] = qty;
    return data;
  }
}


class ReceivingDashboard{
  List<InBoundSummary>? totalInBoundSummary;
  String? avgPutawayTime;
  String? avgReceivingTime;
  double? receivingEfficiency;
  AsnStatus? asnStatus;
  List<UserCount>? userReceivingEfficiency;
  List<StatusCount>? supplierwiseInboundSummary;
  double? putawayAccuracy;
  List<StatusCount>? dayWiseInboundSummary;
  ReceivingDashboard({this.totalInBoundSummary, this.avgPutawayTime, this.avgReceivingTime, this.userReceivingEfficiency, this.supplierwiseInboundSummary, this.putawayAccuracy, this.dayWiseInboundSummary,this.asnStatus,this.receivingEfficiency});

  ReceivingDashboard.fromJson(Map<String, dynamic> json){
    totalInBoundSummary = (json['total_inbound_summary'] as List).map((e) => InBoundSummary.fromJson(e)).toList();
    avgPutawayTime = json['avg_putaway_time'];
    avgReceivingTime = json['avg_receiving_time'];
    asnStatus = AsnStatus.fromJson(json['today_asn_status']);
    receivingEfficiency= json['receiving_efficiency'];
    dayWiseInboundSummary = (json['day_wise_inbound_summary'] as List).map((e)=> StatusCount.fromJson(e) ).toList();
    userReceivingEfficiency = (json['user_receiving_efficiency'] as List).map((e) => UserCount.fromJson(e)).toList();
    supplierwiseInboundSummary = (json['supplierwise_inbound_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    putawayAccuracy = json['putaway_accuracy'];
  }
}

class DayWiseInboundSummary {
  String? verifiedDate;
  int? shipmentCount;

  DayWiseInboundSummary({this.verifiedDate, this.shipmentCount});

  DayWiseInboundSummary.fromJson(Map<String, dynamic> json) {
    verifiedDate = json['verified_date'];
    shipmentCount = json['shipment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verified_date'] = this.verifiedDate;
    data['shipment_count'] = this.shipmentCount;
    return data;
  }
}
class AsnStatus {
  int? inTransit;
  int? inReceiving;
  int? receivied;
  int? cancelled;

  AsnStatus(
      {this.inTransit, this.inReceiving, this.receivied, this.cancelled});

  AsnStatus.fromJson(Map<String, dynamic> json) {
    inTransit = json['in_transit'];
    inReceiving = json['in_receiving'];
    receivied = json['receivied'];
    cancelled = json['cancelled '];
  }}
class InBoundSummary{
  String? status;
  int? total;
  InBoundSummary({this.status, this.total});

  InBoundSummary.fromJson(Map<String, dynamic> json){
    status = json.keys.first;
    total = json.values.first;
  }
}

class UserCount{
  String? userName;
  int? count;
  UserCount({this.userName, this.count});

  UserCount.fromJson(Map<String, dynamic> json){
    userName = json.keys.first;
    count = json.values.first;
  }
}
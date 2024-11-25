import 'package:wmssimulator/models/inspection_area_model.dart';

class StagingArea {
  int? responseCode;
  String? responseMessage;
  List<StagingData>? data;

  StagingArea({this.responseCode, this.responseMessage, this.data});

  StagingArea.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = <StagingData>[];
      json['data'].forEach((v) {
        data!.add(StagingData.fromJson(v));
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

class StagingData {
  String? orderNum;
  String? custName;
  String? item;
  String? qty;

  StagingData({this.orderNum, this.custName, this.item, this.qty});

  StagingData.fromJson(Map<String, dynamic> json) {
    orderNum = json['order_num'];
    custName = json['cust_name'] ?? '';
    item = json['item'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_num'] = orderNum;
    data['cust_name'] = custName;
    data['item'] = item;
    data['qty'] = qty;
    return data;
  }
}

class StagingDashboard{
  List<StatusCount>? todayOrderSummary;
  List<StatusCount>? todayChannelSummary;
  List<StatusCount>? daywiseOrderSummary;
  List<StatusCount>? userwiseEfficiency;
  List<StatusCount>? orderAging;
  String? shippingEfficiency;
  int? avgLeadTime;
  double? fulfilmentTime;

  StagingDashboard({this.todayOrderSummary, this.todayChannelSummary, this.daywiseOrderSummary, this.userwiseEfficiency, this.shippingEfficiency, this.avgLeadTime, this.orderAging, this.fulfilmentTime});

  StagingDashboard.fromJson(Map<String, dynamic> json){
    todayOrderSummary = (json['today_order_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    todayChannelSummary = (json['today_channel_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    daywiseOrderSummary = (json['daywise_order_summary'] as List).map((e) => StatusCount.fromJson(e)).toList();
    userwiseEfficiency = (json['user_efficiency'] as List).map((e) => StatusCount.fromJson(e)).toList();
    orderAging = (json['order_aging'] as List).map((e) => StatusCount.fromJson(e)).toList();
    shippingEfficiency = json['shipping_efficiency'];
    avgLeadTime = json['avg_lead_time'];
    fulfilmentTime = json['fulfilment_time'];
  }
}
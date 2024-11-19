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
  ReceivingDashboard({this.totalInBoundSummary});

  ReceivingDashboard.fromJson(Map<String, dynamic> json){
    totalInBoundSummary = (json['total_inbound_summary'] as List).map((e) => InBoundSummary.fromJson(e)).toList();
  }
}

class InBoundSummary{
  String? status;
  int? total;
  InBoundSummary({this.status, this.total});

  InBoundSummary.fromJson(Map<String, dynamic> json){
    status = json.keys.first;
    total = json.values.first;
  }
}
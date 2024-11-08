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
        data!.add(new StagingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_message'] = this.responseMessage;
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
    custName = json['cust_name'];
    item = json['item'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_num'] = this.orderNum;
    data['cust_name'] = this.custName;
    data['item'] = this.item;
    data['qty'] = this.qty;
    return data;
  }
}
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_message'] = this.responseMessage;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['asn'] = this.asn;
    data['po_num'] = this.poNum;
    data['vendor'] = this.vendor;
    data['item'] = this.item;
    data['qty'] = this.qty;
    return data;
  }
}

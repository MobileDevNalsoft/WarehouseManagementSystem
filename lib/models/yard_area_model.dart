class YardArea {
  int? resultCount;
  int? pageCount;
  int? pageNbr;
  String? nextPage;
  int? previousPage;
  List<Results>? results;

  YardArea(
      {this.resultCount,
      this.pageCount,
      this.pageNbr,
      this.nextPage,
      this.previousPage,
      this.results});

  YardArea.fromJson(Map<String, dynamic> json) {
    resultCount = json['result_count'];
    pageCount = json['page_count'];
    pageNbr = json['page_nbr'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result_count'] = this.resultCount;
    data['page_count'] = this.pageCount;
    data['page_nbr'] = this.pageNbr;
    data['next_page'] = this.nextPage;
    data['previous_page'] = this.previousPage;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  int? seqNbr;
  String? vehicleLocation;
  String? shipmentNbr;
  String? truckNbr;
  String? poNbr;
  String? vendorCode;

  Results(
      {this.id,
      this.seqNbr,
      this.vehicleLocation,
      this.shipmentNbr,
      this.truckNbr,
      this.poNbr,
      this.vendorCode});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seqNbr = json['seq_nbr'];
    vehicleLocation = json['to_location'];
    shipmentNbr = json['shipment_nbr'];
    truckNbr = json['trailer_nbr'];
    poNbr = json['po_nbr'];
    vendorCode = json['vendor_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seq_nbr'] = this.seqNbr;
    data['to_location'] = this.vehicleLocation;
    data['shipment_nbr'] = this.shipmentNbr;
    data['trailer_nbr'] = this.truckNbr;
    data['po_nbr'] = this.poNbr;
    data['vendor_code'] = this.vendorCode;
    return data;
  }
}

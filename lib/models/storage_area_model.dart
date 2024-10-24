class StorageArea {
  int? resultCount;
  int? pageCount;
  int? pageNbr;
  List<Results>? results;

  StorageArea({this.resultCount, this.pageCount, this.pageNbr, this.results});

  StorageArea.fromJson(Map<String, dynamic> json) {
    resultCount = json['result_count'];
    pageCount = json['page_count'];
    pageNbr = json['page_nbr'];
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
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? area;
  String? aisle;
  String? bay;
  String? level;
  String? position;
  String? bin;
  TypeId? typeId;
  TypeId? locnSizeTypeId;
  String? barcode;

  Results(
      {this.id,
      this.area,
      this.aisle,
      this.bay,
      this.level,
      this.position,
      this.bin,
      this.typeId,
      this.locnSizeTypeId,
      this.barcode});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    area = json['area'];
    aisle = json['aisle'];
    bay = json['bay'];
    level = json['level'];
    position = json['position'];
    bin = json['bin'];
    typeId =
        json['type_id'] != null ? new TypeId.fromJson(json['type_id']) : null;
    locnSizeTypeId = json['locn_size_type_id'] != null
        ? new TypeId.fromJson(json['locn_size_type_id'])
        : null;
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area'] = this.area;
    data['aisle'] = this.aisle;
    data['bay'] = this.bay;
    data['level'] = this.level;
    data['position'] = this.position;
    data['bin'] = this.bin;
    if (this.typeId != null) {
      data['type_id'] = this.typeId!.toJson();
    }
    if (this.locnSizeTypeId != null) {
      data['locn_size_type_id'] = this.locnSizeTypeId!.toJson();
    }
    data['barcode'] = this.barcode;
    return data;
  }
}

class TypeId {
  int? id;
  String? key;

  TypeId({this.id, this.key});

  TypeId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    return data;
  }
}

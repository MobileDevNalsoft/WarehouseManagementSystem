class WarehouseData{
  List<RackInfo>? racks;
  WarehouseData({this.racks});

  WarehouseData.fromJson(Map<String, dynamic> json){
    racks = (json['warehouse']['racks'] as List).map((e) => RackInfo.fromJson(e)).toList();
  }
}

class RackInfo{
  int? rackId;
  String? categoryName;
  List<ItemInfo>? items;
  int? totalQuantity;
  RackInfo({this.rackId, this.categoryName,this.items, this.totalQuantity = 0});

  RackInfo.fromJson(Map<String, dynamic> json){
    rackId = json['rackId'];
    categoryName = json['category'];
    items = (json['items'] as List).map((e) => ItemInfo.fromJson(e)).toList();
    items!.forEach((e) => totalQuantity = (totalQuantity ?? 0) + (e.quantity ?? 0));
  }
}

class ItemInfo{
  String? itemName;
  int? quantity;
  ItemInfo({this.itemName, this.quantity});

  ItemInfo.fromJson(Map<String, dynamic> json){
    itemName = json['itemName'];
    quantity = json['quantity'];
  }
}
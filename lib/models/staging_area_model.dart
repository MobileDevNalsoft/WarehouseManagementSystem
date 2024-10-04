class StatingArea{
  String? areaName;
  List<Material>? materials;
  StatingArea({this.areaName, this.materials});

  StatingArea.fromJson(Map<String, dynamic> json){
    areaName = json['area_name'];
    materials = (json['materials'] as List).map((e) => Material.fromJson(e)).toList();
  }
}

class Material{
  String? orderNumber;
  String? obLoad;
  String? item;
  int? quantity;
  Material({this.orderNumber, this.obLoad, this.item, this.quantity});

  Material.fromJson(Map<String, dynamic> json){
    orderNumber = json['order_number'];
    obLoad = json['ob_load'];
    item = json['item'];
    quantity = json['qty'];
  }
}
class CycleCountTask {
  bool? isChecked;
  String? facility;
  String? companyID;
  int? grpNbr;
  String? task;
  int? totalExpectedQuantity;
  String? uom;
  int? totalCountedQty;
  String? uom2;
  int? totalAdjustedQty;
  String? uom3;
  int? totalAdjustedCost;
  String? status;
  String? location;
  String? createUser;
  String? createTimestamp;

  CycleCountTask(
      {this.isChecked,
      this.facility,
      this.companyID,
      this.status,
      this.grpNbr,
      this.createTimestamp,
      this.createUser,
      this.location,
      this.task,
      this.totalAdjustedCost,
      this.totalAdjustedQty,
      this.totalCountedQty,
      this.totalExpectedQuantity,
      this.uom,
      this.uom2,
      this.uom3});

  CycleCountTask.fromJson(Map<String, dynamic> json) {
    isChecked = json['isChecked'];
    facility = json['facility'];
    companyID = json['companyID'];
    grpNbr = json['grpNbr'];
    task = json['task'];
    totalExpectedQuantity = json['totalExpectedQuantity'];
    uom = json['uom'];
    totalCountedQty = json['totalCountedQty'];
    uom2 = json['uom2'];
    totalAdjustedQty = json['totalAdjustedQty'];
    uom3 = json['uom3'];
    totalAdjustedCost = json['totalAdjustedCost'];
    status = json['status'];
    location = json['location'];
    createUser = json['createUser'];
    createTimestamp = json['createTimestamp'];
  }
}

class QualityCheckTask {
  bool? isChecked;
  String? facility;
  String? lpnNbr;
  String? status;
  String? qcStatus;
  String? itemCode;
  String? itemDescription;
  String? currQty;
  String? uom;
  String? location;
  String? batchNbr;
  String? expiryDate;
  String? manufactureDate;
  String? origQty;
  String? uom2;
  String? receivedQty;
  String? uom3;
  String? poNbr;
  String? receivedShipment;
  String? putawayType;
  String? modUser;
  String? modTs;
  String? receivedUser;
  String? shipmentType;
  String? weight;
  String? uomwt;
  String? volume;
  String? uomvol;

  QualityCheckTask(
      {this.isChecked = false,
      this.batchNbr,
      this.modUser,
      this.modTs,
      this.currQty,
      this.expiryDate,
      this.facility,
      this.itemCode,
      this.itemDescription,
      this.location,
      this.lpnNbr,
      this.manufactureDate,
      this.origQty,
      this.poNbr,
      this.putawayType,
      this.qcStatus,
      this.receivedQty,
      this.receivedShipment,
      this.receivedUser,
      this.shipmentType,
      this.status,
      this.uom,
      this.uom2,
      this.uom3,
      this.uomvol,
      this.uomwt,
      this.volume,
      this.weight});

  QualityCheckTask.fromJson(Map<String, dynamic> json) {
    isChecked = false;
    facility = json['facility'];
    modUser = json['modUser'];
    modTs = json['modTs'];
    lpnNbr = json['lpnNbr'];
    status = json['status'];
    qcStatus = json['qcStatus'];
    itemCode = json['itemCode'];
    itemDescription = json['itemDescription'];
    currQty = json['currQty'];
    uom = json['uom'];
    location = json['location'];
    batchNbr = json['batchNbr'];
    expiryDate = json['expiryDate'];
    manufactureDate = json['manufactureDate'];
    origQty = json['origQty'];
    uom2 = json['uom2'];
    receivedQty = json['receivedQty'];
    uom3 = json['uom3'];
    poNbr = json['poNbr'];
    receivedShipment = json['receivedShipment'];
    putawayType = json['putawayType'];
    receivedUser = json['receivedUser'];
    shipmentType = json['shipmentType'];
    weight = json['weight'];
    uomwt = json['uomwt'];
    volume = json['volume'];
    uomvol = json['uomvol'];
  }
}

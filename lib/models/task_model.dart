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

  CycleCountTask.fromJson(Map<String, dynamic> json) {}
}

class QualityCheckTask {
  bool? isChecked;
  String? facility;
  String? lpnNbr;
  String? status;
  String? qcStatus;
  String? itemCode;
  String? itemDescription;
  int? currQty;
  String? uom;
  String? location;
  int? batchNbr;
  String? expiryDate;
  String? manufactureDate;
  int? origQty;
  String? uom2;
  int? receivedQty;
  String? uom3;
  String? poNbr;
  String? receivedShipment;
  String? putawayType;
  String? createTimestamp;
  String? receivingUser;
  String? shipmentType;
  double? weight;
  String? uomwt;
  double? volume;
  String? uomvol;

  QualityCheckTask(
      {this.isChecked = false,
      this.batchNbr,
      this.createTimestamp,
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
      this.receivingUser,
      this.shipmentType,
      this.status,
      this.uom,
      this.uom2,
      this.uom3,
      this.uomvol,
      this.uomwt,
      this.volume,
      this.weight});

  QualityCheckTask.fromJson(Map<String, dynamic> json) {}
}

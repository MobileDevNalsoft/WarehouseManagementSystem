import 'package:warehouse_3d/models/inspection_area_model.dart';

class DockAreaItem {
  String? dockType;
  String? truckNum;
  String? asn;
  String? poNum;
  String? vendor;
  String? checkInTS;
  int? qty;
  DockAreaItem({this.dockType, this.truckNum, this.asn, this.poNum, this.vendor, this.checkInTS, this.qty});

  DockAreaItem.fromJson(Map<String, dynamic> json) {
    dockType = json['dock_type'];
    truckNum = json['truck_number'];
    asn = json['asn'];
    poNum = json['po_nbr'];
    vendor = json['vendor'];
    checkInTS = json['checkin_ts'];
    qty = int.parse(json['qty']);
  }
}

class DockDashboard{
  List<StatusCount>? dockInUtilization;
  List<StatusCount>? dockOutUtilization;
  List<StatusCount>? daywiseDockInUtilization;
  List<StatusCount>? daywiseDockOutUtilization;
  String? avgLoadingTime;
  String? avgUnloadingTime;
  String? avgDockTAT;

  DockDashboard({this.dockInUtilization, this.dockOutUtilization, this.avgLoadingTime, this.avgUnloadingTime, this.avgDockTAT});

  DockDashboard.fromJson(Map<String, dynamic> json){
    dockInUtilization = (json['dock_in_utilization'] as List).map((e) => StatusCount.fromJson(e)).toList();
    dockOutUtilization = (json['dock_out_utilization'] as List).map((e) => StatusCount.fromJson(e)).toList();
    daywiseDockInUtilization = (json['daywise_dock_in'] as List).map((e) => StatusCount.fromJson(e)).toList();
    daywiseDockOutUtilization = (json['daywise_dock_out'] as List).map((e) => StatusCount.fromJson(e)).toList();
    avgLoadingTime = json['avg_loading_time'];
    avgUnloadingTime = json['avg_unloading_time'];
    avgDockTAT = json['avg_dock_tat'];
  }
}

class Appointment{
  String? apptNbr;
  String? dockNbr;
  String? startTime;
  String? endTime;

  Appointment({this.apptNbr, this.dockNbr, this.startTime, this.endTime});

  Appointment.fromJson(Map<String, dynamic> json){
    apptNbr = json['appt_nbr'] ?? 'NA';
    dockNbr = json['dock_nbr'] ?? 'NA';
    startTime = json['start_time'] ?? 'NA';
    endTime = json['end_time'] ?? 'NA';
  }
}
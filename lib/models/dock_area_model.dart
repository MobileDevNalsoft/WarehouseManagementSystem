import 'package:wmssimulator/models/inspection_area_model.dart';

class DockAreaItem {
  String? truckNum;
  List<Vendor>? vendors;
  DockAreaItem({this.truckNum, this.vendors});

  DockAreaItem.fromJson(Map<String, dynamic> json) {
    truckNum = json.keys.first;
    vendors = (json.values.first as List).map((e) => Vendor.fromJson(e)).toList();
  }
}

class Vendor{
  String? vendorName;
  List<DockItem>? items;
  Vendor({this.vendorName, this.items});

  Vendor.fromJson(Map<String, dynamic> json){
    vendorName = json.keys.first;
    items = (json.values.first as List).map((e) => DockItem.fromJson(e)).toList();
  }
}

class DockItem{
  String? dockNbr;
  String? asn;
  String? poNbr;
  String? checkinTS;
  int? qty;
  DockItem({this.dockNbr, this.asn, this.poNbr, this.checkinTS, this.qty});

  DockItem.fromJson(Map<String, dynamic> json){
    dockNbr = json['actual_dock_nbr'];
    asn = json['asn'];
    poNbr = json['po_nbr'];
    checkinTS = json['checkin_ts'];
    qty = json['qty'];
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
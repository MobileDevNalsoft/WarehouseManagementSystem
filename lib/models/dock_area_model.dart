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
  DockUtilization? dockInUtilization;
  DockUtilization? dockOutUtilization;
  List<DaywiseDockUtilization>? daywiseDockInUtilization;
  List<DaywiseDockUtilization>? daywiseDockOutUtilization;
  String? avgLoadingTime;
  String? avgUnloadingTime;
  String? avgDockTAT;

  DockDashboard({this.dockInUtilization, this.dockOutUtilization, this.avgLoadingTime, this.avgUnloadingTime, this.avgDockTAT});

  DockDashboard.fromJson(Map<String, dynamic> json){
    dockInUtilization = DockUtilization.fromJson(json['dock_in_utilization']);
    dockOutUtilization = DockUtilization.fromJson(json['dock_out_utilization']);
    daywiseDockInUtilization = (json['daywise_dock_in'] as List).map((e) => DaywiseDockUtilization.fromJson(e)).toList();
    daywiseDockOutUtilization = (json['daywise_dock_out'] as List).map((e) => DaywiseDockUtilization.fromJson(e)).toList();
    avgLoadingTime = json['avg_loading_time'];
    avgUnloadingTime = json['avg_unloading_time'];
    avgDockTAT = json['avg_dock_tat'];
  }
}

class DockUtilization{
  int? total;
  int? available;
  int? utilized;
  DockUtilization({this.total, this.available, this.utilized});

  DockUtilization.fromJson(Map<String, dynamic> json){
    total = json['total'];
    available = json['available'];
    utilized = json['utilized'];
  }
}

class DaywiseDockUtilization{
  String? date;
  int? vehicleCount;
  DaywiseDockUtilization({this.date, this.vehicleCount});

  DaywiseDockUtilization.fromJson(Map<String, dynamic> json){
    date = json.keys.first;
    vehicleCount = json.values.first;
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
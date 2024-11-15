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
  List<Appointment>? appointments;
  DockDashboard({this.appointments});

  DockDashboard.fromJson(Map<String, dynamic> json){
    appointments = (json['appointments'] as List).map((e) => Appointment.fromJson(e)).toList();
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
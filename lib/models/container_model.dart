import 'package:intl/intl.dart';

class ContainerData {
  int? lotNbr;
  String? containerNbr;
  String? customer;
  DateTime? arrivalDate;
  bool? priority;
  String? bound;
  int? type;
  int? status;
  ContainerData({this.lotNbr, this.containerNbr, this.customer, this.arrivalDate, this.priority = false, this.bound, this.type, this.status});

  factory ContainerData.fromJson(Map<String, dynamic> json) {
    return ContainerData(
        lotNbr: json['lotNbr'] as int?,
        containerNbr: json['containerNbr'] as String?,
        customer: json['customer'] as String?,
        arrivalDate: DateTime.parse(json['arrivalDate']),
        priority: json['priority'],
        bound: json['bound'],
        type: json['type'],
        status: json['status']);
  }
}

class LPNStatus {
  String? status;
  String? user;
  String? date;
  LPNStatus({this.status, this.user, this.date});
  factory LPNStatus.fromJson(Map<String, dynamic> json) {
    return LPNStatus(
        status: json['status'] as String?,
        user: json['user'] as String?,
        date: DateFormat("yyyy-MM-dd hh:mm:ss a").format(DateTime.parse(json['date']).toLocal()));
  }
}

class YardAreaItem {
  int? id;
  String? vehicleLocation;
  String? truckNbr;
  String? vehicleEntryTime;
  String? seqNbr;
  String? shipmentNbr;
  String? poNbr;
  String? vendorCode;

  YardAreaItem({this.id, this.vehicleLocation, this.truckNbr, this.vehicleEntryTime, this.seqNbr, this.shipmentNbr, this.poNbr, this.vendorCode});

  YardAreaItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleLocation = json['vehicle_location'];
    truckNbr = json['truck_nbr'];
    vehicleEntryTime = json['vehicle_entry_time'];
    seqNbr = json['seq_nbr'];
    shipmentNbr = json['shipment_nbr'];
    poNbr = json['po_nbr'];
    vendorCode = json['vendor_code'];
  }
}

class YardDashboard {
  YardDetention? yardDetention;
  YardUtilization? yardUtilization;
  List<DayWiseYardUtilzation>? dayWiseYardUtilzation;
  PreviousMonthYardUtilization? previousMonthYardUtilization;
  AverageYardTime? averageYardTime;

  YardDashboard({this.yardDetention, this.yardUtilization, this.dayWiseYardUtilzation, this.previousMonthYardUtilization, this.averageYardTime});

  YardDashboard.fromJson(Map<String, dynamic> json) {
    yardDetention = json['yard_detention'] != null ? YardDetention.fromJson(json['yard_detention']) : null;
    yardUtilization = json['yard_utilization'] != null ? YardUtilization.fromJson(json['yard_utilization']) : null;
    if (json['day_wise_yard_utilzation'] != null) {
      dayWiseYardUtilzation = <DayWiseYardUtilzation>[];
      json['day_wise_yard_utilzation'].forEach((v) {
        dayWiseYardUtilzation!.add(DayWiseYardUtilzation.fromJson(v));
      });
    }
    previousMonthYardUtilization =
        json['previous_month_yard_utilization'] != null ? PreviousMonthYardUtilization.fromJson(json['previous_month_yard_utilization']) : null;
    averageYardTime = json['average_yard_time'] != null ? AverageYardTime.fromJson(json['average_yard_time']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (yardDetention != null) {
      data['yard_detention'] = yardDetention!.toJson();
    }
    if (yardUtilization != null) {
      data['yard_utilization'] = yardUtilization!.toJson();
    }
    if (dayWiseYardUtilzation != null) {
      data['day_wise_yard_utilzation'] = dayWiseYardUtilzation!.map((v) => v.toJson()).toList();
    }
    if (previousMonthYardUtilization != null) {
      data['previous_month_yard_utilization'] = previousMonthYardUtilization!.toJson();
    }
    if (averageYardTime != null) {
      data['average_yard_time'] = averageYardTime!.toJson();
    }
    return data;
  }
}

class YardDetention {
  int? count1To7Days;
  int? countGreaterThan7Days;
  int? singleDayCount;

  YardDetention({this.count1To7Days, this.countGreaterThan7Days, this.singleDayCount});

  YardDetention.fromJson(Map<String, dynamic> json) {
    count1To7Days = json['count_1_to_7_days'];
    countGreaterThan7Days = json['count_greater_than_7_days'];
    singleDayCount = json['single_day_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count_1_to_7_days'] = count1To7Days;
    data['count_greater_than_7_days'] = countGreaterThan7Days;
    data['single_day_count'] = singleDayCount;
    return data;
  }
}

class YardUtilization {
  int? occupied;
  int? totalLocations;

  YardUtilization({this.occupied, this.totalLocations});

  YardUtilization.fromJson(Map<String, dynamic> json) {
    occupied = json['occupied'];
    totalLocations = json['total_locations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occupied'] = occupied;
    data['total_locations'] = totalLocations;
    return data;
  }
}

class DayWiseYardUtilzation {
  String? checkInDate;
  int? loadingCnt;
  int? unloadingCnt;

  DayWiseYardUtilzation({this.checkInDate, this.loadingCnt, this.unloadingCnt});

  DayWiseYardUtilzation.fromJson(Map<String, dynamic> json) {
    checkInDate = json['check_in_date'];
    loadingCnt = json['loading_cnt'];
    unloadingCnt = json['unloading_cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['check_in_date'] = checkInDate;
    data['loading_cnt'] = loadingCnt;
    data['unloading_cnt'] = unloadingCnt;
    return data;
  }
}

class PreviousMonthYardUtilization {
  int? loadingCount;
  int? unloadingCount;

  PreviousMonthYardUtilization({this.loadingCount, this.unloadingCount});

  PreviousMonthYardUtilization.fromJson(Map<String, dynamic> json) {
    loadingCount = json['loading_count'];
    unloadingCount = json['unloading_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loading_count'] = loadingCount;
    data['unloading_count'] = unloadingCount;
    return data;
  }
}

class AverageYardTime {
  double? avgYardTime;

  AverageYardTime({this.avgYardTime});

  AverageYardTime.fromJson(Map<String, dynamic> json) {
    avgYardTime = json['avg_yard_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avg_yard_time'] = avgYardTime;
    return data;
  }
}

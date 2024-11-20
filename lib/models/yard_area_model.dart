class YardAreaItem {
  int? id;
  String? vehicleLocation;
  String? truckNbr;
  String? vehicleEntryTime;
  String? seqNbr;
  String? shipmentNbr;
  String? poNbr;
  String? vendorCode;

  YardAreaItem(
      {this.id,
      this.vehicleLocation,
      this.truckNbr,
      this.vehicleEntryTime,
      this.seqNbr,
      this.shipmentNbr,
      this.poNbr,
      this.vendorCode});

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

  YardDashboard(
      {this.yardDetention,
      this.yardUtilization,
      this.dayWiseYardUtilzation,
      this.previousMonthYardUtilization,
      this.averageYardTime});

  YardDashboard.fromJson(Map<String, dynamic> json) {
    yardDetention = json['yard_detention'] != null
        ? new YardDetention.fromJson(json['yard_detention'])
        : null;
    yardUtilization = json['yard_utilization'] != null
        ? new YardUtilization.fromJson(json['yard_utilization'])
        : null;
    if (json['day_wise_yard_utilzation'] != null) {
      dayWiseYardUtilzation = <DayWiseYardUtilzation>[];
      json['day_wise_yard_utilzation'].forEach((v) {
        dayWiseYardUtilzation!.add(new DayWiseYardUtilzation.fromJson(v));
      });
    }
    previousMonthYardUtilization =
        json['previous_month_yard_utilization'] != null
            ? new PreviousMonthYardUtilization.fromJson(
                json['previous_month_yard_utilization'])
            : null;
    averageYardTime = json['average_yard_time'] != null
        ? new AverageYardTime.fromJson(json['average_yard_time'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.yardDetention != null) {
      data['yard_detention'] = this.yardDetention!.toJson();
    }
    if (this.yardUtilization != null) {
      data['yard_utilization'] = this.yardUtilization!.toJson();
    }
    if (this.dayWiseYardUtilzation != null) {
      data['day_wise_yard_utilzation'] =
          this.dayWiseYardUtilzation!.map((v) => v.toJson()).toList();
    }
    if (this.previousMonthYardUtilization != null) {
      data['previous_month_yard_utilization'] =
          this.previousMonthYardUtilization!.toJson();
    }
    if (this.averageYardTime != null) {
      data['average_yard_time'] = this.averageYardTime!.toJson();
    }
    return data;
  }
}

class YardDetention {
  int? count1To7Days;
  int? countGreaterThan7Days;
  int? singleDayCount;

  YardDetention(
      {this.count1To7Days, this.countGreaterThan7Days, this.singleDayCount});

  YardDetention.fromJson(Map<String, dynamic> json) {
    count1To7Days = json['count_1_to_7_days'];
    countGreaterThan7Days = json['count_greater_than_7_days'];
    singleDayCount = json['single_day_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count_1_to_7_days'] = this.count1To7Days;
    data['count_greater_than_7_days'] = this.countGreaterThan7Days;
    data['single_day_count'] = this.singleDayCount;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['occupied'] = this.occupied;
    data['total_locations'] = this.totalLocations;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_in_date'] = this.checkInDate;
    data['loading_cnt'] = this.loadingCnt;
    data['unloading_cnt'] = this.unloadingCnt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loading_count'] = this.loadingCount;
    data['unloading_count'] = this.unloadingCount;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg_yard_time'] = this.avgYardTime;
    return data;
  }
}

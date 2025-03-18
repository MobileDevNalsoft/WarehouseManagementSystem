class Trip {
  String? shipmentNbr;
  String? status;
  String? vehicleNbr;
  String? driver;
  Location? startLoc;
  Location? endLoc;
  String? carrier;
  String? trailerType;
  String? estStartDate;
  String? estDeliveryDate;
  List<Location>? waypoints;
  Location? coveredEnd;
  VehicleInfo? vehicleInfo;

  Trip({
    this.shipmentNbr,
    this.status,
    this.vehicleNbr,
    this.driver,
    this.startLoc,
    this.endLoc,
    this.carrier,
    this.trailerType,
    this.estStartDate,
    this.estDeliveryDate,
    this.waypoints,
    this.coveredEnd,
    this.vehicleInfo
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      shipmentNbr: json['shipmentNbr'],
      status: json['status'],
      vehicleNbr: json['vehicleNbr'],
      driver: json['driver'],
      startLoc: json['startLoc'] != null ? Location.fromJson(json['startLoc']) : null,
      endLoc: json['endLoc'] != null ? Location.fromJson(json['endLoc']) : null,
      carrier: json['carrier'],
      trailerType: json['trailerType'],
      estStartDate: json['estStartDate'],
      estDeliveryDate: json['estEndDate'],
      waypoints: json['waypoints'] != null ? (json['waypoints'] as List).map((e) => Location.fromJson(e)).toList() : null,
      coveredEnd: json['coveredEnd'] != null ? Location.fromJson(json['coveredEnd']) : null,
    );
  }
}

class Location {
  String? location;
  double? latitude;
  double? longitude;
  Location({this.location, this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class VehicleInfo {
  double? speed;
  double? odometerValue;
  double? engineTemp;
  double? containerTemp;
  double? fuel;
  bool? ignition;
  double? containerWeight;

  VehicleInfo({this.speed, this.odometerValue, this.engineTemp, this.containerTemp, this.fuel, this.ignition, this.containerWeight});
  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      speed: json['speed'],
      odometerValue: json['odometerValue'],
      engineTemp: json['engineTemp'],
      containerTemp: json['containerTemp'],
      fuel: json['fuel'],
      ignition: json['ignition'],
      containerWeight: json['containerWeight']
    );
  }
}

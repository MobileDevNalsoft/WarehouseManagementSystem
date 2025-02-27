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
  String? estEndDate;

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
    this.estEndDate,
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
      estEndDate: json['estEndDate'],
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

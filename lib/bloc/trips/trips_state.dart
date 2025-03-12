part of 'trips_bloc.dart';

enum TripsStatus { initial, loading, success, failure }

enum GeoLocationStatus { initial, loading, success, failure }

class   TripsState {
  List<Trip>? trips;
  final TripsStatus? getTripsStatus;
  Trip? selectedTrip;
  List<LatLng> locations;
  List<LatLng> routeCoords;
  List<LatLng> coveredPath;
  Set<Polyline> polylines;
  GeoLocationStatus geoLocationStatus;
  GoogleMapController? mapController;
  Set<Marker> markers;
  List<LatLng> waypoints;
  LatLng? coveredEnd;
  bool? isDriverAnimated = false;
  ScreenCoordinate? markerScreenPosition;
  LatLng? activeMarkerPosition;
  bool? displayTruckOverlay;

  ScreenCoordinate? screenPosition;
  Widget overlayWidget;
  ScreenCoordinate? truckPosition;
  double? currentAngle;
  double? targetAngle;

  TripsState(
      {this.trips,
      this.getTripsStatus,
      this.selectedTrip,
      required this.routeCoords,
      required this.coveredPath,
      required this.polylines,
      required this.geoLocationStatus,
      required this.markers,
      required this.waypoints,
      required this.locations,
      this.coveredEnd,
      this.isDriverAnimated,
      this.markerScreenPosition,
      this.activeMarkerPosition,
      this.displayTruckOverlay,
      this.mapController,

      this.screenPosition,
      required this.overlayWidget,
      this.truckPosition,
      this.currentAngle,
      this.targetAngle  

      });

  factory TripsState.initial() {
    return TripsState(
        getTripsStatus: TripsStatus.initial,
        routeCoords: [],
        coveredPath: [],
        polylines: {},
        geoLocationStatus: GeoLocationStatus.initial,
        markers: {},
        waypoints: [],
        locations: [],

        trips: [
          Trip(
            shipmentNbr: 'OSPAID00000081',
            status: 'Enroute',
            vehicleNbr: 'AT 56 NA',
            driver: 'FINN',
            startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
            endLoc: Location(location: 'Rotterdam', latitude: 51.9467778, longitude: 4.0120435),
            carrier: 'DHL EXPRESS',
            trailerType: 'B-TRAIN',
            estStartDate: '2/27/2025 19:00',
            estDeliveryDate: '3/4/2025 7:00',
            waypoints: [
              Location(location: 'KEN AUTOS Utrecht, Netherlands', latitude: 52.08204086, longitude: 5.06071463),
              Location(location: 'MINI Stores Gouda, Netherlands', latitude: 52.0205691, longitude: 4.6838097),
            ],
            coveredEnd: Location(location: 'MINI Stores Gouda, Netherlands', latitude: 52.0205691, longitude: 4.6838097),
                        vehicleInfo: VehicleInfo(speed: 63,odometerValue: 003241,ignition: true,containerTemp: 30,engineTemp: 62,containerWeight: 1200,fuel: 0.8)

          ),
          Trip(
            shipmentNbr: 'OSPAID00000042',
            status: 'Enroute',
            vehicleNbr: 'AM 33 LN',
            driver: 'SRAVAN',
            startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
            endLoc: Location(location: 'Eemshaven', latitude: 53.4232793, longitude: 6.856575),
            carrier: 'DHL',
            trailerType: 'REEFERS',
            estStartDate: '2/28/2025 19:00',
            estDeliveryDate: '3/4/2025 7:00',
            waypoints: [
              Location(location: 'HEMA Stores', latitude: 52.7217541, longitude: 6.47934),
            ],
            vehicleInfo: VehicleInfo(speed: 63,odometerValue: 003241,ignition: true,containerTemp: 30,engineTemp: 62,containerWeight: 1200,fuel: 0.8)
          ),
          Trip(
              shipmentNbr: 'OSPAID00000221',
              status: 'Created',
              vehicleNbr: 'MS 07 DH',
              driver: 'DANIEL',
              startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
              endLoc: Location(location: 'Meppen', latitude: 52.722777, longitude: 7.1852235),
              carrier: 'DHL',
              trailerType: 'TANKER',
              estStartDate: '2/28/2025 19:00',
              estDeliveryDate: '3/3/2025 7:00',
              vehicleInfo: VehicleInfo(speed: 0,odometerValue: 009241,ignition: false,containerTemp: 30,engineTemp: 26,containerWeight: 1200,fuel: 0.8)
),
          Trip(
              shipmentNbr: 'OSPAID00000165',
              status: 'Created',
              vehicleNbr: 'SB 68 TR',
              driver: 'THOMAS',
              startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
              endLoc: Location(location: 'Bolsward', latitude: 53.0718742, longitude: 5.4992449),
              carrier: 'FEDEX',
              trailerType: 'B-TRAIN',
              estStartDate: '3/2/2025 19:00',
              estDeliveryDate: '3/5/2025 7:00',
              vehicleInfo: VehicleInfo(speed: 0,odometerValue: 003491,ignition: false,containerTemp: 30,engineTemp: 25,containerWeight: 1200,fuel: 0.3)
              ),
          Trip(
              shipmentNbr: 'OSPAID00000167',
              status: 'Created',
              vehicleNbr: 'NL 73 CD',
              driver: 'TONY',
              startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
              endLoc: Location(location: 'Mechelen', latitude: 50.7955998, longitude: 5.9219933),
              carrier: 'FEDEX',
              trailerType: 'DRY VAN',
              estStartDate: '3/1/2025 19:00',
              estDeliveryDate: '3/1/2025 7:00',
              vehicleInfo: VehicleInfo(speed: 0,odometerValue: 103241,ignition: false,containerTemp: 30,engineTemp: 23,containerWeight:600,fuel: 0.9)),
          Trip(
              shipmentNbr: 'OSPAID00000161',
              status: 'Created',
              vehicleNbr: 'HB 88 NL',
              driver: 'JAMES',
              startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
              endLoc: Location(location: 'Rotterdam', latitude: 51.9467778, longitude: 4.0120435),
              carrier: 'IFS',
              trailerType: 'B-TRAIN',
              estStartDate: '3/4/2025 19:00',
              estDeliveryDate: '3/5/2025 7:00',
              vehicleInfo: VehicleInfo(speed: 0,odometerValue: 018641,ignition: false,containerTemp: 30,engineTemp: 62,containerWeight: 835,fuel: 0.65)),
          Trip(
              shipmentNbr: 'OSPAID00000085',
              status: 'Delivered',
              vehicleNbr: 'BH 39 FG',
              driver: 'STARK',
              startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
              endLoc: Location(location: 'Rutten', latitude: 52.8106532, longitude: 5.6782561),
              carrier: 'FEDEX EXPRESS',
              trailerType: 'DAVID',
              estStartDate: '14/03/2025 15:38',
              estDeliveryDate: '16/03/2025 06:42',
              vehicleInfo: VehicleInfo(speed: 0,odometerValue: 202241,ignition: false,containerTemp: 30,engineTemp: 32,containerWeight: 1200,fuel: 0.8)),
          Trip(
              shipmentNbr: 'OSPAID00000169',
              status: 'Delivered',
              vehicleNbr: 'GF 98 YR',
              driver: 'PHILLIPS',
              startLoc: Location(location: 'Amsterdam Facility', latitude: 52.3940369, longitude: 4.8505386),
              endLoc: Location(location: 'Wieringerwerf', latitude: 52.8498501, longitude: 5.0219047),
              carrier: 'IFS',
              trailerType: 'JOHN',
              estStartDate: '15/03/2025 12:32',
              estDeliveryDate: '17/03/2025 11:29',
              vehicleInfo: VehicleInfo(speed: 0,odometerValue: 003241,ignition: false,containerTemp: 27,engineTemp: 32,containerWeight: 1200,fuel: 0.8)),
        ],
        overlayWidget: const SizedBox()
        );
  }

  TripsState copyWith(
      {List<Trip>? trips,
      TripsStatus? getTripsStatus,
      Trip? selectedTrip,
      List<LatLng>? routeCoords,
      List<LatLng>? coveredPath,
      Set<Polyline>? polylines,
      GeoLocationStatus? geoLocationStatus,
      Set<Marker>? markers,
      List<LatLng>? waypoints,
      LatLng? coveredEnd,
      List<LatLng>? locations,
      bool? isDriverAnimated,
      ScreenCoordinate? markerScreenPosition,
      LatLng? activeMarkerPosition,
      bool? displayTruckOverlay,
      ScreenCoordinate? screenPosition,
      Widget? overlayWidget,
      ScreenCoordinate? truckPosition,
        double? currentAngle,
  double? targetAngle,

      }) {
    return TripsState(
        trips: trips ?? this.trips,
        getTripsStatus: getTripsStatus ?? this.getTripsStatus,
        selectedTrip: selectedTrip ?? this.selectedTrip,
        routeCoords: routeCoords ?? this.routeCoords,
        coveredPath: coveredPath ?? this.coveredPath,
        polylines: polylines ?? this.polylines,
        geoLocationStatus: geoLocationStatus ?? this.geoLocationStatus,
        markers: markers ?? this.markers,
        waypoints: waypoints ?? this.waypoints,
        coveredEnd: coveredEnd ?? this.coveredEnd,
        locations: locations ?? this.locations,
        isDriverAnimated: isDriverAnimated ?? this.isDriverAnimated,
        markerScreenPosition: markerScreenPosition ?? this.markerScreenPosition,
        activeMarkerPosition: activeMarkerPosition ?? this.activeMarkerPosition,
        displayTruckOverlay: displayTruckOverlay ?? this.displayTruckOverlay,
        mapController: mapController,
        screenPosition: screenPosition,
        overlayWidget: overlayWidget ?? this.overlayWidget,
        truckPosition: truckPosition,
        currentAngle: currentAngle ?? this.currentAngle,
        targetAngle: targetAngle ?? this.targetAngle

        );
  }
}

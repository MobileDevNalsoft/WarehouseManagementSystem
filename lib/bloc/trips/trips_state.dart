part of 'trips_bloc.dart';

enum TripsStatus { initial, loading, success, failure }

class TripsState {
  List<Trip>? trips;
  final TripsStatus? getTripsStatus;

  TripsState({this.trips, this.getTripsStatus});

  factory TripsState.initial() {
    return TripsState(getTripsStatus: TripsStatus.initial, trips: [
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
          estEndDate: '3/4/2025 7:00'),
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
          estEndDate: '3/4/2025 7:00'),
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
          estEndDate: '3/3/2025 7:00'),
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
          estEndDate: '3/5/2025 7:00'),
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
          estEndDate: '3/1/2025 7:00'),
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
          estEndDate: '3/5/2025 7:00')
    ]);
  }

  TripsState copyWith({List<Trip>? trips, TripsStatus? getTripsStatus}) {
    return TripsState(trips: trips ?? this.trips, getTripsStatus: getTripsStatus ?? getTripsStatus);
  }
}

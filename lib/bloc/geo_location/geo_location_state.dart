part of 'geo_location_bloc.dart';

enum GeoLocationStatus { initial, loading, success, failure }

final class GeoLocationState {
  final List<LatLng> locations;
  final List<LatLng> routeCoords;
  final List<LatLng> coveredPath;
  final Set<Polyline> polylines;
  GeoLocationStatus geoLocationStatus;
  GoogleMapController? mapController;
  Set<Marker> markers;
  List<LatLng> waypoints;
  LatLng? coveredEnd;

  factory GeoLocationState.initial() {
    return GeoLocationState(
        routeCoords: [],
        coveredPath: [],
        polylines: {},
        geoLocationStatus: GeoLocationStatus.initial,
        markers:{},
        waypoints: [],
        locations: [
          LatLng(17.448425943266503, 78.38358840381744),
          LatLng(17.402004307947013, 78.51117509518066),
        ], coveredEnd: LatLng(17.44461554024197, 78.3773073977873));
  }

  GeoLocationState(
      {required this.routeCoords,
      required this.coveredPath,
      required this.polylines,
      required this.geoLocationStatus,
      required this.markers,
      required this.waypoints,
      required this.locations,
      required this.coveredEnd});

  GeoLocationState copyWith({
    List<LatLng>? routeCoords,
    List<LatLng>? coveredPath,
    Set<Polyline>? polylines,
    GeoLocationStatus? geoLocationStatus,
    Set<Marker>? markers,
    List<LatLng>? waypoints,
    LatLng? coveredEnd,
    List<LatLng>? locations,
  }) {
    return GeoLocationState(
      routeCoords: routeCoords ?? this.routeCoords,
      coveredPath: coveredPath ?? this.coveredPath,
      polylines: polylines ?? this.polylines,
      geoLocationStatus: geoLocationStatus ?? this.geoLocationStatus,
      markers: markers ?? this.markers,
      waypoints: waypoints ?? this.waypoints,
      coveredEnd: coveredEnd ?? this.coveredEnd,
      locations: locations??this.locations,
    );
  }
}

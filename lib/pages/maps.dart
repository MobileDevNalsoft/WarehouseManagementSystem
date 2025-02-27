import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wmssimulator/bloc/geo_location/geo_location_bloc.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with TickerProviderStateMixin {

  
  final _mapMarkerSC = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;


  @override
  void initState() {
    super.initState();
    context.read<GeoLocationBloc>().add(LoadRoute(
      start: LatLng(17.448425943266503, 78.38358840381744),
      end: LatLng(17.402004307947013, 78.51117509518066),
      waypoints: [LatLng(17.423212593142306, 78.50968358744188)],
    ));
  }

// Function to calculate bounds dynamically
LatLngBounds _calculateBounds(List<LatLng> locations) {
  double minLat = locations.map((l) => l.latitude).reduce((a, b) => a < b ? a : b);
  double maxLat = locations.map((l) => l.latitude).reduce((a, b) => a > b ? a : b);
  double minLng = locations.map((l) => l.longitude).reduce((a, b) => a < b ? a : b);
  double maxLng = locations.map((l) => l.longitude).reduce((a, b) => a > b ? a : b);

  return LatLngBounds(
    southwest: LatLng(minLat, minLng),
    northeast: LatLng(maxLat, maxLng),
  );
}
 StreamBuilder<List<Marker>> googleMap() {
      return StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: context.read<GeoLocationBloc>().state.locations[0], zoom: 17),
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              context.read<GeoLocationBloc>().state.mapController = controller;
              Future.delayed(Duration(seconds: 2), () =>
              context.read<GeoLocationBloc>().add(AnimateDriver( mapMarkerSink: _mapMarkerSink, provider: this)));
            },
            markers: context.read<GeoLocationBloc>().state.markers.toSet(),
            polylines: context.read<GeoLocationBloc>().state.polylines,
            padding: EdgeInsets.all(8),
          );
        },
      );
    }
 

  @override
  Widget build(BuildContext context) {
    // googleMap();
    return Scaffold(
      body: BlocBuilder<GeoLocationBloc, GeoLocationState>(builder: (context, state) {
        return state.geoLocationStatus==GeoLocationStatus.success? 
        googleMap()
        : Center(child: CircularProgressIndicator());
      }),
    );
  }
}

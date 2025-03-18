import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:gap/gap.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:wmssimulator/constants/app_constants.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/local_network_calls.dart';
import 'package:wmssimulator/logger/logger.dart';
import 'package:wmssimulator/models/task_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_routes/google_maps_routes.dart' as gmr;
// import 'package:maps_toolkit/maps_toolkit.dart' as mtk;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wmssimulator/models/trip_model.dart';

import '../../models/area_response.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  TripsBloc({required NetworkCalls customApi})
      : _customApi = customApi,
        super(TripsState.initial()) {
    on<GetTrips>(_onGetTrips);
    on<LoadRoute>(_onLoadRoute);
    on<SetMarkers>(_setMarkers);
    on<AnimateDriver>(_animateDriver);
    on<ShowOverlay>(_onShowOverlay);
    on<HideOverlay>(_onHideOverlay);
    // on<UpdateActiveMarkerPosition>(_onUpdateActiveMarkerPosition);
  }

  final NetworkCalls _customApi;
  List<String> truckImages = [
    "assets/images/truck_0.png",
    "assets/images/truck_45.png",
    "assets/images/truck_90.png",
    "assets/images/truck_135.png",
    "assets/images/truck_180.png",
    "assets/images/truck_225.png",
    "assets/images/truck_270.png",
    "assets/images/truck_315.png",
    "assets/images/truck_360.png"
  ];

// // Get the closest image based on the rotation angle
// String getTruckImage(double angle) {
//   List<int> angles = [0, 45, 90, 135, 180, 225, 270, 315, 360];
//   int closestAngle = angles.reduce((a, b) => (angle - a).abs() < (angle - b).abs() ? a : b);
//   return "assets/images/truck_$closestAngle.png";
// }
// Future<BitmapDescriptor> getMarkerIcon(double angle) async {
//   String imagePath = getTruckImage(angle);
//   final ByteData data = await rootBundle.load(imagePath);
//   final Uint8List bytes = data.buffer.asUint8List();
//   return BitmapDescriptor.fromBytes(bytes);
// }

  Future<void> _onGetTrips(GetTrips event, Emitter<TripsState> emit) async {
    try {
      emit(state.copyWith(getTripsStatus: TripsStatus.loading));
      Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(getTripsStatus: TripsStatus.success));
    } catch (e) {
      Log.e(e.toString());
      emit(state.copyWith(getTripsStatus: TripsStatus.failure));
    }
  }

  Future<void> _onLoadRoute(LoadRoute event, Emitter<TripsState> emit) async {
    try {
      state.locations = [event.start, ...event.waypoints ?? [], event.end];
      final routeCoords = await _getRoute(event.start, event.end, event.waypoints ?? state.waypoints);
      state.routeCoords = routeCoords;
      LatLng end;
      List<LatLng> coveredPath = [];

      if (state.isDriverAnimated == true) {
        if (state.coveredEnd == null) {
          if (state.selectedTrip!.status!.toLowerCase() == 'delivered') {
            state.coveredEnd = state.routeCoords.last;
            end = state.coveredEnd!;
          } else {
            end = pickRandomLocations(state.routeCoords, 1).first;
          }
        } else {
          end = state.coveredEnd!;
        }
        coveredPath = _extractCoveredPath(routeCoords, end);
        state.coveredEnd = end;
      }

      Set<Polyline> polylines = {
        Polyline(
          polylineId: PolylineId("full_path"),
          points: routeCoords,
          color: const ui.Color.fromRGBO(33, 150, 243, 0.8),
          width: 8,
        ),
        if (state.isDriverAnimated == true)
          Polyline(
            polylineId: PolylineId("covered_path"),
            points: coveredPath,
            color: const ui.Color.fromRGBO(76, 175, 79, 0.8),
            width: 8,
            patterns: [PatternItem.dash(10), PatternItem.gap(20)],
          ),
      };
      add(SetMarkers(context: event.context));
      emit(state.copyWith(routeCoords: routeCoords, polylines: polylines, geoLocationStatus: GeoLocationStatus.success));
    } catch (e) {
      print("error $e");
      emit(state.copyWith(geoLocationStatus: GeoLocationStatus.failure));
    }
  }

  Future<void> _setMarkers(SetMarkers event, Emitter<TripsState> emit) async {
    // BitmapDescriptor customIcon = await _getCustomIcon();
    List<LatLng> checkpoints;
    if (state.selectedTrip!.waypoints != null && state.selectedTrip!.waypoints!.isNotEmpty) {
      checkpoints = state.selectedTrip!.waypoints!.map((e) => LatLng(e.latitude!, e.longitude!)).toList();
    } else {
      checkpoints = pickRandomLocations(state.routeCoords, 2);
    }
    state.markers.clear();
    state.markers.addAll([
      if (state.isDriverAnimated == false)
        Marker(
          markerId: MarkerId("driverMarker"),
          icon: await _getCustomIcon(0.0),
          position: state.routeCoords.first,
          onTap: () {
            state.displayTruckOverlay=false;
             add(ShowOverlay(
            activeMarkerPosition: state.routeCoords.first,
            context: event.context,
            overlayWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${state.selectedTrip!.startLoc!.location}", style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: const ui.Color.fromARGB(231, 255, 255, 255)),
                    Text("${state.selectedTrip!.startLoc!.latitude}, ${state.selectedTrip!.startLoc!.longitude}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
                  ],
                ),
              ],
            ),
          ));
          },
          // infoWindow:
          //     InfoWindow(title: "${state.selectedTrip!.startLoc!.location}", snippet: "📍 ${state.selectedTrip!.startLoc!.latitude}, ${state.selectedTrip!.startLoc!.longitude}"),
        ),
      Marker(
        markerId: MarkerId("start"),
        icon: await BitmapDescriptor.asset(ImageConfiguration(), "assets/images/start.png"),
        position: state.routeCoords.first,
        // infoWindow:            InfoWindow(title: "${state.selectedTrip!.startLoc!.location}", snippet: "📍 ${state.selectedTrip!.startLoc!.latitude}, ${state.selectedTrip!.startLoc!.longitude}"),
        onTap: () {
          state.displayTruckOverlay=false;
          add(ShowOverlay(
            activeMarkerPosition: state.routeCoords.first,
            context: event.context,
            overlayWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${state.selectedTrip!.startLoc!.location}", style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: const ui.Color.fromARGB(231, 255, 255, 255)),
                    Text("${state.selectedTrip!.startLoc!.latitude}, ${state.selectedTrip!.startLoc!.longitude}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
                  ],
                ),
              ],
            ),
          ));
        },
      ),
      // Generate unique marker IDs for each waypoint
      if (state.selectedTrip!.waypoints != null && state.selectedTrip!.waypoints!.isNotEmpty)
        ...state.selectedTrip!.waypoints!.map(
          (e) => Marker(
            markerId: MarkerId("waypoint_${state.selectedTrip!.waypoints!.indexOf(e)}"), // Unique ID for each waypoint
            position: LatLng(e.latitude!, e.longitude!),
            // infoWindow: InfoWindow(title: " ${e.location}", snippet: "📍 ${e.latitude}, ${e.longitude}"),
            onTap: () {
              state.displayTruckOverlay=false;
              add(ShowOverlay(
                activeMarkerPosition: LatLng(e.latitude!, e.longitude!),
                context: event.context,
                overlayWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${e.location}", style: TextStyle(color: Colors.white)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,color: const ui.Color.fromARGB(231, 255, 255, 255)),
                        Text("${e.latitude},${e.longitude}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
                      ],
                    ),
                  ],
                ),
              ));
            },
          ),
        ),
      Marker(
        markerId: MarkerId("end"),
        icon: await BitmapDescriptor.asset(ImageConfiguration(size: Size(42, 42)), "assets/images/end.png"),
        position: state.routeCoords.last,
        // infoWindow: InfoWindow(title: "${state.selectedTrip!.endLoc!.location}", snippet: "📍 ${state.selectedTrip!.endLoc!.latitude}, ${state.selectedTrip!.endLoc!.longitude}"),
        onTap: () {
          state.displayTruckOverlay=false;
          add(ShowOverlay(
            activeMarkerPosition: state.routeCoords.last,
            context: event.context,
            overlayWidget: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${state.selectedTrip!.endLoc!.location}", style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,color: const ui.Color.fromARGB(231, 255, 255, 255)),
                    Text("${state.selectedTrip!.endLoc!.latitude}, ${state.selectedTrip!.endLoc!.longitude}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
                  ],
                ),
              ],
            ),
          ));
        },
      ),
    ]);
    emit(state.copyWith(markers: state.markers));
  }

  List<LatLng> _extractCoveredPath(List<LatLng> fullRoute, LatLng coveredEnd) {
    try {
      List<LatLng> coveredPath = [];
      LatLng nearestPoint = _findNearestPoint(fullRoute, coveredEnd);

      for (LatLng point in fullRoute) {
        coveredPath.add(point);
        if (point == nearestPoint) break; // Stop at the closest point
      }
      return coveredPath;
    } catch (e) {
      print("error $e");
      return [];
    }
  }

  List<LatLng> pickRandomLocations(List<LatLng> items, int count) {
    final List<LatLng> list = List.from(items); // cloning original list
    list.shuffle(); // shuffling items

    return list.take(count).toList(); // taking N items
  }

  /// Loads an image from assets and returns a ui.Image
  Future<ui.Image> _loadImage(Uint8List imgBytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imgBytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  /// Rotates an image correctly without misalignment
  Future<Uint8List> _rotateImage(ui.Image src, double angle) async {
    final double radian = angle * pi / 180;

    final int width = src.width;
    final int height = src.height;
    final double diagonal = sqrt(width * width + height * height);

    final int newSize = diagonal.ceil(); // Expand canvas to avoid cutting

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Move pivot to center
    canvas.translate(newSize / 2, newSize / 2);
    canvas.rotate(radian);
    canvas.translate(-width / 2, -height / 2);

    final Paint paint = Paint();
    canvas.drawImage(src, Offset.zero, paint);

    final ui.Image rotatedImage = await recorder.endRecording().toImage(newSize, newSize);
    final ByteData? rotatedBytes = await rotatedImage.toByteData(format: ui.ImageByteFormat.png);

    return rotatedBytes!.buffer.asUint8List();
  }
// Future<Uint8List> _rotateImage(ui.Image src, double angle) async {
//   final double radian = angle * pi / 180 ;
//   final int width = src.width;
//   final int height = src.height;

//   final double diagonal = sqrt(width * width + height * height);
//   final int newSize = diagonal.ceil(); // Expand canvas to fit the rotated image

//   final ui.PictureRecorder recorder = ui.PictureRecorder();
//   final Canvas canvas = Canvas(recorder);

//   // **Move to the center of the new expanded canvas**
//   canvas.translate(newSize / 2, newSize / 2);

//   // **Rotate the canvas**
//   canvas.rotate(radian);

//   // **Move back by half of the original width and height to center the image**
//   canvas.drawImage(src, Offset(-width / 2, -height / 2), Paint());

//   // Convert canvas to image
//   final ui.Image rotatedImage = await recorder.endRecording().toImage(newSize, newSize);
//   final ByteData? rotatedBytes = await rotatedImage.toByteData(format: ui.ImageByteFormat.png);

//   return rotatedBytes!.buffer.asUint8List();
// }

  /// Generates a correctly rotated BitmapDescriptor
  Future<BitmapDescriptor> _getCustomIcon(double? rotation) async {
    final ByteData data = await rootBundle.load('images/map_truck3.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final Uint8List rotatedBytes;
    if (rotation != null) {
      final ui.Image originalImage = await _loadImage(bytes);
      rotatedBytes = await _rotateImage(originalImage, rotation);
    } else {
      rotatedBytes = bytes;
    }
    return BitmapDescriptor.bytes(rotatedBytes);
  }

  LatLng _findNearestPoint(List<LatLng> fullRoute, LatLng coveredEnd) {
    LatLng nearestPoint = fullRoute[0];
    double minDistance = double.infinity;

    for (LatLng point in fullRoute) {
      double distance = _calculateDistance2(point, coveredEnd);
      if (distance < minDistance) {
        minDistance = distance;
        nearestPoint = point;
      }
    }
    return nearestPoint;
  }

  Future<List<LatLng>> _getRoute(LatLng startLocation, LatLng endLocation, List<LatLng> waypoints) async {
    String combinedWayPoints = waypoints.map((point) => "${point.latitude.toStringAsFixed(6)},${point.longitude.toStringAsFixed(6)}").join("|");
    String origin = "${startLocation.latitude.toStringAsFixed(6)},${startLocation.longitude.toStringAsFixed(6)}";
    String destination = "${endLocation.latitude.toStringAsFixed(6)},${endLocation.longitude.toStringAsFixed(6)}";

    final String url = "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=$origin&"
        "destination=$destination&"
        "waypoints=$combinedWayPoints&"
        "mode=driving&"
        "optimizeWaypoints=true&"
        "key=${AppConstants.GOOGLE_MAPS_API_KEY}";
    try {
      Response response = await Dio().get(url);

      if (response.statusCode == 200) {
        final jsonData = response.data;

        if (jsonData["routes"].isNotEmpty) {
          final String encodedPolyline = jsonData["routes"][0]["overview_polyline"]["points"];

          // Decode the polyline using your _decodePolyline function (or the polyline_points package if you prefer)
          List<PointLatLng> decodedPolyline = PolylinePoints().decodePolyline(encodedPolyline); // Use latlong2 LatLng

          // Convert latlong2 LatLng to Google Maps LatLng
          List<LatLng> googleMapsPolyline = decodedPolyline.map((e) => LatLng(e.latitude, e.longitude)).toList();
          return googleMapsPolyline;
        }
      }
      return [];
    } catch (e) {
      print("error $e");
      return [];
    }
  }

  void _animateDriver(AnimateDriver event, Emitter<TripsState> emit) async {
    if (state.isDriverAnimated == false || state.routeCoords.isEmpty) return;

    LatLng startPosition = LatLng(
      state.selectedTrip!.startLoc!.latitude!,
      state.selectedTrip!.startLoc!.longitude!,
    );
    LatLng closestToStart = _getClosestPoint(startPosition, state.routeCoords);
    List<LatLng> routeSegment = _getRouteSegment(state.routeCoords, closestToStart, state.coveredEnd!);
    if (routeSegment.isEmpty) return;

    // state.mapController!.animateCamera(
    //   CameraUpdate.newCameraPosition(CameraPosition(target: startPosition, zoom: 17.0)),
    // );
// double bearing = _calculateBearing(start, end); // Calculate bearing
    BitmapDescriptor icon = await _getCustomIcon(null); // Default orientation
    const double speedKmh = 1000; // Speed in km/h
    const double speedMps = (speedKmh * 1000) / 3600; // Convert to meters per second

    for (int i = 0; i < routeSegment.length - 1; i++) {
      LatLng start = routeSegment[i];
      LatLng end = routeSegment[i + 1];

      double segmentDistance = _calculateDistance2(start, end); // Meters
      double travelTime = segmentDistance / speedMps; // Seconds
      int steps = (travelTime * 30).toInt(); // 30 FPS
      steps = steps < 1 ? 1 : steps; // Prevent zero steps

      for (int j = 0; j <= steps; j++) {
        double fraction = j / steps;
        double lat = _lerp(start.latitude, end.latitude, fraction);
        double lng = _lerp(start.longitude, end.longitude, fraction);
        LatLng newPos = LatLng(lat, lng); // Snap to polyline

        // double bearing = _calculateBearing(start, newPos); // Update rotation continuously

        state.markers.removeWhere((marker) => marker.markerId.value == "driverMarker");
        var carMarker = Marker(
          markerId: const MarkerId("driverMarker"),
          position: newPos,

          icon: icon,

          anchor: const Offset(0.5, 0.5), // Center truck marker correctly
          draggable: false,
          flat: true,
          onTap: () {
            add(ShowOverlay(
              activeMarkerPosition: LatLng(lat, lng),
              context: event.context,
              overlayWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: event.context.size!.width*0.16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [
                        Text("${state.selectedTrip!.shipmentNbr}", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/shipment.png",
                        height: 24,
                        width: 24,
                        color: const ui.Color.fromARGB(231, 255, 255, 255),
                      ),
                        Gap(4),
                      Text("${state.selectedTrip!.vehicleNbr}", style: TextStyle(color: Colors.white)),
                    
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_rounded, color: const ui.Color.fromARGB(231, 255, 255, 255)),
                      Gap(4),
                      Text("${state.coveredEnd!.latitude}, ${state.coveredEnd!.latitude}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person_2_rounded, color: Colors.white),
                        Gap(4),
                      Text("${state.selectedTrip!.driver}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
                    ],
                  )
             ],
              ),
            ));
state.displayTruckOverlay=true;
          },
        );
        // carMarker.copyWith(rotationParam: bearing);
        state.markers.add(carMarker);
        if (event.mapMarkerSC.isClosed) break;
        event.mapMarkerSC.sink.add(state.markers.toList());
          if(state.displayTruckOverlay==true){
        final screenPosition =
              await state.mapController!.getScreenCoordinate(newPos);
          state.markerScreenPosition = screenPosition;
          emit(state.copyWith(screenPosition: screenPosition));}
        // emit(state.copyWith(displayTruckOverlay: true));
        await Future.delayed(const Duration(milliseconds: 33)); // 30 FPS
      }
    }
  }

//rotation
  // void _animateDriver(AnimateDriver event, Emitter<TripsState> emit) async {
  //   if (state.isDriverAnimated == false || state.routeCoords.isEmpty) return;

  //   LatLng startPosition = LatLng(state.selectedTrip!.startLoc!.latitude!, state.selectedTrip!.startLoc!.longitude!);
  //   LatLng closestToStart = _getClosestPoint(startPosition, state.routeCoords);

  //   List<LatLng> routeSegment = _getRouteSegment(state.routeCoords, closestToStart, state.coveredEnd!);
  //   // if (routeSegment.isEmpty) return;
  //   // state.mapController!.animateCamera(
  //   //   CameraUpdate.newCameraPosition(
  //   //     CameraPosition(
  //   //       target: startPosition,
  //   //       zoom: 17.0, // Adjust zoom level as needed
  //   //     ),
  //   //   ),
  //   // );

  //   const double speedKmh = 40; // Set speed (50 km/h)
  //   const double speedMps = (speedKmh * 1000) / 3600; // Convert to meters per second

  //   for (int i = 0; i < routeSegment.length - 1; i++) {
  //     LatLng start = routeSegment[i];
  //     LatLng end = routeSegment[i + 1];

  //     double segmentDistance = _calculateDistance2(start, end); // Distance in meters
  //     double travelTime = segmentDistance / speedMps; // Time required to move at speedKmh
  //     int steps = (travelTime * 30).toInt(); // 30 FPS for smooth animation
  //     steps = steps < 1 ? 1 : steps; // Prevent division by zero

  //     double bearing = _calculateBearing(start, end); // Calculate bearing

  //     BitmapDescriptor icon = await _getCustomIcon(bearing); // Rotate PNG

  //     var carMarker = Marker(
  //       markerId: const MarkerId("driverMarker"),
  //       position: start,
  //       icon: icon,
  //       anchor: Offset(0.5, 0.5),
  //       rotation: bearing,
  //       infoWindow: InfoWindow(
  //         anchor: Offset(0.5, 0.5),
  //         title: "🚛 Truck Info",
  //         snippet:
  //             "📍 ${state.coveredEnd!.latitude}, ${state.coveredEnd!.longitude}\n\n <br/>${state.selectedTrip!.status!.toLowerCase() == 'delivered' ? "⚡ Speed: ${60} km/h" : ""} <br/>",
  //       ),
  //       onTap: () {
  //         state.mapController!.animateCamera(
  //           CameraUpdate.newCameraPosition(
  //             CameraPosition(
  //               target: start,
  //               zoom: 15.0, // Adjust zoom level as needed
  //             ),
  //           ),
  //         );

  //       },
  //       draggable: false,
  //       flat: true,
  //       // rotation: _calculateBearing(start, end),
  //     );
  //     state.markers.add(carMarker);
  //     if (event.mapMarkerSC.isClosed) {
  //       break;
  //     }
  //     event.mapMarkerSC.sink.add(state.markers.toList());

  //     for (int j = 0; j <= 10; j++) {
  //       double lat = _lerp(start.latitude, end.latitude, j / 10);
  //       double lng = _lerp(start.longitude, end.longitude, j / 10);
  //       LatLng newPos = LatLng(lat, lng);

  //       state.markers.removeWhere((marker) => marker.markerId.value == "driverMarker");
  //       carMarker = carMarker.copyWith(positionParam: newPos, rotationParam: _calculateBearing(start, end));
  //       state.markers.add(carMarker);
  //       if (event.mapMarkerSC.isClosed) {
  //         break;
  //       }
  //       event.mapMarkerSC.sink.add(state.markers.toList());

  //       await Future.delayed(const Duration(milliseconds: 90));
  //     }
  //   }
  // }

// void _animateDriver(AnimateDriver event, Emitter<TripsState> emit) async {
//   if (state.isDriverAnimated == false || state.routeCoords.isEmpty || state.mapController == null) return;

//   LatLng startPosition = LatLng(state.selectedTrip!.startLoc!.latitude!, state.selectedTrip!.startLoc!.longitude!);
//   LatLng closestToStart = _getClosestPoint(startPosition, state.routeCoords);
//   List<LatLng> routeSegment = _getRouteSegment(state.routeCoords, closestToStart, state.coveredEnd!);

//   const double speedKmh = 40;
//   const double speedMps = (speedKmh * 1000) / 3600;

//   for (int i = 0; i < routeSegment.length - 1; i++) {
//     LatLng start = routeSegment[i];
//     LatLng end = routeSegment[i + 1];

//     double segmentDistance = _calculateDistance2(start, end);
//     double travelTime = segmentDistance / speedMps;
//     int steps = (travelTime * 30).toInt();
//     steps = steps < 1 ? 1 : steps;

//     double bearing = _calculateBearing(start, end);

//     BitmapDescriptor icon = await _getCustomIcon(bearing);

//     ScreenCoordinate screenPosition = await state.mapController!.getScreenCoordinate(start);

//     for (int j = 0; j <= 10; j++) {
//       // Lerp the position for smooth movement
//       double lat = _lerp(start.latitude, end.latitude, j / 10);
//       double lng = _lerp(start.longitude, end.longitude, j / 10);
//       LatLng newPos = LatLng(lat, lng);

//       // Convert LatLng to ScreenCoordinate
//       ScreenCoordinate newScreenPosition = await state.mapController!.getScreenCoordinate(newPos);

//       // Modify ScreenCoordinate for manual movement (Adjust X, Y for offset if needed)
//       newScreenPosition = ScreenCoordinate(
//         x: newScreenPosition.x,
//         y: newScreenPosition.y
//       );

//       // Convert back to LatLng
//       LatLng adjustedLatLng = await state.mapController!.getLatLng(newScreenPosition);

//       // Update marker manually
//       state.markers.removeWhere((marker) => marker.markerId.value == "driverMarker");
//       Marker carMarker = Marker(
//         markerId: const MarkerId("driverMarker"),
//         position: adjustedLatLng,
//         icon: icon,
//         anchor: Offset(0.5, 0.5),
//         rotation: bearing,
//         flat: true,
//       );
//       state.markers.add(carMarker);

//       if (event.mapMarkerSC.isClosed) break;
//       event.mapMarkerSC.sink.add(state.markers.toList());

//       await Future.delayed(const Duration(milliseconds: 90));
//     }
//   }
// }

  double _lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (pi / 180);
    double lon1 = start.longitude * (pi / 180);
    double lat2 = end.latitude * (pi / 180);
    double lon2 = end.longitude * (pi / 180);

    double deltaLon = lon2 - lon1;

    double y = sin(deltaLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon);

    double initialBearing = atan2(y, x);
    double bearing = (initialBearing * (180 / pi) + 360) % 360;

    return bearing;
  }

  double _calculateDistance2(LatLng pos1, LatLng pos2) {
    const double R = 6371000; // Earth's radius in meters
    double lat1 = pos1.latitude * (pi / 180);
    double lon1 = pos1.longitude * (pi / 180);
    double lat2 = pos2.latitude * (pi / 180);
    double lon2 = pos2.longitude * (pi / 180);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  List<LatLng> _getRouteSegment(List<LatLng> routeCoords, LatLng start, LatLng end) {
    int startIndex = routeCoords.indexOf(start);
    if (startIndex == -1) return [];

    List<LatLng> segment = [];
    for (int i = startIndex; i < routeCoords.length; i++) {
      segment.add(routeCoords[i]);

      // Stop if we reach or exceed the coveredEnd position
      if (_calculateDistance2(routeCoords[i], end) < 5) break;
    }

    return segment;
  }

  LatLng _getClosestPoint(LatLng target, List<LatLng> routeCoords) {
    LatLng closestPoint = routeCoords.first;
    double minDistance = double.infinity;

    for (LatLng point in routeCoords) {
      double distance = _calculateDistance2(target, point);
      if (distance < minDistance) {
        minDistance = distance;
        closestPoint = point;
      }
    }

    return closestPoint;
  }

  void _onShowOverlay(ShowOverlay event, Emitter<TripsState> emit) async {
    try {
      ScreenCoordinate screenPosition = await state.mapController!.getScreenCoordinate(event.activeMarkerPosition);
      emit(state.copyWith(activeMarkerPosition: event.activeMarkerPosition, screenPosition: screenPosition, overlayWidget: event.overlayWidget));
    } catch (e) {
      print("Error updating overlay: $e");
    }
  }

  void _onHideOverlay(HideOverlay event, Emitter<TripsState> emit) {
    try {
      print("inside hide overlay");
      emit(state.copyWith(screenPosition: null));
      print(state.screenPosition);
    } catch (e) {
      print("error from hide $e");
    }
  }

  // void _onShowTruckAnimation(ShowTruckAnimation event, Emitter<TripsState> emit) {
  //   try {

  //     emit(state.copyWith(isDriverAnimated: true));
  //   } catch (e) {
  //     print("error from hide $e");
  //   }
  // }

  // void _onUpdateActiveMarkerPosition(UpdateActiveMarkerPosition event, Emitter<TripsState> emit) async {
  //   if (state.activeMarkerPosition == event.activeMarkerPosition) return;
  //   if (state.activeMarkerPosition == null || state.overlayEntry == null) return;

  //   ScreenCoordinate screenPosition =
  //       await state.mapController!.getScreenCoordinate(state.activeMarkerPosition!);

  //   // Remove old overlay
  //   state.overlayEntry!.remove();

  //   OverlayEntry newOverlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       left: screenPosition.x.toDouble(),
  //       top: screenPosition.y.toDouble(),
  //       child: _buildOverlay(state.activeMarkerPosition!),
  //     ),
  //   );

  //   Overlay.of(event.context).insert(newOverlayEntry);

  //   emit(state.copyWith(
  //     overlayEntry: newOverlayEntry,
  //     markerScreenPosition: screenPosition,
  //   ));
  // }

  // Widget _buildOverlay(LatLng position) {
  //   return GestureDetector(
  //     onTap: () => add(HideOverlay()),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: Container(
  //         padding: EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: Colors.black.withOpacity(0.8),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text("📍 Info", style: TextStyle(color: Colors.white)),
  //             SizedBox(height: 5),
  //             Text("Lat: ${position.latitude}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
  //             Text("Lng: ${position.longitude}", style: TextStyle(color: const ui.Color.fromARGB(231, 255, 255, 255))),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

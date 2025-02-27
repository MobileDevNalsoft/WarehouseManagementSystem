import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wmssimulator/constants/app_constants.dart';

part 'geo_location_event.dart';
part 'geo_location_state.dart';

class GeoLocationBloc extends Bloc<GeoLocationEvent, GeoLocationState> {
  GeoLocationBloc() : super(GeoLocationState.initial()) {
    on<LoadRoute>(_onLoadRoute);
    on<SetMarkers>(_setMarkers);
    on<AnimateDriver>(_animateDriver);
  }

  Animation<double>? _animation;
  Future<void> _onLoadRoute(LoadRoute event, Emitter<GeoLocationState> emit) async {
    try {
      final routeCoords = await _getRoute(event.start, event.end, event.waypoints);
      LatLng end;
      if (state.coveredEnd != null) {
        end = state.coveredEnd!;
      } else {
        end = pickRandomLocations(state.routeCoords, 1)[0];
      }
      state.coveredEnd = end;
      final coveredPath = _extractCoveredPath(routeCoords, end);

      Set<Polyline> polylines = {
        Polyline(
          polylineId: PolylineId("full_path"),
          points: routeCoords,
          color: Colors.blue,
          width: 5,
        ),
        Polyline(
          polylineId: PolylineId("covered_path"),
          points: coveredPath,
          color: Colors.green,
          width: 5,
          patterns: [PatternItem.dash(10), PatternItem.gap(20)],
        ),
      };
      add(SetMarkers());
      emit(state.copyWith(routeCoords: routeCoords, polylines: polylines, geoLocationStatus: GeoLocationStatus.success));
    } catch (e) {
      emit(state.copyWith(geoLocationStatus: GeoLocationStatus.failure));
    }
  }

  Future<void> _setMarkers(SetMarkers event, Emitter<GeoLocationState> emit) async {
    // BitmapDescriptor customIcon = await _getCustomIcon();
    List<LatLng> checkpoints;
    if (state.waypoints.isNotEmpty) {
      checkpoints = state.waypoints;
    } else {
      checkpoints = pickRandomLocations(state.routeCoords, 2);
      state.waypoints = checkpoints;
    }
    state.markers.addAll([
      Marker(
        markerId: MarkerId("start"),
        position: state.routeCoords.first,
        infoWindow: InfoWindow(title: "Nalsoft"),
      ),
      // Generate unique marker IDs for each waypoint

      ...checkpoints.asMap().entries.map(
            (entry) => Marker(
              markerId: MarkerId("waypoint_${entry.key}"), // Unique ID for each waypoint
              position: entry.value,
              infoWindow: InfoWindow(title: "Checkpoint ${entry.key + 1}"),
            ),
          ),
      Marker(
        markerId: MarkerId("end"),
        position: state.routeCoords.last,
        infoWindow: InfoWindow(title: "Final Point"),
      ),
    ]);
    emit(state.copyWith(markers: state.markers));
  }

  List<LatLng> _extractCoveredPath(List<LatLng> fullRoute, LatLng coveredEnd) {
    List<LatLng> coveredPath = [];
    LatLng nearestPoint = _findNearestPoint(fullRoute, coveredEnd);

    for (LatLng point in fullRoute) {
      coveredPath.add(point);
      if (point == nearestPoint) break; // Stop at the closest point
    }
    return coveredPath;
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

  /// Generates a correctly rotated BitmapDescriptor
  Future<BitmapDescriptor> _getCustomIcon(double rotation) async {
    final ByteData data = await rootBundle.load('images/map_truck.png');
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Image originalImage = await _loadImage(bytes);
    final Uint8List rotatedBytes = await _rotateImage(originalImage, rotation);

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

  void _animateDriver(AnimateDriver event, Emitter<GeoLocationState> emit) async {
    if (state.routeCoords.isEmpty) return;

    LatLng startPosition = LatLng(state.locations[0].latitude, state.locations[0].longitude);
    LatLng closestToStart = _getClosestPoint(startPosition, state.routeCoords);

    List<LatLng> routeSegment = _getRouteSegment(state.routeCoords, closestToStart, state.coveredEnd!);
    if (routeSegment.isEmpty) return;
    state.mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: startPosition,
          zoom: 17.0, // Adjust zoom level as needed
        ),
      ),
    );

    for (int i = 0; i < routeSegment.length - 1; i++) {
      LatLng start = routeSegment[i];
      LatLng end = routeSegment[i + 1];

      double bearing = _calculateBearing(start, end); // Calculate bearing

      BitmapDescriptor icon = await _getCustomIcon(bearing); // Rotate PNG

      var carMarker = Marker(
        markerId: const MarkerId("driverMarker"),
        position: start,
        icon: icon,
        anchor: Offset(-10.5, -2.5),

        infoWindow: InfoWindow(
          title: "🚛 Truck Info",
          snippet: "📍 ${state.coveredEnd!.latitude}, ${state.coveredEnd!.longitude}\n\n <br/>⚡ Speed: ${60} km/h <br/>",
        ),
        onTap: () {
          state.mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: start,
                zoom: 17.0, // Adjust zoom level as needed
              ),
            ),
          );
        },
        draggable: false,
        flat: true,
        // rotation: _calculateBearing(start, end),
      );
      state.markers.add(carMarker);
      event.mapMarkerSink.add(state.markers.toList());

      for (int j = 0; j <= 10; j++) {
        double lat = _lerp(start.latitude, end.latitude, j / 10);
        double lng = _lerp(start.longitude, end.longitude, j / 10);
        LatLng newPos = LatLng(lat, lng);

        state.markers.removeWhere((marker) => marker.markerId.value == "driverMarker");
        carMarker = carMarker.copyWith(positionParam: newPos, rotationParam: _calculateBearing(start, end));
        state.markers.add(carMarker);
        event.mapMarkerSink.add(state.markers.toList());

        await Future.delayed(const Duration(milliseconds: 90));
      }
    }
  }

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
}

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wmssimulator/bloc/trips/trips_bloc.dart';
import 'package:wmssimulator/models/trip_model.dart';
import 'dart:math';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;

import 'package:wmssimulator/pages/customs/customs.dart';
import 'dart:html' as html;
class Maps extends StatefulWidget {
  Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with TickerProviderStateMixin {
  final StreamController<List<Marker>> _mapMarkerSC = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
  // bool leftPanelVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<TripsBloc>().state.routeCoords = [];
    context.read<TripsBloc>().state.coveredPath = [];
    context.read<TripsBloc>().state.polylines = {};
    context.read<TripsBloc>().state.coveredEnd = null;
    context.read<TripsBloc>().state.markers = {};
    context.read<TripsBloc>().add(LoadRoute(
        start: LatLng(context.read<TripsBloc>().state.selectedTrip!.startLoc!.latitude!, context.read<TripsBloc>().state.selectedTrip!.startLoc!.longitude!),
        end: LatLng(context.read<TripsBloc>().state.selectedTrip!.endLoc!.latitude!, context.read<TripsBloc>().state.selectedTrip!.endLoc!.longitude!),
        waypoints: context.read<TripsBloc>().state.selectedTrip!.waypoints?.map((e) => LatLng(e.latitude!, e.longitude!)).toList(),
        context: context));
  }

  // @override
  // void dispose() {
  //   _mapMarkerSC.close();
  //   super.dispose();
  // }

  OverlayEntry? overlayEntry;
  LatLng? activeMarkerPosition;
  LatLng markerPosition = LatLng(37.7749, -122.4194); // Sample location

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

  void _fitBoundsToMarkers(List<LatLng> locations, GoogleMapController mapController) {
    if (locations.isEmpty) return;

    LatLngBounds bounds = _calculateBounds(locations);

    // Move the camera to fit all points with padding
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100), // Padding in pixels
    );
  }

  StreamBuilder<List<Marker>> googleMap() {
    return StreamBuilder<List<Marker>>(
      stream: _mapMarkerSC.stream,
      builder: (context, snapshot) {
        return GoogleMap(
          // key: UniqueKey(),
          mapType: MapType.normal,

          initialCameraPosition: CameraPosition(
              target: LatLng(context.read<TripsBloc>().state.selectedTrip!.startLoc!.latitude!, context.read<TripsBloc>().state.selectedTrip!.startLoc!.longitude!), zoom: 17),
          rotateGesturesEnabled: true,

          tiltGesturesEnabled: false,
          mapToolbarEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onCameraMove: (CameraPosition position) async {
            if (context.read<TripsBloc>().state.screenPosition != null) {
              context.read<TripsBloc>().add(ShowOverlay(
                    context: context,
                    activeMarkerPosition: context.read<TripsBloc>().state.activeMarkerPosition!,
                  ));
            }
          },

          onMapCreated: (GoogleMapController controller) {
            context.read<TripsBloc>().state.mapController = controller;
            Future.delayed(Duration(milliseconds: 500), () {
              _fitBoundsToMarkers(context.read<TripsBloc>().state.markers.map((m) => m.position).toList(), controller);
            });
            Future.delayed(const Duration(seconds: 1), () => context.read<TripsBloc>().add(AnimateDriver(mapMarkerSC: _mapMarkerSC, provider: this, context: context)));
          },

          markers: context.read<TripsBloc>().state.markers.toSet(),
          polylines: context.read<TripsBloc>().state.polylines,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // InAppWebViewController? webViewController;

    return PopScope(
      // canPop: false,

      onPopInvokedWithResult: (didPop, result)  {
         _mapMarkerSC.close();
          context.read<TripsBloc>().state.screenPosition = null;
           html.document.body?.focus();
        // context.pop();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 192, 230, 221),
        body: BlocBuilder<TripsBloc, TripsState>(builder: (context, state) {
          return SizedBox(
            height: size.height,
            child: Row(
              children: [
                  if(state.selectedTrip!.status!.toLowerCase()!="delivered")
                  SingleChildScrollView(
                  child: SizedBox(
                    width: size.width*0.24,
                    child: Wrap(
                      // direction: Axis.vertical,
                      
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Customs.DashboardWidget(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 26, 26, 26),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                                  height: size.height * 0.36,
                                  customMargin: EdgeInsets.symmetric(horizontal: size.width * 0.005, vertical: size.height * 0.01),
                                  loaderEnabled: false, // context.watch<TripsBloc>().state.geoLocationStatus != GeoLocationStatus.success,
                                  chartBuilder: (lsize) {
                                    return SizedBox(
                                      height: lsize.maxHeight,
                                      width: lsize.maxWidth,
                                      child: SfRadialGauge(
                                        axes: [
                                          RadialAxis(
                                              useRangeColorForAxis: true,
                                              maximum: 200,
                                              minimum: 0,
                                              interval: size.width < 1300 ? 20 : 10,
                                              majorTickStyle: const MajorTickStyle(length: 10, thickness: 2, color: Colors.white),
                                              minorTickStyle: const MinorTickStyle(length: 5, thickness: 1.5, color: Colors.grey),
                                              ranges: <GaugeRange>[
                                                GaugeRange(
                                                    startValue: 0,
                                                    endValue: 200,
                                                    sizeUnit: GaugeSizeUnit.factor,
                                                    startWidth: 0.065,
                                                    endWidth: 0.065,
                                                    rangeOffset: 0,
                                                    labelStyle: const GaugeTextStyle(color: Colors.white),
                                                    gradient: const SweepGradient(
                                                      colors: <Color>[Colors.green, Colors.yellow, Colors.red],
                                                      stops: <double>[0.0, 0.5, 1],
                                                    ))
                                              ],
                                              pointers: <GaugePointer>[
                                                NeedlePointer(
                                                    value: state.selectedTrip!.vehicleInfo!.speed ?? 63,
                                                    needleLength: 0.90,
                                                    enableAnimation: true,
                                                    animationType: AnimationType.ease,
                                                    needleStartWidth: 1.5,
                                                    needleEndWidth: 6,
                                                    needleColor: Colors.red,
                                                    gradient: LinearGradient(
                                                        colors: [Colors.red, Color.fromARGB(255, 240, 83, 72), Color.fromARGB(255, 248, 104, 93), Color.fromARGB(0, 230, 138, 138)],
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter),
                                                    knobStyle: KnobStyle(
                                                        knobRadius: 0.09, borderWidth: 0.001, sizeUnit: GaugeSizeUnit.factor, borderColor: const Color.fromARGB(255, 111, 111, 111)))
                                              ],
                                              )
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                                Positioned(
                                  top: 15,
                                  right: 14,
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                                        "assets/images/power.svg",
                                                        color: state.selectedTrip!.vehicleInfo!.ignition == null || state.selectedTrip!.vehicleInfo!.ignition == false
                                                            ? Colors.grey
                                                            : Colors.deepOrange,
                                                        key: UniqueKey(),
                                                        height: size.height * 0.36 * 0.12,
                                                        width: size.width * 0.24 * 0.12,
                                                      ),
                                                       Text(
                                                  state.selectedTrip!.vehicleInfo!.ignition == null || state.selectedTrip!.vehicleInfo!.ignition == false ? "OFF" : "ON",
                                                  style: TextStyle(
                                                      color: state.selectedTrip!.vehicleInfo!.ignition == null || state.selectedTrip!.vehicleInfo!.ignition == false
                                                          ? Colors.grey
                                                          : Colors.deepOrange,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: size.height * 0.36 * 0.038,
                                                      shadows: [Shadow(blurRadius: 1, color: Colors.deepOrange)]),
                                                )
                                    ],
                                  ),
                                )
                                ,Positioned(
                                    top: size.height * 0.24*0.435,
                                  left: size.width*0.24*0.44,
                                  child:  Text("SPEED", style: TextStyle(color: Colors.white, fontSize: size.height*0.24 * 0.084 , fontWeight: FontWeight.bold, letterSpacing: 1)),)
                          ,
                          Positioned(
                            bottom:  size.height * 0.24*0.44,
                            left:size.width*0.24*0.47,
                            child: Column(children: <Widget>[
                                                  Text(
                                                    state.selectedTrip!.vehicleInfo!.speed.toString(),
                                                      style: TextStyle(color: Colors.white, fontSize:size.height * 0.24 * 0.085, fontWeight: FontWeight.bold)),
                                                  // SizedBox(height: 20),
                                                  Text('kmph', style: TextStyle(color: Colors.white, fontSize: size.height * 0.24 * 0.065, fontWeight: FontWeight.bold))
                                                ]),),

                          Positioned(
                            bottom: size.height*0.24*0.1,
                            left: size.width*0.24*0.24,
                            child:  Row(
                              children: [
                                Container(
                                                        width: size.width * 0.24* 0.5,
                                                        height: size.height* 0.24*0.14,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(4),
                                                            color: Colors.black,
                                                            boxShadow: [BoxShadow(color: const Color.fromARGB(66, 158, 158, 158), blurStyle: BlurStyle.inner, blurRadius: 4, spreadRadius: 2)]),
                                                        child: LayoutBuilder(builder: (context, constraints) {
                                                          return Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children:
                                                                    '${'0' * (6 - state.selectedTrip!.vehicleInfo!.odometerValue.toString().length)}${state.selectedTrip!.vehicleInfo!.odometerValue.toString()}'
                                                                        .split('')
                                                                        .map((e) => Container(
                                                                              alignment: Alignment.center,
                                                                              margin: EdgeInsets.symmetric(horizontal: 1),
                                                                              width: constraints.maxWidth * 0.14,
                                                                              height: constraints.maxHeight * 0.88,
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.black,
                                                                                  borderRadius: BorderRadius.circular(4),
                                                                                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 0)]),
                                                                              child: Text(
                                                                                e,
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ))
                                                                        .toList()),
                                                          );
                                                        }),
                                                      ),
                            Gap(4),
                             Text(
                                                    'Km',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: size.height*0.24 * 0.08,
                                                    ),
                                                  ),
                              ],
                            ),
                                                )
                          ],
                        ),
                        Customs.DashboardWidget(
                            height: size.height * 0.34,
                            customMargin: EdgeInsets.symmetric(horizontal: size.width * 0.005, vertical: size.height * 0.01),
                            width: size.width * 0.11,
                            // padding: EdgeInsets.zero,
                            loaderEnabled: false, //context.watch<TripsBloc>().state.geoLocationStatus != GeoLocationStatus.success,
                            chartBuilder: (lszie) {
                              return Customs.WMSTemperatureWidget(
                                value: state.selectedTrip!.vehicleInfo!.engineTemp,
                                lsize: lszie,
                                color: Colors.red,
                                title: "Engine Temp",
                              );
                            }),
                        Customs.DashboardWidget(
                            height: size.height * 0.34,
                            customMargin: EdgeInsets.symmetric(horizontal: size.width * 0.005, vertical: size.height * 0.01),
                            width: size.width * 0.11,
                            // padding: EdgeInsets.zero,
                            loaderEnabled: false, //context.watch<TripsBloc>().state.geoLocationStatus != GeoLocationStatus.success,
                                    
                            chartBuilder: (lszie) {
                              return Customs.WMSTemperatureWidget(value: state.selectedTrip!.vehicleInfo!.containerTemp, lsize: lszie, color: Colors.red, title: "Container Temp");
                            }),
                        Customs.DashboardWidget(
                            height: size.height * 0.21,
                            width: size.width * 0.11,
                            loaderEnabled: false,
                            customMargin: EdgeInsets.symmetric(horizontal: size.width * 0.005, vertical: size.height * 0.01),
                            chartBuilder: (lsize) {
                              return Stack(
                                children: [
                                  Positioned(
                                    top: lsize.maxHeight * 0.4,
                                    child: Image.asset(
                                      "assets/images/fuel.png",
                                      height: lsize.maxHeight * 0.2,
                                      width: lsize.maxWidth * 0.2,
                                    ),
                                  ),
                                  SizedBox(
                                    width: lsize.maxWidth * 0.8,
                                    child: SfRadialGauge(
                                      enableLoadingAnimation: true,
                                      axes: [
                                        RadialAxis(
                                          startAngle: 270,
                                          endAngle: 90,
                                          labelFormat: '{value}', // Default label format
                                          onLabelCreated: (AxisLabelCreatedArgs args) {
                                            // Customizing labels
                                            if (args.text == '0') {
                                              args.text = 'E'; // Empty
                                            } else if (args.text == '50') {
                                              args.text = '1/2'; // Full
                                            } else if (args.text == '100') {
                                              args.text = 'F'; // Full
                                            }
                                          },
                                    
                                          showLastLabel: true,
                                          axisLabelStyle: GaugeTextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                                          pointers: <GaugePointer>[
                                            NeedlePointer(
                                              value: (state.selectedTrip!.vehicleInfo!.fuel ?? 0.1) * 100,
                                              animationType: AnimationType.ease,
                                              needleColor: Colors.red,
                                              knobStyle: KnobStyle(color: Colors.black),
                                              needleLength: 0.72,
                                              enableAnimation: true,
                                              needleStartWidth: 1.5,
                                              needleEndWidth: 4,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                        Customs.DashboardWidget(
                            height: size.height * 0.21,
                            width: size.width * 0.11,
                            customMargin: EdgeInsets.symmetric(horizontal: size.width * 0.005, vertical: size.height * 0.01),
                            loaderEnabled: false,
                            
                            chartBuilder: (lsize) {
                              return Center(
                                  child: Column(
                                children: [
                                  Gap(8),
                                  Text(
                                    "Container weight",
                                    style: TextStyle(fontSize:lsize.maxHeight * 0.09, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
                                  ),
                                  Gap(6),
                                  Image.asset(
                                    "assets/images/weight.png",
                                    height: lsize.maxHeight * 0.46,
                                  ),
                                  Gap(8),
                                  Text(
                                    "${state.selectedTrip!.vehicleInfo!.containerWeight}" "Kg",
                                    style: TextStyle(fontSize: lsize.maxHeight * 0.11, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ));
                            }),
                      ],
                    ),
                  ),
                ),
             
                   AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    child: Customs.DashboardWidget(
                        width:  (state.selectedTrip!.status!.toLowerCase()!="delivered")? size.width * 0.74:size.width*0.98 ,
                        height: size.height,
                        padding: EdgeInsets.zero,
                        loaderEnabled: state.geoLocationStatus != GeoLocationStatus.success,
                        margin: size.height * 0.014,
                        chartBuilder: (lsize) {
                          return Stack(
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(24), child: googleMap()),
                              if (state.screenPosition != null && state.activeMarkerPosition != null)
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 500),
                                  left: state.screenPosition!.x.toDouble(),
                                  top: state.screenPosition!.y.toDouble(),
                                  child: GestureDetector(
                                    onTap: () => {
                                      context.read<TripsBloc>().add(HideOverlay()),
                                      state.displayTruckOverlay = false,
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(color: Colors.white, width: 2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: state.overlayWidget),
                                  ),
                                ),
                            ],
                          );
                        }),
                  )
             
           
              ],
            ),
          );
        }),
      ),
    );
  }
}

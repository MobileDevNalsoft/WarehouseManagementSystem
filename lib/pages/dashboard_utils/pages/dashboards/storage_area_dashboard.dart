import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';

import 'package:warehouse_3d/pages/customs/customs.dart';

class StorageAreaDashboard extends StatefulWidget {
  StorageAreaDashboard({super.key});

  @override
  State<StorageAreaDashboard> createState() => _StorageAreaDashboardState();
}

class _StorageAreaDashboardState extends State<StorageAreaDashboard> {
  List<BarData> supplierWiseDataSource = [
    BarData(xLabel: 'S1', yValue: 10, abbreviation: 'Supplier1'),
    BarData(xLabel: 'S2', yValue: 4, abbreviation: 'Supplier2'),
    BarData(xLabel: 'S3', yValue: 6, abbreviation: 'Supplier3'),
    BarData(xLabel: 'S4', yValue: 3, abbreviation: 'Supplier4'),
    BarData(xLabel: 'S5', yValue: 20, abbreviation: 'Supplier5'),
    BarData(xLabel: 'S6', yValue: 2, abbreviation: 'Supplier6'),
    BarData(xLabel: 'S7', yValue: 2, abbreviation: 'Supplier7')
  ];

  List<PieData> inventorySummaryDataSource = [
    PieData(xData: "In Stock", yData: 456, color: const Color.fromARGB(255, 148, 224, 214)),
    PieData(xData: "Running Out of Stock", yData: 68, color: const Color.fromARGB(255, 184, 172, 149)),
    PieData(xData: "Out of Stock", yData: 26, color: const Color.fromARGB(255, 221, 152, 184))
  ];

  List<PieData> inventoryAgingDataSource = [
    PieData(xData: "< 30 Days", yData: 76, color: const Color.fromARGB(255, 148, 215, 224)),
    PieData(xData: "30 - 90 Days", yData: 368, color: const Color.fromARGB(255, 159, 196, 161)),
    PieData(xData: "> 90 Days", yData: 43, color: const Color.fromARGB(255, 180, 140, 164))
  ];

  final List<TimeData> chartData1 = [
    TimeData('David', 81, const Color.fromARGB(255, 151, 174, 206)),
    TimeData('sd', 19, Colors.transparent),
  ];

  late DashboardsBloc _dashboardsBloc;

  SuggestionsController<Object?> suggestionsController = SuggestionsController();
  late TextEditingController typeAheadController;
  late FocusNode typeAheadFocusNode;

  @override
  void initState() {
    super.initState();

    _dashboardsBloc = context.read<DashboardsBloc>();
    _dashboardsBloc.add(GetStorageDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return SingleChildScrollView(child: BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
      bool isEnabled = state.getStorageDashboardState != StorageDashboardState.success;
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Customs.DashboardWidget(size: size, loaderEnabled: isEnabled, chartBuilder: (lsize) => Stack(
                                  children: [
                                    Customs.WMSSfCircularChart(
                                      height: lsize.maxHeight,
                                      width: lsize.maxWidth,
                                      title: 'Location Utilization',
                                      series: SeriesName.radialBar,
                                      radialBarProps: RadialBarProps(
                                        dataSource: state.storageDashboardData!.locationUtilization!
                                              .where((e) => e.locType!.replaceAll('"', '').split('/')[1] == state.selectedLocType!)
                                              .first
                                              .typeUtil!
                                              .asMap()
                                              .entries
                                              .map((e) =>
                                                  PieData(xData: e.value.status!, yData: e.value.count!))
                                              .toList(),
                                        maximumValue: state.storageDashboardData!.locationUtilization!
                                              .where((e) => e.locType!.replaceAll('"', '').split('/')[1] == state.selectedLocType!)
                                              .first
                                              .typeUtil!
                                              .map((e) => e.count!)
                                              .toList()
                                              .reduce((curr, next) => curr > next ? curr : next)
                                              .toDouble(),
                                        innerRadius: '30%',
                                        pointColorMapper: (datum, index) {
                                            if (index == 0) {
                                              return const Color.fromRGBO(139, 182, 162, 1);
                                            } else if (index == 1){
                                              return const Color.fromRGBO(232, 212, 162, 1);
                                            } else {
                                              return const Color.fromRGBO(255, 116, 106, 1);
                                            }
                                          }
                                      )
                                    ),
                                    Positioned(
                                      top: lsize.maxHeight * 0.02,
                                      right: 0,
                                      child: TypeAheadField(
                                        suggestionsController: suggestionsController,
                                        builder: (context, textController, focusNode) {
                                          typeAheadController = textController;
                                          typeAheadFocusNode = focusNode;
                                          focusNode = focusNode;
                                          focusNode.addListener(() {
                                            if (focusNode.hasFocus) {
                                              textController.clear();
                                            }
                                          });
                                          if (state.selectedLocType != null) {
                                            textController.text = state.selectedLocType!;
                                          }
                                          return SizedBox(
                                            height: lsize.maxHeight * 0.08,
                                            width: lsize.maxWidth * 0.25,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                onTap: () {},
                                                cursorColor: Colors.black,
                                                cursorHeight: lsize.maxHeight * 0.05,
                                                style: TextStyle(fontSize: lsize.maxHeight * 0.03),
                                                decoration: InputDecoration(
                                                  hintText: 'Choose',
                                                  contentPadding:
                                                      EdgeInsets.only(top: lsize.maxHeight * 0.02, left: lsize.maxWidth * 0.01, right: lsize.maxWidth * 0.015),
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                                                  hintStyle: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                                controller: textController,
                                                focusNode: focusNode,
                                              ),
                                            ),
                                          );
                                        },
                                        suggestionsCallback: (pattern) {
                                          return state.storageDashboardData!.locationUtilization!
                                              .map((e) => e.locType!.replaceAll('"', '').split('/')[1])
                                              .where((e) => e.toLowerCase().contains(pattern.toLowerCase()))
                                              .toList();
                                        },
                                        itemBuilder: (context, suggestion) => Container(
                                          height: lsize.maxHeight * 0.1,
                                          width: lsize.minWidth * 0.1,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            suggestion.toString(),
                                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                        onSelected: (suggestion) {
                                          typeAheadController.clear();
                                          typeAheadController.text = suggestion.toString();
                                          _dashboardsBloc.add(ChangeLocType(locType: suggestion.toString()));
                                          suggestionsController.close();
                                          suggestionsController.refresh();
                                        },
                                        constraints: BoxConstraints(maxHeight: lsize.maxHeight * 0.7, maxWidth: lsize.maxWidth * 0.3),
                                      ),
                                    )
                                  ],
                                ),),
                      Customs.DashboardWidget(
                        size: size,
                        loaderEnabled: isEnabled,
                        chartBuilder: (lsize) => Customs.WMSSfCircularChart(
                          height: lsize.maxHeight,
                          width: lsize.maxWidth,
                          title: 'Warehouse Utilization',
                          doughnutProps: DoughnutProps(
                            dataSource: state.storageDashboardData!.warehouseUtilization!
                                    .asMap()
                                    .entries
                                    .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                                    .toList(),
                            pointColorMapper: (datum, index) {
                              if (index == 1) {
                                        return const Color.fromARGB(255, 102, 82, 156);
                                      }else {
                                        return const Color.fromARGB(255, 178, 166, 209);
                                      }
                            },
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, lsize) {
                            return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : SfCircularChart(
                              title: ChartTitle(
                                text: 'Inventory Summary',
                                textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                              ),
                              legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                              series: <CircularSeries>[
                                // Renders radial bar chart
                                PieSeries<PieData, String>(
                                  dataSource: isEnabled
                                      ? inventorySummaryDataSource
                                      : state.storageDashboardData!.inventorySummary!
                                          .asMap()
                                          .entries
                                          .map((e) => PieData(xData: e.value.status!, yData: e.value.count!, color: inventorySummaryDataSource[e.key].color))
                                          .toList(),
                                  dataLabelSettings: const DataLabelSettings(
                                      // Renders the data label
                                      isVisible: true,
                                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                                      alignment: ChartAlignment.center),
                                  pointColorMapper: (datum, index) {
                                    return inventorySummaryDataSource[index].color;
                                  },
                                  xValueMapper: (PieData data, _) => data.xData,
                                  yValueMapper: (PieData data, _) => data.yData,
                                )
                              ],
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, lsize) {
                            return isEnabled
                                ? Customs.DashboardLoader(lsize: lsize)
                                :  SfCircularChart(
                              title: ChartTitle(
                                text: 'Inventory Aging',
                                textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                              ),
                              legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                              series: <CircularSeries>[
                                // Renders radial bar chart
                                PieSeries<PieData, String>(
                                  dataSource: isEnabled
                                      ? inventoryAgingDataSource
                                      : [
                                          PieData(
                                              xData: "< 30 Days",
                                              yData: state.storageDashboardData!.inventoryAging!.count30Days!.toDouble(),
                                              color: const Color.fromARGB(255, 148, 215, 224)),
                                          PieData(
                                              xData: "30 - 90 Days",
                                              yData: state.storageDashboardData!.inventoryAging!.count30To90Days!.toDouble(),
                                              color: const Color.fromARGB(255, 159, 196, 161)),
                                          PieData(
                                              xData: "> 90 Days",
                                              yData: state.storageDashboardData!.inventoryAging!.countGreaterThan90Days!.toDouble(),
                                              color: const Color.fromARGB(255, 180, 140, 164))
                                        ],
                                  dataLabelSettings: const DataLabelSettings(
                                      // Renders the data label
                                      isVisible: true,
                                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                                      alignment: ChartAlignment.center),
                                  pointColorMapper: (datum, index) {
                                    return inventoryAgingDataSource[index].color;
                                  },
                                  xValueMapper: (PieData data, _) => data.xData,
                                  yValueMapper: (PieData data, _) => data.yData,
                                )
                              ],
                            );
                          }
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, lsize) {
                            return isEnabled
                                ? Customs.DashboardLoader(lsize: lsize)
                                : Customs.WMSCartesianChart(
                                title: 'Supplierwise Inventory',
                                yAxisTitle: 'Number of Items',
                                barCount: 1,
                                legendVisibility: false,
                                barColors: [Colors.teal],
                                dataSources: isEnabled
                                    ? [supplierWiseDataSource]
                                    : [
                                        state.storageDashboardData!.supplierWiseInventory!
                                            .map(
                                              (e) => BarData(xLabel: e.supplier.toString(), yValue: e.origQty!, abbreviation: e.supplier!),
                                            )
                                            .toList()
                                      ]);
                          }
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(aspectRatio * 8),
                          height: size.height * 0.45,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                          padding: EdgeInsets.all(size.height * 0.035),
                          alignment: Alignment.center,
                          child: LayoutBuilder(
                            builder: (context, lsize) {
                              return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : SfCircularChart(
                                title: ChartTitle(text: "Avg Storage Time", textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold)),
                                annotations: <CircularChartAnnotation>[
                                  CircularChartAnnotation(
                                    verticalAlignment: ChartAlignment.center,
                                    widget: Container(
                                        height: size.height * 0.12,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blueGrey.shade100,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade900,
                                              blurRadius: 10, // Adjust to set shadow direction
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          isEnabled ? '03h:15m' : "${state.storageDashboardData!.averageStorageTime.toString()}d",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: size.height * 0.02,
                                          ),
                                        )),
                                  ),
                                ],
                                series: <CircularSeries>[
                                  DoughnutSeries<TimeData, String>(
                                    dataSource: chartData1,
                                    xValueMapper: (TimeData data, _) => data.x,
                                    yValueMapper: (TimeData data, _) => data.y,
                                    radius: '60%', // Adjust the radius as needed
                                    innerRadius: '40%', // Optional: adjust for a thinner ring
                                    pointColorMapper: (TimeData data, _) => data.color,
                                  )
                                ],
                              );
                            }
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.all(aspectRatio * 8),
                          height: size.height * 0.45,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                          padding: EdgeInsets.all(size.height * 0.035),
                          alignment: Alignment.center,
                          child: LayoutBuilder(
                            builder: (context, lsize) {
                              return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Gauges.SfRadialGauge(
                                title: Gauges.GaugeTitle(
                                    text: "Cycle Count Accuracy",
                                    alignment: Gauges.GaugeAlignment.center,
                                    textStyle: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold)),
                                axes: [
                                  Gauges.RadialAxis(
                                    maximum: 100,
                                    minimum: 0,
                                    interval: 25,
                                    canScaleToFit: true,
                                    annotations: [
                                      Gauges.GaugeAnnotation(
                                          verticalAlignment: Gauges.GaugeAlignment.center,
                                          widget: Container(
                                            height: size.height * 0.12,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blueGrey.shade100,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade900,
                                                  blurRadius: 10, // Adjust to set shadow direction
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              '${state.storageDashboardData!.cycleCountAccuracy!.toStringAsFixed(2)}%',
                                              style: TextStyle(fontSize: aspectRatio * 10),
                                            ),
                                          ))
                                    ],
                                    axisLineStyle: const Gauges.AxisLineStyle(
                                        thickness: 35, color: Color.fromARGB(255, 86, 185, 152), cornerStyle: Gauges.CornerStyle.bothCurve),
                                    showTicks: false,
                                    showLabels: false,
                                    radiusFactor: aspectRatio * 0.3,
                                    pointers: [
                                      Gauges.MarkerPointer(
                                        value: isEnabled ? 90 : state.storageDashboardData!.cycleCountAccuracy ?? 0,
                                        markerType: Gauges.MarkerType.invertedTriangle,
                                        markerHeight: 20,
                                        markerWidth: 20,
                                        color: Colors.white,
                                        enableAnimation: true,
                                        elevation: 10,
                                      )
                                    ],
                                  )
                                ],
                              );
                            }
                          )),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      );
    }));
  }
}

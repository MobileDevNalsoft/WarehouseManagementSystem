import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class StorageAreaDashboard extends StatelessWidget {
  StorageAreaDashboard({super.key});

  List<BarData> supplierWiseDataSource = [
    BarData(xLabel: 'S1', yValue: 10, abbreviation: 'Supplier1'),
    BarData(xLabel: 'S2', yValue: 4, abbreviation: 'Supplier2'),
    BarData(xLabel: 'S3', yValue: 6, abbreviation: 'Supplier3'),
    BarData(xLabel: 'S4', yValue: 3, abbreviation: 'Supplier4'),
    BarData(xLabel: 'S5', yValue: 20, abbreviation: 'Supplier5'),
    BarData(xLabel: 'S6', yValue: 2, abbreviation: 'Supplier6'),
    BarData(xLabel: 'S7', yValue: 2, abbreviation: 'Supplier7')
  ];

  List<PieData> locationUtilizationDataSource = [
    PieData(xData: "Occupied Bins", yData: 30, color: const Color.fromRGBO(232, 212, 162, 1)),
    PieData(xData: "Avalable Bins", yData: 6, color: const Color.fromRGBO(139, 182, 162, 1)),
    PieData(xData: "Full Bins", yData: 16, color: const Color.fromRGBO(255, 116, 106, 1))
  ];

  List<PieData> warehouseUtilizationDataSource = [
    PieData(xData: "Occupied Bins", yData: 300, color: const Color.fromARGB(255, 181, 166, 221)),
    PieData(xData: "Avalable Bins", yData: 60, color: const Color.fromARGB(255, 238, 236, 135)),
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
    TimeData('David', 81, const Color.fromRGBO(183, 200, 224, 1)),
    TimeData('sd', 19, Colors.transparent),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter,
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Location Utilization',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                        ),
                        legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                        series: <CircularSeries>[
                          // Renders radial bar chart
                          RadialBarSeries<PieData, String>(
                            dataSource: locationUtilizationDataSource,
                            maximumValue: 36,
                            dataLabelSettings: const DataLabelSettings(
                                // Renders the data label
                                isVisible: true,
                                textStyle: TextStyle(fontWeight: FontWeight.bold),
                                alignment: ChartAlignment.near),
                            pointColorMapper: (datum, index) {
                              return locationUtilizationDataSource[index].color;
                            },
                            xValueMapper: (PieData data, _) => data.xData,
                            yValueMapper: (PieData data, _) => data.yData,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter,
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Warehouse Utilization',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                        ),
                        legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                        series: <CircularSeries>[
                          // Renders radial bar chart

                          DoughnutSeries<PieData, String>(
                            dataSource: warehouseUtilizationDataSource,
                            dataLabelSettings: const DataLabelSettings(
                                // Renders the data label
                                isVisible: true,
                                textStyle: TextStyle(fontWeight: FontWeight.bold),
                                alignment: ChartAlignment.near),
                            pointColorMapper: (datum, index) {
                              return warehouseUtilizationDataSource[index].color;
                            },
                            xValueMapper: (PieData data, _) => data.xData,
                            yValueMapper: (PieData data, _) => data.yData,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter,
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Inventory Summary',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                        ),
                        legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                        series: <CircularSeries>[
                          // Renders radial bar chart
                          PieSeries<PieData, String>(
                            dataSource: inventorySummaryDataSource,
                            dataLabelSettings: const DataLabelSettings(
                                // Renders the data label
                                isVisible: true,
                                textStyle: TextStyle(fontWeight: FontWeight.bold),
                                alignment: ChartAlignment.near),
                            pointColorMapper: (datum, index) {
                              return inventorySummaryDataSource[index].color;
                            },
                            xValueMapper: (PieData data, _) => data.xData,
                            yValueMapper: (PieData data, _) => data.yData,
                          )
                        ],
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
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter,
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Inventory Aging',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                        ),
                        legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                        series: <CircularSeries>[
                          // Renders radial bar chart
                          PieSeries<PieData, String>(
                            dataSource: inventoryAgingDataSource,
                            dataLabelSettings: const DataLabelSettings(
                                // Renders the data label
                                isVisible: true,
                                textStyle: TextStyle(fontWeight: FontWeight.bold),
                                alignment: ChartAlignment.near),
                            pointColorMapper: (datum, index) {
                              return inventoryAgingDataSource[index].color;
                            },
                            xValueMapper: (PieData data, _) => data.xData,
                            yValueMapper: (PieData data, _) => data.yData,
                          )
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]
                        ),
                        padding: EdgeInsets.all(size.height*0.035),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Supplierwise Inventory',
                              style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: size.height*0.3,
                              width: size.width*0.25,
                              child: Customs.WMSCartesianChart(
                                title: "",
                                      yAxisTitle: 'Number of Items', barCount: 1, barColors: [Colors.teal], dataSources: [supplierWiseDataSource],legendVisibility: false),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.topCenter,
                        child: SfCircularChart(
                          title: ChartTitle(
                              text: "Avg Storage Time",
                              alignment: ChartAlignment.near,
                              textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold)),
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
                                  '03h:15m',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.height * 0.02,
                                  ),
                                )
                              ),
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
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.topCenter,
                        child: Gauges.SfRadialGauge(
                          title: Gauges.GaugeTitle(
                              text: "Cycle Count Accuracy",
                              alignment: Gauges.GaugeAlignment.near,
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
                                        "90%",
                                        style: TextStyle(fontSize: aspectRatio * 10),
                                      ),
                                    ))
                              ],
                              axisLineStyle: const Gauges.AxisLineStyle(
                                  thickness: 35, color: Color.fromARGB(255, 125, 218, 187), cornerStyle: Gauges.CornerStyle.bothCurve),
                              showTicks: false,
                              showLabels: false,
                              radiusFactor: aspectRatio * 0.3,
                              pointers: const [
                                Gauges.MarkerPointer(
                                  value: 90,
                                  markerType: MarkerType.circle,
                                  markerHeight: 30,
                                  markerWidth: 30,
                                  color: Colors.white,
                                )
                              ],
                            )
                          ],
                        )),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    ));
  }
}

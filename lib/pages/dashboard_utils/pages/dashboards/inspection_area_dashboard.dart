import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;

class InspectionAreaDashboard extends StatefulWidget {
  InspectionAreaDashboard({super.key});

  @override
  State<InspectionAreaDashboard> createState() => _InspectionAreaDashboardState();
}

class _InspectionAreaDashboardState extends State<InspectionAreaDashboard> {
  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> barData = [
    BarData(xLabel: 'Mon', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 6, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 3, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 2, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> barData_sup = [
    BarData(xLabel: 'Oracle', yValue: 45, abbreviation: 'oracle'),
    BarData(xLabel: 'Nalsoft', yValue: 63, abbreviation: 'nalsoft'),
    BarData(xLabel: 'Abc', yValue: 24, abbreviation: 'abc'),
  ];

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> outBoundData = [
    BarData(xLabel: 'Mon', yValue: 6, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 8, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 15, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 7, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 10, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  final List<ChartData> chartData = [
    ChartData('David', 68, Color.fromRGBO(30, 184, 166, 1)),
    ChartData('sd', 32, Colors.transparent),
  ];

  late DashboardsBloc _dashboardsBloc;

  @override
  void initState() {
    super.initState();

    _dashboardsBloc = context.read<DashboardsBloc>();

    _dashboardsBloc.add(GetInspectionDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;

    return LayoutBuilder(builder: (context, constraints) {
      bool isWideScreen = constraints.maxWidth > 1200;
      bool isMediumScreen = constraints.maxWidth > 800 && constraints.maxWidth <= 1200;
      double horizontalPadding = isWideScreen
          ? AppDefaults.padding * 2
          : isMediumScreen
              ? AppDefaults.padding * 1.5
              : AppDefaults.padding;
      double containerWidth = isWideScreen
          ? constraints.maxWidth * 0.6
          : isMediumScreen
              ? constraints.maxWidth * 0.45
              : constraints.maxWidth * 0.9;
      double containerHeight = isWideScreen || isMediumScreen ? constraints.maxHeight * 1 : constraints.maxHeight * 1;

      return Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                BlocBuilder<DashboardsBloc, DashboardsState>(
                  builder: (context, state) {
                    bool isEnabled = state.getInspectionDashboardState != InspectionDashboardState.success;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             Container(
                              margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                            height: constraints.maxHeight * 0.48,
                            width: constraints.maxWidth * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.center,
                                child: LayoutBuilder(
                                  builder: (context, lsize) {
                                    return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Customs.WMSPieChart(
                                        title:'Today Quality Status',
                                        legendVisibility: true,
                                        dataSource: state.getInspectionDashboardState != InspectionDashboardState.success ? [] : state.inspectionDashboardData!.totalQualityStatus!.map((e) => PieData(xData: e.status!, yData: e.count!,text: e.count!.toString())).toList(),
                                        pointColorMapper: (datum, index) {
                                          if (index == 1) {
                                            return const Color.fromARGB(255, 45, 134, 172);
                                          } else if (index == 2) {
                                            return const Color.fromARGB(255, 155, 46, 38);
                                          } else {
                                            return const Color.fromARGB(255, 54, 228, 147);
                                          }
                                        });
                                  }
                                )),
                            Container(
                              margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                            height: constraints.maxHeight * 0.48,
                            width: constraints.maxWidth * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.center,
                                child: Builder(
                                  builder: (context) {
                                    return LayoutBuilder(
                                      builder: (context, lsize) {
                                        return isEnabled
                                                                    ? Customs.DashboardLoader(lsize: lsize)
                                                                    : Gauges.SfRadialGauge(
                                                                        title: Gauges.GaugeTitle(
                                          text: "Quality Efficiency",
                                          alignment: Gauges.GaugeAlignment.center,
                                          textStyle: TextStyle(fontSize: aspectRatio * 9, fontWeight: FontWeight.bold)),
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
                                                    isEnabled ? "85%" : '${state.inspectionDashboardData!.qualityEfficiency!}%',
                                                    style: TextStyle(fontSize: aspectRatio * 10),
                                                  ),
                                                ))
                                          ],
                                          axisLineStyle: const Gauges.AxisLineStyle(
                                              thickness: 35, color: Color.fromARGB(255, 189, 187, 64), cornerStyle: Gauges.CornerStyle.bothCurve),
                                          showTicks: false,
                                          showLabels: false,
                                          radiusFactor: aspectRatio * 0.3,
                                          pointers: [
                                            Gauges.MarkerPointer(
                                              value: isEnabled ? 85 : int.parse(state.inspectionDashboardData!.qualityEfficiency!.toString()).toDouble(),
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
                                    );
                                  }
                                ),),
                    
                             Container(
                              margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                            height: constraints.maxHeight * 0.48,
                            width: constraints.maxWidth * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.center,
                                child: LayoutBuilder(
                                  builder: (context, lsize) {
                                    return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : SfCircularChart(
                                      title: const ChartTitle(text: "Material Quality", textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                      annotations: <CircularChartAnnotation>[
                                        CircularChartAnnotation(
                                          widget: Container(
                                            width: 100, // Set the size of the shadowed circle
                                            height: 100,
                                            decoration: BoxDecoration(
                                              
                                              shape: BoxShape.circle,
                                              color: const Color.fromARGB(255, 232, 229, 229),
                                        
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4), // Adjust to set shadow direction
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        CircularChartAnnotation(
                                          widget: Container(
                                            child: Text(
                                              state.getInspectionDashboardState != InspectionDashboardState.success ? '68%' : '${state.inspectionDashboardData!.materialQuality!}%',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      series: <CircularSeries>[
                                        DoughnutSeries<ChartData, String>(
                                          dataSource: chartData,
                                          xValueMapper: (ChartData data, _) => data.x,
                                          yValueMapper: (ChartData data, _) => data.y,
                                          radius: '60%', // Adjust the radius as needed
                                          innerRadius: '45%', // Optional: adjust for a thinner ring
                                          pointColorMapper: (ChartData data, _) => data.color,
                                        )
                                      ],
                                    );
                                  }
                                )),
                          ],
                        ),
                        Gap(constraints.maxHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            Container(
                              margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                            height: constraints.maxHeight * 0.48,
                            width: constraints.maxWidth * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.center,
                                child: LayoutBuilder(
                                  builder: (context, lsize) {
                                    return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Customs.WMSCartesianChart(
                                        title: 'Day Wise Quality Summary  ',
                                        barCount: 1,
                                        dataSources: state.getInspectionDashboardState != InspectionDashboardState.success ? [barData] : [state.inspectionDashboardData!.daywiseQualitySummary!.map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!)).toList()],
                                        yAxisTitle: 'Quality Enabled LPNs',
                                        barColors: const [Color.fromARGB(255, 158, 103, 27)]);
                                  }
                                )),
                                    Container(
                              margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                            height: constraints.maxHeight * 0.48,
                            width: constraints.maxWidth * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.center,
                                child: LayoutBuilder(
                                  builder: (context, lsize) {
                                    return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Customs.WMSCartesianChart(
                                        title: 'Supplier Wise Quality  ',
                                        barCount: 1,
                                        dataSources: [barData_sup],
                                        yAxisTitle: 'Quality In Percentage',
                                        barColors: const [Color.fromARGB(255, 89, 163, 206)]);
                                  }
                                ))
                          ],
                        ),
                        
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

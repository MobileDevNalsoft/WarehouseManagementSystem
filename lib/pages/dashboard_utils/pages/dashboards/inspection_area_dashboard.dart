import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/dashboard_utils/shared/constants/defaults.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;

class InspectionAreaDashboard extends StatefulWidget {
  InspectionAreaDashboard({super.key});

  @override
  State<InspectionAreaDashboard> createState() => _InspectionAreaDashboardState();
}

class _InspectionAreaDashboardState extends State<InspectionAreaDashboard> {

  final List<PieData> chartData = [
    PieData(xData: 'David',yData: 68),
    PieData(xData: 'sd',yData: 32),
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
                          children: [
                            Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 10,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSSfCircularChart(
                                    ratio: ratio,
                                    title: 'Today Quality Status',
                                    titleFontSize: ratio*13,
                                    legendVisibility: true,
                                    series: SeriesName.pieSeries,
                                    props: Props(
                                      dataSource: state.inspectionDashboardData!.todayQualityStatus!.map((e) => PieData(xData: e.status!, yData: e.count!,text: e.count!.toString())).toList(),
                                      radius: '${ratio * 55}%',
                                      pointColorMapper: (p0, p1) {
                                        if (p1 == 1) {
                                            return const Color.fromARGB(255, 45, 134, 172);
                                          } else if (p1 == 2) {
                                            return const Color.fromARGB(255, 155, 46, 38);
                                          } else {
                                            return const Color.fromARGB(255, 54, 228, 147);
                                          }
                                      },
                                    ));
                              }),
                              Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 12,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSRadialGuage(
                                    title: "Quality Efficiency",
                                    titleFontSize: ratio*16,
                                    annotationHeight: ratio * 120,
                                    axisLineColor: Color.fromARGB(255, 189, 187, 64),
                                    annotationText: '${state.inspectionDashboardData!.qualityEfficiency!}%',
                                    annotationFontSize: ratio * 14,
                                    radiusFactor: ratio * 0.55,
                                    markerValue: state.inspectionDashboardData!.qualityEfficiency!);
                              }),
                              Customs.DashboardWidget(
                        size: Size(size.width * 0.25, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Customs.WMSSfCircularChart(
                                    ratio: ratio,
                                    title: "Material Quality",
                                    titleFontSize: ratio*13,
                                    enableAnnotation: true,
                                    annotationText: '${state.inspectionDashboardData!.materialQuality!}%',
                                    props: Props(
                                      dataSource: chartData,
                                      pointColorMapper: (p0, p1) {
                                        if (p1 == 0) {
                                          return const Color.fromRGBO(30, 184, 166, 1);
                                        } else {
                                          return Colors.white;
                                        }
                                      },
                                    ));
                        }
                      ),
                          ],
                        ),
                        Row(
                          children: [
                            Customs.DashboardWidget(
                        size: Size(size.width * 0.25, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Customs.WMSCartesianChart(
                                    title: 'Daywise Quality Summary',
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.inspectionDashboardData!.daywiseQualitySummary!.map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!)).toList()
                                    ],
                                    yAxisTitle: 'Quality Enabled LPNs',
                                    legendVisibility: false,
                                    barColors: [Color.fromARGB(255, 158, 103, 27)]);
                        }
                      ),
                                Customs.DashboardWidget(
                        size: Size(size.width * 0.25, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Customs.WMSCartesianChart(
                                    title: 'Supplier Wise Quality',
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.inspectionDashboardData!.supplierQuality!.map((e) => BarData(xLabel: e.supplier!, yValue: e.quality!.toInt(), abbreviation: e.supplier!)).toList()
                                    ],
                                    yAxisTitle: 'Quality In Percentage',
                                    legendVisibility: false,
                                    barColors: [Color.fromARGB(255, 89, 163, 206)]);
                        }
                      ),
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/dashboard_utils/shared/constants/defaults.dart';

class ReceivingAreaDashboard extends StatefulWidget {
  ReceivingAreaDashboard({super.key});

  @override
  State<ReceivingAreaDashboard> createState() => _ReceivingAreaDashboardState();
}

class _ReceivingAreaDashboardState extends State<ReceivingAreaDashboard> {
  late DashboardsBloc _dashboardsBloc;

  @override
  void initState() {
    super.initState();

    _dashboardsBloc = context.read<DashboardsBloc>();

    _dashboardsBloc.add(GetReceivingDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
    final List<PieData> chartData = [
      PieData(xData: 'David', yData: 69),
      PieData(xData: 'sd', yData: 31),
    ];

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
                BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
                  bool isEnabled = state.getReceivingDashboardState != ReceivingDashboardState.success;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 10,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSSfCircularChart(
                                    ratio: ratio,
                                    title: "Total ASN Status",
                                    titleFontSize: ratio*13,
                                    legendVisibility: true,
                                    series: SeriesName.pieSeries,
                                    props: Props(
                                      dataSource: state.receivingDashboardData!.todayAsnStatus!
                                          .map((e) => PieData(xData: e.status!, yData: e.count!, text: e.count!.toString()))
                                          .toList(),
                                      radius: '${ratio * 55}%',
                                      pointColorMapper: (p0, p1) {
                                        if (p1 == 0) {
                                          return const Color.fromARGB(255, 27, 219, 219);
                                        } else if (p1 == 1) {
                                          return const Color.fromARGB(255, 57, 33, 0);
                                        } else if (p1 == 2) {
                                          return const Color.fromARGB(255, 38, 82, 113);
                                        } else {
                                          return const Color.fromARGB(255, 241, 114, 41);
                                        }
                                      },
                                    ));
                              }),
                          Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 10,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSSfCircularChart(
                                    ratio: ratio,
                                    title: "Today Inbound Summary",
                                    titleFontSize: ratio*13,
                                    legendVisibility: true,
                                    series: SeriesName.pieSeries,
                                    props: Props(
                                      dataSource: state.receivingDashboardData!.totalInBoundSummary!
                                          .map((e) => PieData(xData: e.status!, yData: e.total!, text: e.total!.toString()))
                                          .toList(),
                                      radius: '${ratio * 55}%',
                                      pointColorMapper: (p0, p1) {
                                        if (p1 == 0) {
                                          return const Color.fromARGB(255, 219, 165, 27);
                                        } else if (p1 == 1) {
                                          return const Color.fromARGB(255, 163, 96, 2);
                                        } else {
                                          return const Color.fromARGB(255, 52, 129, 228);
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
                                    title: "Putaway Accuracy",
                                    titleFontSize: ratio*16,
                                    annotationHeight: ratio * 120,
                                    axisLineColor: Color.fromARGB(255, 86, 185, 152),
                                    annotationText: '${state.receivingDashboardData!.putawayAccuracy!}%',
                                    annotationFontSize: ratio * 12,
                                    radiusFactor: ratio * 0.55,
                                    markerValue: state.receivingDashboardData!.putawayAccuracy!);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 10,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSCartesianChart(
                                    title: 'Daywise Inbound Summary',
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.receivingDashboardData!.dayWiseInboundSummary!
                                          .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                          .toList()
                                    ],
                                    yAxisTitle: 'No of ASNs Received',
                                    legendVisibility: false,
                                    barColors: [const Color.fromARGB(255, 187, 157, 68)]);
                              }),
                          Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 10,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSCartesianChart(
                                    title: 'Supplier Wise Inbound Summary',
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.receivingDashboardData!.supplierwiseInboundSummary!
                                          .sublist(0, 7)
                                          .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                          .toList()
                                    ],
                                    yAxisTitle: 'No of ASNs Received',
                                    legendVisibility: false,
                                    barColors: [const Color.fromARGB(255, 196, 124, 72)]);
                              }),
                          Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 10,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSCartesianChart(
                                    title: 'User Receiving Efficiency',
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.receivingDashboardData!.userReceivingEfficiency!
                                          .map(
                                            (e) => BarData(xLabel: e.userName!.split('_')[0], yValue: e.count!, abbreviation: e.userName!),
                                          )
                                          .toList()
                                    ],
                                    yAxisTitle: 'No of LPNs Received',
                                    legendVisibility: false,
                                    barColors: [const Color.fromARGB(255, 55, 126, 170)]);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Customs.DashboardWidget(
                            size: Size(size.width * 0.25, size.height * 0.45),
                            margin: aspectRatio * 10,
                            loaderEnabled: isEnabled,
                            chartBuilder: (ratio) => Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: "Avg Receiving Time",
                                titleFontSize: ratio*13,
                                enableAnnotation: true,
                                annotationText: state.receivingDashboardData!.avgReceivingTime!,
                                props: Props(
                                  dataSource: chartData,
                                  pointColorMapper: (p0, p1) {
                                    if (p1 == 0) {
                                      return const Color.fromARGB(255, 94, 90, 158);
                                    } else {
                                      return Colors.transparent;
                                    }
                                  },
                                )),
                          ),
                          Customs.DashboardWidget(
                              size: Size(size.width * 0.25, size.height * 0.45),
                              margin: aspectRatio * 12,
                              loaderEnabled: isEnabled,
                              chartBuilder: (ratio) {
                                return Customs.WMSRadialGuage(
                                    title: "Receiving Efficiency",
                                    titleFontSize: ratio*16,
                                    annotationHeight: ratio * 120,
                                    axisLineColor: Color.fromARGB(255, 86, 185, 180),
                                    annotationText: '${state.receivingDashboardData!.receivingEfficiency!}%',
                                    annotationFontSize: ratio * 12,
                                    radiusFactor: ratio * 0.55,
                                    markerValue: state.receivingDashboardData!.receivingEfficiency!);
                              }),
                          Customs.DashboardWidget(
                            size: Size(size.width * 0.25, size.height * 0.45),
                            margin: aspectRatio * 10,
                            loaderEnabled: isEnabled,
                            chartBuilder: (ratio) => Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: "Avg PutAway Time",
                                titleFontSize: ratio*13,
                                enableAnnotation: true,
                                annotationText: state.receivingDashboardData!.avgPutawayTime!,
                                props: Props(
                                  dataSource: chartData,
                                  pointColorMapper: (p0, p1) {
                                    if (p1 == 0) {
                                      return const Color.fromARGB(255, 160, 90, 90);
                                    } else {
                                      return Colors.transparent;
                                    }
                                  },
                                )),
                          )
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      );
    });
  }
}

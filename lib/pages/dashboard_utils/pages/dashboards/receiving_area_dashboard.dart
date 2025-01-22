import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/dashboard_utils/shared/constants/defaults.dart';

class ReceivingAreaDashboard extends StatefulWidget {
  const ReceivingAreaDashboard({super.key});

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

      return BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
        bool isEnabled = state.getReceivingDashboardState != ReceivingDashboardState.success;
        return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: size.height * 0.5),
          children: [
            Customs.DashboardWidget(
                height: size.height * 0.45,
                margin: aspectRatio * 10,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSSfCircularChart(
                      lsize: lsize,
                      title: "Total ASN Status",
                      titleFontSize: 13,
                      legendVisibility: true,
                      series: SeriesName.pieSeries,
                      props: Props(
                        dataSource: state.receivingDashboardData!.todayAsnStatus!
                            .map((e) => PieData(xData: e.status!, yData: e.count!, text: e.count!.toString()))
                            .toList(),
                        radius: '${lsize.maxWidth * 0.2}%',
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
                height: size.height * 0.45,
                margin: aspectRatio * 10,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSSfCircularChart(
                      lsize: lsize,
                      title: "Today Inbound Summary",
                      titleFontSize: 13,
                      legendVisibility: true,
                      series: SeriesName.pieSeries,
                      props: Props(
                        dataSource: state.receivingDashboardData!.totalInBoundSummary!
                            .map((e) => PieData(xData: e.status!, yData: e.total!, text: e.total!.toString()))
                            .toList(),
                        radius: '${lsize.maxWidth * 0.2}%',
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
                height: size.height * 0.45,
                margin: aspectRatio * 12,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSRadialGuage(
                      title: "Putaway Accuracy",
                      titleFontSize: 15,
                      annotationHeight: lsize.maxHeight * 0.35,
                      axisLineColor: const Color.fromARGB(255, 86, 185, 152),
                      annotationText: '${state.receivingDashboardData!.putawayAccuracy!}%',
                      annotationFontSize: 15,
                      radiusFactor: lsize.maxHeight * 0.0022,
                      markerValue: state.receivingDashboardData!.putawayAccuracy!);
                }),
            Customs.DashboardWidget(
                height: size.height * 0.45,
                margin: aspectRatio * 10,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSCartesianChart(
                      title: 'Daywise Inbound Summary',
                      titleFontSize: 13,
                      xlabelFontSize: 12,
                      ylabelFontSize: 12,
                      ytitleFontSize: 13,
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
                height: size.height * 0.45,
                margin: aspectRatio * 10,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSCartesianChart(
                      title: 'Supplier Wise Inbound Summary',
                      titleFontSize: 13,
                      xlabelFontSize: 12,
                      ylabelFontSize: 12,
                      ytitleFontSize: 13,
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
                height: size.height * 0.45,
                margin: aspectRatio * 10,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSCartesianChart(
                      title: 'User Receiving Efficiency',
                      titleFontSize: 13,
                      xlabelFontSize: 12,
                      ylabelFontSize: 12,
                      ytitleFontSize: 13,
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
            Customs.DashboardWidget(
              height: size.height * 0.45,
              margin: aspectRatio * 10,
              loaderEnabled: isEnabled,
              chartBuilder: (lsize) => Customs.WMSSfCircularChart(
                  lsize: lsize,
                  title: "Avg Receiving Time",
                  titleFontSize: 13,
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
                height: size.height * 0.45,
                margin: aspectRatio * 12,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSRadialGuage(
                      title: "Receiving Efficiency",
                      titleFontSize: 15,
                      annotationHeight: lsize.maxHeight * 0.35,
                      axisLineColor: const Color.fromARGB(255, 86, 185, 180),
                      annotationText: '${state.receivingDashboardData!.receivingEfficiency!}%',
                      annotationFontSize: 15,
                      radiusFactor: lsize.maxHeight * 0.0022,
                      markerValue: state.receivingDashboardData!.receivingEfficiency!);
                }),
            Customs.DashboardWidget(
              height: size.height * 0.45,
              margin: aspectRatio * 10,
              loaderEnabled: isEnabled,
              chartBuilder: (lsize) => Customs.WMSSfCircularChart(
                  lsize: lsize,
                  title: "Avg PutAway Time",
                  titleFontSize: 13,
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
        );
      });
    });
  }
}

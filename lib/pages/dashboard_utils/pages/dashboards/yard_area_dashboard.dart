import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class YardAreaDashboard extends StatefulWidget {
  YardAreaDashboard({super.key});

  @override
  State<YardAreaDashboard> createState() => _YardAreaDashboardState();
}

class _YardAreaDashboardState extends State<YardAreaDashboard> {
  late DashboardsBloc _dashboardsBloc;

  @override
  void initState() {
    super.initState();
    _dashboardsBloc = context.read<DashboardsBloc>();
    _dashboardsBloc.add(GetYardDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<DashboardsBloc, DashboardsState>(
      builder: (context, state) {
        bool isEnabled =
            state.getYardDashboardState != YardDashboardState.success;
        return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: size.height * 0.5
          ),
          children: [
            Customs.DashboardWidget(
                height: size.height*0.45,
                margin: size.height * 0.02,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSCartesianChart(
                      title: 'Vehicle Detention',
                      titleFontSize: 13,
                      xlabelFontSize: 12,
                      ylabelFontSize: 12,
                      ytitleFontSize: 13,
                      barCount: 1,
                      barColors: [Color.fromRGBO(132, 142, 230, 1)],
                      dataSources: [
                        [
                          BarData(
                              xLabel: '<1 day',
                              yValue: isEnabled
                                  ? 10
                                  : state.yardDashboardData!.yardDetention!
                                      .singleDayCount!
                                      .toInt(),
                              abbreviation: '<1 day'),
                          BarData(
                              xLabel: '1-7 days',
                              yValue: isEnabled
                                  ? 6
                                  : state.yardDashboardData!.yardDetention!
                                      .count1To7Days!
                                      .toInt(),
                              abbreviation: '1-7 days'),
                          BarData(
                              xLabel: '>7 days',
                              yValue: isEnabled
                                  ? 20
                                  : state.yardDashboardData!.yardDetention!
                                      .countGreaterThan7Days!
                                      .toInt(),
                              abbreviation: '>7 days'),
                        ]
                      ],
                      yAxisTitle: 'Number of Vehicles',
                      legendVisibility: false);
                }),
            Customs.DashboardWidget(
                height: size.height*0.45,
                margin: size.height * 0.02,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSSfCircularChart(
                    lsize: lsize,
                    series: SeriesName.pieSeries,
                    title: 'Yard Utilization',
                    titleFontSize: 13,
                    legendVisibility: true,
                    props: Props(dataSource: [
                      PieData(
                          xData: "Available",
                          yData: isEnabled
                              ? 10
                              : (state.yardDashboardData!.yardUtilization!
                                      .totalLocations! -
                                  state.yardDashboardData!.yardUtilization!
                                      .occupied!),
                          text: isEnabled
                              ? 'String'
                              : (state.yardDashboardData!.yardUtilization!
                                          .totalLocations! -
                                      state.yardDashboardData!.yardUtilization!
                                          .occupied!)
                                  .toString()),
                      PieData(
                          xData: "Occupied",
                          yData: isEnabled
                              ? 20
                              : state.yardDashboardData!.yardUtilization!
                                  .occupied!,
                          text: isEnabled
                              ? 'String'
                              : (state.yardDashboardData!.yardUtilization!
                                      .occupied!)
                                  .toString())
                    ], labelFontSize: 12),
                  );
                }),
            Customs.DashboardWidget(
                height: size.height*0.45,
                margin: size.height * 0.02,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSCartesianChart(
                      title: 'Daywise Yard Utilization',
                      titleFontSize: 13,
                      xlabelFontSize: 12,
                      ylabelFontSize: 12,
                      ytitleFontSize: 13,
                      barCount: 2,
                      barColors: [
                        const Color.fromARGB(255, 231, 142, 247),
                        const Color.fromARGB(255, 194, 162, 103)
                      ],
                      legendVisibility: true,
                      yAxisTitle: 'Number of Vehicles',
                      dataSources: [
                        state.yardDashboardData!.dayWiseYardUtilzation!
                            .map(
                              (e) => BarData(
                                  xLabel: e.checkInDate!,
                                  yValue: e.loadingCnt!,
                                  abbreviation: e.checkInDate!),
                            )
                            .toList(),
                        state.yardDashboardData!.dayWiseYardUtilzation!
                            .map(
                              (e) => BarData(
                                  xLabel: e.checkInDate!,
                                  yValue: e.unloadingCnt!,
                                  abbreviation: e.checkInDate!),
                            )
                            .toList()
                      ]);
                }),
            Customs.DashboardWidget(
                height: size.height*0.45,
                margin: size.height * 0.02,
                loaderEnabled: isEnabled,
                chartBuilder: (lsize) {
                  return Customs.WMSSfCircularChart(
                      lsize: lsize,
                      title: "Previous month yard acitvity",
                      titleFontSize: 13,
                      series: SeriesName.radialBar,
                      legendVisibility: true,
                      props: Props(
                        dataSource: [
                          PieData(
                              xData: 'Loading',
                              yData: state.yardDashboardData!
                                  .previousMonthYardUtilization!.loadingCount!
                                  .toDouble()),
                          PieData(
                              xData: 'Unloading',
                              yData: state.yardDashboardData!
                                  .previousMonthYardUtilization!.unloadingCount!
                                  .toDouble()),
                        ],
                        labelFontSize: 12,
                        pointColorMapper: (p0, p1) {
                          if (p1 == 0) {
                            return Color.fromRGBO(132, 211, 86, 1);
                          } else {
                            return const Color.fromARGB(255, 215, 221, 124);
                          }
                        },
                      ));
                }),
          ],
        );
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

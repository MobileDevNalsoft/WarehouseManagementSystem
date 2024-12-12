import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/yard/yard_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/dashboard_utils/shared/constants/defaults.dart';

class YardAreaDashboard extends StatefulWidget {
  YardAreaDashboard({super.key});

  @override
  State<YardAreaDashboard> createState() => _YardAreaDashboardState();
}

class _YardAreaDashboardState extends State<YardAreaDashboard> {
  // Define lists for job card statuses and their corresponding values (replace with actual data)
  late List<BarData> barData;

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  late List<BarData> inBoundData;

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  late List<BarData> outBoundData;

  late List<BarData> loadingVehiclesData;

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  late List<BarData> unloadingVehiclesData;

  late List<AnalogChartData> avgYardTime;

  late List<AnalogChartData> loadingUnloadingCount;

  late List<ChartData> chartData;

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
    double aspectRatio = size.width / size.height;
    return BlocBuilder<DashboardsBloc, DashboardsState>(
      builder: (context, state) {
        bool isEnabled = state.getYardDashboardState != YardDashboardState.success;

        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Customs.DashboardWidget(
                      size: Size(size.width * 0.25, size.height * 0.45),
                      margin: aspectRatio * 10,
                      loaderEnabled: isEnabled,
                      chartBuilder: (ratio) {
                        return Customs.WMSCartesianChart(
                            title: 'Vehicle Detention',
                            titleFontSize: ratio*13,
                            xlabelFontSize: ratio * 10,
                            ylabelFontSize: ratio * 10,
                            ytitleFontSize: ratio * 12,
                            barCount: 1,
                            barColors: [Color.fromRGBO(132, 142, 230, 1)],
                            dataSources: [
                              [
                                BarData(
                                    xLabel: '<1 day',
                                    yValue: isEnabled ? 10 : state.yardDashboardData!.yardDetention!.singleDayCount!.toInt(),
                                    abbreviation: '<1 day'),
                                BarData(
                                    xLabel: '1-7 days',
                                    yValue: isEnabled ? 6 : state.yardDashboardData!.yardDetention!.count1To7Days!.toInt(),
                                    abbreviation: '1-7 days'),
                                BarData(
                                    xLabel: '>7 days',
                                    yValue: isEnabled ? 20 : state.yardDashboardData!.yardDetention!.countGreaterThan7Days!.toInt(),
                                    abbreviation: '>7 days'),
                              ]
                            ],
                            yAxisTitle: 'Number of Vehicles',
                            legendVisibility: false);
                      }),
                  Customs.DashboardWidget(
                      size: Size(size.width * 0.25, size.height * 0.45),
                      margin: aspectRatio * 10,
                      loaderEnabled: isEnabled,
                      chartBuilder: (ratio) {
                        return Customs.WMSSfCircularChart(
                          ratio: ratio,
                          series: SeriesName.pieSeries,
                          title: 'Yard Utilization',
                          titleFontSize: ratio*13,
                          legendVisibility: true,
                          props: Props(dataSource: [
                            PieData(
                                xData: "Available",
                                yData: isEnabled
                                    ? 10
                                    : (state.yardDashboardData!.yardUtilization!.totalLocations! - state.yardDashboardData!.yardUtilization!.occupied!),
                                text: isEnabled
                                    ? 'String'
                                    : (state.yardDashboardData!.yardUtilization!.totalLocations! - state.yardDashboardData!.yardUtilization!.occupied!)
                                        .toString()),
                            PieData(
                                xData: "Occupied",
                                yData: isEnabled ? 20 : state.yardDashboardData!.yardUtilization!.occupied!,
                                text: isEnabled ? 'String' : (state.yardDashboardData!.yardUtilization!.occupied!).toString())
                          ], radius: '${ratio * 70}%', labelFontSize: ratio * 10),
                        );
                      }),
                  Customs.DashboardWidget(
                      size: Size(size.width * 0.25, size.height * 0.45),
                      margin: aspectRatio * 10,
                      loaderEnabled: isEnabled,
                      chartBuilder: (ratio) {
                        return Customs.WMSCartesianChart(
                            title: 'Daywise Yard Utilization',
                            titleFontSize: ratio*13,
                            xlabelFontSize: ratio * 10,
                            ylabelFontSize: ratio * 10,
                            ytitleFontSize: ratio * 12,
                            barCount: 2,
                            barColors: [const Color.fromARGB(255, 231, 142, 247), const Color.fromARGB(255, 194, 162, 103)],
                            legendVisibility: true,
                            yAxisTitle: 'Number of Vehicles',
                            dataSources: [
                              state.yardDashboardData!.dayWiseYardUtilzation!
                                  .map(
                                    (e) => BarData(xLabel: e.checkInDate!, yValue: e.loadingCnt!, abbreviation: e.checkInDate!),
                                  )
                                  .toList(),
                              state.yardDashboardData!.dayWiseYardUtilzation!
                                  .map(
                                    (e) => BarData(xLabel: e.checkInDate!, yValue: e.unloadingCnt!, abbreviation: e.checkInDate!),
                                  )
                                  .toList()
                            ]);
                      }),
                ],
              ),
              Row(
                children: [
                  Customs.DashboardWidget(
                      size: Size(size.width * 0.25, size.height * 0.45),
                      margin: aspectRatio * 10,
                      loaderEnabled: isEnabled,
                      chartBuilder: (ratio) {
                        return Customs.WMSSfCircularChart(
                            ratio: ratio,
                            title: "Previous month yard acitvity",
                            titleFontSize: ratio*13,
                            series: SeriesName.radialBar,
                            props: Props(
                              dataSource: [
                                PieData(xData: 'Loading', yData: state.yardDashboardData!.previousMonthYardUtilization!.loadingCount!.toDouble()),
                                PieData(xData: 'Unloading', yData: state.yardDashboardData!.previousMonthYardUtilization!.unloadingCount!.toDouble()),
                              ],
                              labelFontSize: ratio * 10,
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
              ),
            ],
          ),
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
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
                  Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, lsize) {
                          return isEnabled
                      ? Customs.DashboardLoader(lsize: lsize)
                      : Customs.WMSCartesianChart(
                              title: 'Vehicle Detention',
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
                        }
                      )),
                  Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, lsize) {
                          return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Customs.WMSPieChart(
                            title: 'Yard Utilization',
                            dataSource: [
                              PieData(
                                  xData: "Available Locations",
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
                            ],
                            legendVisibility: true,
                            pointColorMapper: (piedata, index) {
                              if (index == 0) {
                                return Color.fromRGBO(136, 241, 245, 1);
                              } else if (index == 1) {
                                return Color.fromRGBO(100, 178, 180, 1);
                              }
                            },
                          );
                        }
                      )),
                  Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, lsize) {
                          return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Customs.WMSCartesianChart(
                              title: 'Daywise Yard Utilization',
                              barCount: 2,
                              barColors: [const Color.fromARGB(255, 231, 142, 247), const Color.fromARGB(255, 194, 162, 103)],
                              legendVisibility: true,
                              yAxisTitle: 'Number of Vehicles',
                              dataSources: [state.yardDashboardData!.dayWiseYardUtilzation!
                                        .map(
                                          (e) => BarData(xLabel: e.checkInDate!, yValue: e.loadingCnt!, abbreviation: e.checkInDate!),
                                        )
                                        .toList(), state.yardDashboardData!.dayWiseYardUtilzation!
                                        .map(
                                          (e) => BarData(xLabel: e.checkInDate!, yValue: e.unloadingCnt!, abbreviation: e.checkInDate!),
                                        )
                                        .toList()]
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
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, lsize) {
                          return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Customs.WMSSfCircularChart(
                              title: "Previous month yard acitvity",
                              series: SeriesName.radialBar,
                              props: Props(
                                dataSource: [
                                          PieData(xData: 'Loading',yData: state.yardDashboardData!.previousMonthYardUtilization!.loadingCount!.toDouble()),
                                          PieData(xData: 'Unloading',yData: state.yardDashboardData!.previousMonthYardUtilization!.unloadingCount!.toDouble()),
                                        ],
                                innerRadius: '30%',
                                labelFontSize: lsize.maxHeight*0.04,
                                pointColorMapper: (p0, p1) {
                                  if (p1 == 0) {
                                      return Color.fromRGBO(132, 211, 86, 1);
                                    } else {
                                      return const Color.fromARGB(255, 215, 221, 124);
                                    }
                                },
                              )
                            );
                        }
                      ))
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
// models for charts
// class PieData {
//   PieData(this.xData, this.yData, [this.text]);
//   final String xData;
//   final num yData;
//   String? text;
// }

// class BarData {
//   String xLabel;
//   int yValue;
//   String abbreviation;
//   BarData({required this.xLabel, required this.yValue, required this.abbreviation});
// }


// class AnalogChartData {
//         AnalogChartData(this.x, this.y, this.color);
//             final String x;
//             final double y;
//             final Color color;
//     }
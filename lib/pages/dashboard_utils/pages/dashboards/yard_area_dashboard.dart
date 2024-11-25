import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';
import 'package:warehouse_3d/bloc/yard/yard_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class YardAreaDashboard extends StatefulWidget {
  YardAreaDashboard({super.key});

  static Widget WMSCartesianChart(
      {String title = "title",
      int barCount = 1,
      List<List<BarData>>? dataSources,
      String yAxisTitle = "title",
      Color? primaryColor,
      Color? secondaryColor,
      List<String>? legendText,
      bool? isLegendVisible,
      int? spacing}) {
    return SfCartesianChart(
        title: ChartTitle(
            text: title,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        legend: isLegendVisible != null
            ? Legend(alignment: ChartAlignment.near, isVisible: isLegendVisible ?? false, isResponsive: true, position: LegendPosition.bottom)
            : const Legend(),
        onLegendItemRender: (legendRenderArgs) {
          if (legendText != null) {
            legendRenderArgs.text = legendText[legendRenderArgs.seriesIndex!];
          }
        },
        primaryXAxis: const CategoryAxis(
          labelStyle: TextStyle(color: Colors.black, fontSize: 16),
          majorGridLines: MajorGridLines(
            width: 0,
          ),
          majorTickLines: MajorTickLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: yAxisTitle),
        ),
        plotAreaBorderWidth: 0,
        borderWidth: 0,
        series: List.generate(
          barCount,
          (index) => ColumnSeries<BarData, String>(
            dataSource: dataSources![index],
            xValueMapper: (BarData data, _) => data.xLabel,
            yValueMapper: (BarData data, _) => data.yValue,
            borderRadius: BorderRadius.circular(10),
            spacing: 0.1,
            color: (primaryColor == null && secondaryColor == null)
                ? Colors.blueAccent
                : (secondaryColor == null)
                    ? primaryColor
                    : index == 0
                        ? primaryColor
                        : secondaryColor,
            dataLabelMapper: (datum, index) => datum.yValue.toString(),
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                useSeriesColor: true,
                builder: (data, point, series, pointIndex, seriesIndex) {
                  return Text(
                    (data as BarData).yValue.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  );
                }),
            width: 0.6,
          ),
        ));
  }

  static Widget WMSPieChart({String title = "title", List<PieData>? dataSource, Color? Function(PieData, int)? pointColorMapper}) {
    return SfCircularChart(
        title: ChartTitle(
            text: title,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        legend: const Legend(
          isVisible: true,
          alignment: ChartAlignment.near,
        ),
        series: <PieSeries<PieData, String>>[
          PieSeries<PieData, String>(
            explode: true,
            explodeIndex: 0,
            dataSource: dataSource,
            pointColorMapper: pointColorMapper,
            xValueMapper: (PieData data, _) => data.xData,
            yValueMapper: (PieData data, _) => data.yData,
            dataLabelMapper: (PieData data, _) => data.text,
            enableTooltip: true,
            dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                textStyle: TextStyle(fontSize: 24),
                labelAlignment: ChartDataLabelAlignment.top),
          ),
        ]);
  }

  static Widget WMSSfCircularChart(
      {required List<AnalogChartData> chartData,
      String? title,
      String? contentText,
      required Size size,
      double? height,
      double? width,
      String? radius,
      Color? textColor}) {
    return SfCircularChart(
      title: ChartTitle(text: title ?? "title"),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Container(
            width: width ?? 100,
            height: height ?? 160,
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
              contentText ?? "chart",
              style: TextStyle(
                color: textColor ?? const Color.fromARGB(255, 101, 10, 10),
                fontSize: 25,
              ),
            ),
          ),
        ),
      ],
      series: <CircularSeries>[
        DoughnutSeries<AnalogChartData, String>(
          dataSource: chartData,
          xValueMapper: (AnalogChartData data, _) => data.x,
          yValueMapper: (AnalogChartData data, _) => data.y,
          radius: radius ?? '50%', // Adjust the radius as needed
          innerRadius: '20%', // Optional: adjust for a thinner ring
          pointColorMapper: (AnalogChartData data, _) => data.color,
        )
      ],
    );
  }

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
                                return Color.fromRGBO(255, 182, 24, 1);
                              } else if (index == 1) {
                                return Color.fromRGBO(161, 40, 40, 0.8);
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
                            : YardAreaDashboard.WMSCartesianChart(
                              title: 'Daywise Yard Utilization',
                              primaryColor: Colors.blueAccent,
                              secondaryColor: const Color.fromARGB(255, 138, 40, 155),
                              barCount: 2,
                              isLegendVisible: true,
                              legendText: ["Loading", "Unloading"],
                              dataSources: [
                                isEnabled
                                    ? []
                                    : state.yardDashboardData!.dayWiseYardUtilzation!
                                        .map(
                                          (e) => BarData(xLabel: e.checkInDate!, yValue: e.loadingCnt!, abbreviation: e.checkInDate!),
                                        )
                                        .toList(),
                                isEnabled
                                    ? []
                                    : state.yardDashboardData!.dayWiseYardUtilzation!
                                        .map(
                                          (e) => BarData(xLabel: e.checkInDate!, yValue: e.unloadingCnt!, abbreviation: e.checkInDate!),
                                        )
                                        .toList()
                              ],
                              yAxisTitle: 'Number of Vehicles');
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
                            : SfCircularChart(
                              title: ChartTitle(text: "Previous month yard acitvity", textStyle: TextStyle(fontWeight: FontWeight.bold)),
                              legend: Legend(isResponsive: true, isVisible: true),
                              series: <CircularSeries>[
                                // Renders radial bar chart
                                RadialBarSeries<ChartData, String>(
                                  dataSource: isEnabled
                                      ? []
                                      : [
                                          ChartData('Loading', state.yardDashboardData!.previousMonthYardUtilization!.loadingCount!.toDouble()),
                                          ChartData('Unloading', state.yardDashboardData!.previousMonthYardUtilization!.unloadingCount!.toDouble()),
                                        ],
                                  cornerStyle: CornerStyle.bothCurve,
                                  innerRadius: "45%",
                                  dataLabelSettings: DataLabelSettings(
                                      // Renders the data label
                                            
                                      isVisible: true,
                                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                                      alignment: ChartAlignment.near),
                                  name: "Loading and Unloading Count",
                                  pointColorMapper: (datum, index) {
                                    if (datum.x == "Loading") {
                                      return Color.fromRGBO(187, 44, 42, 1);
                                    } else {
                                      return const Color.fromRGBO(255, 166, 0, 1);
                                    }
                                  },
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                )
                              ]);
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
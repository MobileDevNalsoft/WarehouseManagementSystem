import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/ghaps.dart';

import '../../shared/widgets/section_title.dart';
import '../../theme/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Overview extends StatelessWidget {
  Overview({super.key});

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
  List<BarData> inBoundData = [
    BarData(xLabel: 'Mon', yValue: 4, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 6, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 9, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 5, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 18, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 12, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 9, abbreviation: 'Sunday')
  ];

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> outBound = [
    BarData(xLabel: 'Mon', yValue: 6, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 8, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 15, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 7, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 10, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: const BoxDecoration(
        color: Color.fromARGB(95, 154, 152, 152),
        borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Gap(size.width * 0.05),
              Container(
                height: size.height*0.4,
                width: size.width*0.3,
               decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                borderRadius: BorderRadius.circular(10),
                color:Colors.white

               ),
                child: SfCircularChart(
                    title: const ChartTitle(text: 'Trucks Info',textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                       decoration: TextDecoration.underline,
                       decorationStyle: TextDecorationStyle.solid
                      
                    )),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                    ),
                    legend: const Legend(
                      isVisible: true,
                      alignment: ChartAlignment.near,
                    ),
                    series: <PieSeries<_PieData, String>>[
                      PieSeries<_PieData, String>(
                          explode: true,
                          explodeIndex: 0,
                          pointColorMapper: (datum, index) {
                            if(datum.text == '16'){
                              return const Color.fromARGB(255, 159, 238, 161);
                            }else{
                              return const Color.fromARGB(255, 182, 62, 53);
                            }
                          },
                          dataSource: [_PieData("Available", 16, "16"), _PieData("Occupied", 4, "4")],
                          xValueMapper: (_PieData data, _) => data.xData,
                          yValueMapper: (_PieData data, _) => data.yData,
                          dataLabelMapper: (_PieData data, _) => data.text,
                          enableTooltip: true,
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                              textStyle: TextStyle(fontSize: 24),
                              labelAlignment: ChartDataLabelAlignment.top)),
                    ]),
              ),
              Gap(size.width * 0.05),
              
              Container(
                height: size.height*0.4,
                width: size.width*0.3,
               decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                borderRadius: BorderRadius.circular(10),
                color:Colors.white

               ),
                child: SfCartesianChart(
                    title: const ChartTitle(text: 'Daywise In Bound and Out Bound',textStyle: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      
                    )),
                    primaryXAxis: const CategoryAxis(
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      majorGridLines: MajorGridLines(
                        width: 0,
                      ),
                      majorTickLines: MajorTickLines(width: 0),
                      axisLine: AxisLine(width: 0),
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Number of Vehicles'),
                
                    ),
                    plotAreaBorderWidth: 0,
                    // tooltipBehavior: TooltipBehavior(
                    //   enable: true,
                    //   color: Colors.black,
                    //   textStyle: const TextStyle(color: Colors.black),
                    //   textAlignment: ChartAlignment.center,
                    //   animationDuration: 100,
                    //   duration: 2000,
                    //   shadowColor: Colors.black,
                    //   builder: (data, point, series, pointIndex, seriesIndex) => IntrinsicWidth(
                    //     child: Container(
                    //         height: size.height * 0.01,
                    //         margin: EdgeInsets.only(
                    //             left: size.width * 0.03, right: size.width * 0.03,),
                    //         child: Text((data as BarData).abbreviation, style: TextStyle(color: Colors.white),)),
                    //   ),
                    // ),
                    borderWidth: 0,
                    series: [
                      ColumnSeries<BarData, String>(
                        dataSource: inBoundData,
                        xValueMapper: (BarData data, _) => data.xLabel,
                        yValueMapper: (BarData data, _) => data.yValue,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlue,
                        dataLabelMapper: (datum, index) => datum.yValue.toString(),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                          builder: (data, point, series, pointIndex, seriesIndex) => Text(
                            (data as BarData).yValue.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        width: 0.6,
                      ),
                      ColumnSeries<BarData, String>(
                        dataSource: outBound,
                        xValueMapper: (BarData data, _) => data.xLabel,
                        yValueMapper: (BarData data, _) => data.yValue,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent,
                        dataLabelMapper: (datum, index) => datum.yValue.toString(),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                          builder: (data, point, series, pointIndex, seriesIndex) => Text(
                            (data as BarData).yValue.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        width: 0.6,
                      )
                    ]),
              ),
            ],
          ),
          Gap(size.height * 0.1),
          Row(
            children: [
              Gap(size.width * 0.05),
               Container(
                height: size.height*0.4,
                width: size.width*0.3,
               decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                borderRadius: BorderRadius.circular(10),
                color:Colors.white

               ),
                child: SfCartesianChart(
                    title: const ChartTitle(text: 'Daywise Vehicle Engagement',textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                       decoration: TextDecoration.underline,
                      
                    )),
                    primaryXAxis: const CategoryAxis(
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      majorGridLines: MajorGridLines(
                        width: 0,
                      ),
                      majorTickLines: MajorTickLines(width: 0),
                      axisLine: AxisLine(width: 0),
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Number of Vehicles'),
                    ),
                    plotAreaBorderWidth: 0,
                    // tooltipBehavior: TooltipBehavior(
                    //   enable: true,
                    //   color: Colors.black,
                    //   textStyle: const TextStyle(color: Colors.black),
                    //   textAlignment: ChartAlignment.center,
                    //   animationDuration: 100,
                    //   duration: 2000,
                    //   shadowColor: Colors.black,
                    //   builder: (data, point, series, pointIndex, seriesIndex) => IntrinsicWidth(
                    //     child: Container(
                    //         height: size.height * 0.01,
                    //         margin: EdgeInsets.only(
                    //             left: size.width * 0.03, right: size.width * 0.03,),
                    //         child: Text((data as BarData).abbreviation, style: TextStyle(color: Colors.white),)),
                    //   ),
                    // ),
                    borderWidth: 0,
                    series: [
                      ColumnSeries<BarData, String>(
                        dataSource: barData,
                        xValueMapper: (BarData data, _) => data.xLabel,
                        yValueMapper: (BarData data, _) => data.yValue,
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 127, 62, 62),
                        dataLabelMapper: (datum, index) => datum.yValue.toString(),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                          builder: (data, point, series, pointIndex, seriesIndex) => Text(
                            (data as BarData).yValue.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                        width: 0.6,
                      )
                    ]),
              ),
              Gap(size.width * 0.05),
               Container(
                height: size.height*0.4,
                width: size.width*0.3,
               decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                borderRadius: BorderRadius.circular(10),
                color:Colors.white

               ),
                child: SfCircularChart(
                    title: const ChartTitle(text: 'In Bound vs Out Bound',textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                       decoration: TextDecoration.underline,
                    )),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                    ),
                    legend: const Legend(
                      isVisible: true,
                      alignment: ChartAlignment.near,
                    ),
                    series: <PieSeries<_PieData, String>>[
                      PieSeries<_PieData, String>(
                          explode: true,
                          explodeIndex: 0,
                          dataSource: [_PieData("Total", 10, "10"), _PieData("Active", 4, "4")],
                          xValueMapper: (_PieData data, _) => data.xData,
                          yValueMapper: (_PieData data, _) => data.yData,
                          dataLabelMapper: (_PieData data, _) => data.text,
                          enableTooltip: true,
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                              textStyle: TextStyle(fontSize: 24),
                              labelAlignment: ChartDataLabelAlignment.top)),
                    ]),
              ),
            ],
          )
          // const OverviewTabs(),
        ],
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  String? text;
}

class BarData {
  String xLabel;
  int yValue;
  String abbreviation;
  BarData({required this.xLabel, required this.yValue, required this.abbreviation});
}

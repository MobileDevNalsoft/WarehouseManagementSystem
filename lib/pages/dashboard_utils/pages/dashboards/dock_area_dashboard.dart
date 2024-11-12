import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class DockAreaDashboard extends StatelessWidget {
  DockAreaDashboard({super.key});

  List<BarData> dockINDayWiseDataSource = [
    BarData(xLabel: 'Mon', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 6, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 3, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 2, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  List<BarData> dockOUTDayWiseDataSource = [
    BarData(xLabel: 'Mon', yValue: 4, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 6, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 9, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 5, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 18, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 12, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 9, abbreviation: 'Sunday')
  ];

  final List<TimeData> chartData1 = [
    TimeData('David', 81, const Color.fromRGBO(183, 200, 224, 1)),
    TimeData('sd', 19, Colors.transparent),
  ];

  List<PieDataM> dockINDataSource = [PieDataM(xData: "Utilized Docks",yData:  3, color: const Color.fromARGB(255, 181, 166, 221)), PieDataM(xData: "Avalable Docks",yData:  6, color: const Color.fromARGB(255, 238, 236, 135))];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]
                      ),
                      padding: EdgeInsets.all(size.height*0.035),
                      alignment: Alignment.bottomCenter,
                      child: Customs.WMSCartesianChart(
                        title: "Daywise Utilization",
                              yAxisTitle: 'Number of Vehicles', barCount: 2, barColors: [Colors.teal, Colors.greenAccent], dataSources: [dockINDayWiseDataSource, dockOUTDayWiseDataSource]),
                    ),
                    Container(
                    margin: EdgeInsets.all(aspectRatio * 8),
                    height: size.height * 0.45,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                    padding: EdgeInsets.all(size.height * 0.035),
                    alignment: Alignment.topCenter,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Dock-IN Utilization',
                        alignment: ChartAlignment.near,
                        textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                      ),
                      legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                      series: <CircularSeries>[
                        // Renders radial bar chart
                          
                        DoughnutSeries<PieDataM, String>(
                          dataSource: dockINDataSource,
                          dataLabelSettings: const DataLabelSettings(
                              // Renders the data label
                              isVisible: true,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.near),
                          pointColorMapper: (datum, index) {
                            return dockINDataSource[index].color;
                          },
                          xValueMapper: (PieDataM data, _) => data.xData,
                          yValueMapper: (PieDataM data, _) => data.yData,
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
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                    padding: EdgeInsets.all(size.height * 0.035),
                    alignment: Alignment.topCenter,
                    child: SfCircularChart(
                      title: ChartTitle(
                        text: 'Dock-OUT Utilization',
                        alignment: ChartAlignment.near,
                        textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                      ),
                      legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                      series: <CircularSeries>[
                        // Renders radial bar chart
                          
                        DoughnutSeries<PieDataM, String>(
                          dataSource: dockINDataSource,
                          dataLabelSettings: const DataLabelSettings(
                              // Renders the data label
                              isVisible: true,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                              alignment: ChartAlignment.near),
                          pointColorMapper: (datum, index) {
                            return dockINDataSource[index].color;
                          },
                          xValueMapper: (PieDataM data, _) => data.xData,
                          yValueMapper: (PieDataM data, _) => data.yData,
                        )
                      ],
                    ),
                  ),
                    Container(
                              margin: EdgeInsets.all(aspectRatio * 8),
                              height: size.height * 0.45,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                              child: SfCircularChart(
                                title: ChartTitle(
                                    text: "Avg Loading Time",
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
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                              child: SfCircularChart(
                                title: ChartTitle(
                                    text: "Avg Unloading Time",
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
                  Container(
                              margin: EdgeInsets.all(aspectRatio * 8),
                              height: size.height * 0.45,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                              child: SfCircularChart(
                                title: ChartTitle(
                                    text: "Avg Dock TAT",
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
                )
                // Container(
                //   height: size.height * 0.5,
                //   width: size.width * 0.62,
                //   margin: EdgeInsets.all(aspectRatio * 8),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //         borderRadius: BorderRadius.circular(20),
                //         boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]
                //   ),
                //   alignment: Alignment.bottomCenter,
                //   child: LayoutBuilder(builder: (context, constraints) {
                //     return Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Gap(size.height * 0.004),
                //         Text(
                //           textAlign: TextAlign.center,
                //           'Appointments',
                //           style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                //         ),
                //         SfCalendar(
                //             view: CalendarView.month,
                //           )
                //       ],
                //     );
                //   }),
                // ),
              ],
            )
          ),
        ),
        Container(
          width: size.width*0.19,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 163, 172, 177),
            borderRadius: BorderRadius.all(Radius.circular(30)),
             boxShadow: [BoxShadow(color: Colors.grey.shade600, offset: Offset(-1,0), blurRadius: 5, spreadRadius: 0)]
          ),
          padding: EdgeInsets.all(size.height*0.02),
          child: ListView.builder(itemBuilder: (context, index) => Column(),),
        )
      ],
    );
  }
}

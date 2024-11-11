import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
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

  List<PieData> dockINDataSource = [PieData("Utilized Docks", 3), PieData("Avalable Docks", 6)];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.4,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Gap(size.height * 0.004),
                            Text(
                              textAlign: TextAlign.center,
                              'Daywise Utilization',
                              style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                            ),
                            Container(
                                height: size.height * 0.32,
                                width: size.width * 0.25,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                child: Customs.WMSCartesianChart(
                                    yAxisTitle: 'Number of Vehicles', barCount: 2, dataSources: [dockINDayWiseDataSource, dockOUTDayWiseDataSource])),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height * 0.4,
                        width: size.width * 0.36,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Gap(size.height * 0.004),
                              Text(
                                textAlign: TextAlign.center,
                                "Today's Utilization",
                                style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: constraints.maxHeight * 0.8,
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(aspectRatio * 4),
                                      child: Customs.WMSPieChart(
                                          title: "IN",
                                          dataSource: dockINDataSource,
                                          pointColorMapper: (datum, index) {
                                            if (index == 1) {
                                              return const Color.fromARGB(255, 159, 238, 161);
                                            } else {
                                              return const Color.fromARGB(255, 182, 62, 53);
                                            }
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(aspectRatio * 4),
                                      child: Customs.WMSPieChart(
                                          title: "OUT",
                                          dataSource: dockINDataSource,
                                          pointColorMapper: (datum, index) {
                                            if (index == 1) {
                                              return const Color.fromARGB(255, 159, 238, 161);
                                            } else {
                                              return const Color.fromARGB(255, 182, 62, 53);
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  Container(
                    height: size.height * 0.5,
                    width: size.width * 0.62,
                    margin: EdgeInsets.all(aspectRatio * 8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Gap(size.height * 0.004),
                          Text(
                            textAlign: TextAlign.center,
                            'Appointments',
                            style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: constraints.maxHeight * 0.8,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: SfCalendar(
                              view: CalendarView.month,
                              headerHeight: 0,
                            ),
                          ),
                        ],
                      );
                    }),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: aspectRatio * 8, top: aspectRatio * 8, bottom: aspectRatio * 8),
                height: size.height * 0.93,
                width: size.width * 0.175,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.25,
                      width: size.width * 0.14,
                      margin: EdgeInsets.all(aspectRatio * 8),
                      padding: EdgeInsets.all(aspectRatio * 8),
                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                      child: SfRadialGauge(
                          title: const GaugeTitle(text: 'Avg Loading Time', textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 60, ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 60,
                                  gradient: const SweepGradient(colors: [Colors.green, Colors.red], stops: [0.6, 1]),
                                  startWidth: 20,
                                  endWidth: 20),
                            ], pointers: const <GaugePointer>[
                              NeedlePointer(
                                value: 30,
                                enableAnimation: true,
                              )
                            ], annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Text('30 mins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), angle: 90, positionFactor: 0.8, verticalAlignment: GaugeAlignment.near,)
                            ])
                          ]),
                    ),
                    Container(
                      height: size.height * 0.25,
                      width: size.width * 0.14,
                      margin: EdgeInsets.all(aspectRatio * 8),
                      padding: EdgeInsets.all(aspectRatio * 8),
                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                      child: SfRadialGauge(
                          title: const GaugeTitle(text: 'Avg Unloading Time', textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 60, ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 60,
                                  gradient: const SweepGradient(colors: [Colors.green, Colors.red], stops: [0.6, 1]),
                                  startWidth: 20,
                                  endWidth: 20),
                            ], pointers: const <GaugePointer>[
                              NeedlePointer(
                                value: 30,
                                enableAnimation: true,
                              )
                            ], annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Text('30 mins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), angle: 90, positionFactor: 0.8, verticalAlignment: GaugeAlignment.near,)
                            ])
                          ]),
                    ),
                    Container(
                      height: size.height * 0.25,
                      width: size.width * 0.14,
                      margin: EdgeInsets.all(aspectRatio * 8),
                      padding: EdgeInsets.all(aspectRatio * 8),
                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                      child: SfRadialGauge(
                          title: const GaugeTitle(text: 'Avg TAT', textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 60, ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 60,
                                  gradient: const SweepGradient(colors: [Colors.green, Colors.red], stops: [0.6, 1]),
                                  startWidth: 20,
                                  endWidth: 20),
                            ], pointers: const <GaugePointer>[
                              NeedlePointer(
                                value: 30,
                                enableAnimation: true,
                              )
                            ], annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Text('30 mins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), angle: 90, positionFactor: 0.8, verticalAlignment: GaugeAlignment.near,)
                            ])
                          ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}

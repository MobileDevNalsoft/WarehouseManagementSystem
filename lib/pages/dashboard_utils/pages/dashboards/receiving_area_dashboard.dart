import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauge;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class ReceivingAreaDashboard extends StatelessWidget {
  ReceivingAreaDashboard({super.key});

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

  List<BarData> barData1 = [
    BarData(xLabel: 'Oracle', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: 'Nalsoft', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: 'ABC', yValue: 6, abbreviation: 'Wednesday'),
  ];

  List<BarData> barData2 = [
    BarData(xLabel: 'ABC', yValue: 10, abbreviation: ''),
    BarData(xLabel: 'XYZ', yValue: 4, abbreviation: ''),
    BarData(xLabel: 'SPD', yValue: 6, abbreviation: ''),
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
  List<BarData> outBoundData = [
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
    final List<ChartData> chartData = [
      ChartData('David', 69, Color.fromRGBO(9, 0, 136, 1)),
      ChartData('sd',31, Colors.transparent),
    ];
    final List<ChartData> chartData1 = [
      ChartData('David', 81, Color.fromRGBO(91, 9, 9, 1)),
      ChartData('sd',19, Colors.transparent),
    ];

    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Gap(size.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Receiving Area Dashboard',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Gap(size.height * 0.03),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding * 1.5,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(95, 154, 152, 152),
                    borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
                  ),
                  child: Container(
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
                                height: size.height * 0.4,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Customs.WMSPieChart(
                                    title: "Total Inbound Summary",
                                    dataSource: [PieDataM(xData: "Open",yData:  16,text: "16"), PieDataM(xData: "In Receiving",yData:  4,text:  "4"), PieDataM(xData: "Received",yData:  5,text:  "5")],
                                    pointColorMapper: (datum, index) {
                                      if (datum.text == '16') {
                                        return const Color.fromARGB(255, 219, 165, 27);
                                      } else if (datum.text == '4') {
                                        return const Color.fromARGB(255, 163, 96, 2);
                                      } else {
                                        return const Color.fromARGB(255, 52, 129, 228);
                                      }
                                    }),
                                    Text("Inbound orders status wise ")
                                  ],
                                )),
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Customs.WMSPieChart(
                                    title: "Total ASN Status",
                                    dataSource: [
                                      PieDataM(xData: "In-Transit",yData:  8,text:  "8"),
                                      PieDataM(xData: "In Receiving",yData:  4,text:  "4"),
                                      PieDataM(xData: "Received",yData:  3,text:  "3"),
                                      PieDataM(xData: "Cancelled",yData:  1,text:  "1")
                                    ],
                                    pointColorMapper: (datum, index) {
                                      if (datum.text == '8') {
                                        return const Color.fromARGB(255, 27, 219, 219);
                                      } else if (datum.text == '4') {
                                        return const Color.fromARGB(255, 57, 33, 0);
                                      } else if (datum.text == '3') {
                                        return const Color.fromARGB(255, 38, 82, 113);
                                      } else {
                                        return const Color.fromARGB(255, 241, 114, 41);
                                      }
                                    })),
                            // Container(
                            //     height: size.height * 0.3,
                            //     width: size.width * 0.2,
                            //     decoration: BoxDecoration(
                            //         border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Colors.white),
                            //     child: Customs.WMSCartesianChart(
                            //         title: 'Daywise In Bound and Out Bound',
                            //         barCount: 2,
                            //         dataSources: [inBoundData, outBoundData],
                            //         yAxisTitle: 'Number of Vehicles')),

                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: _getRadialGauge()),
                          ],
                        ),
                        Gap(size.height * 0.1),
                        Row(
                          children: [
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Customs.WMSCartesianChart(
                                    title: 'Day Wise Inbound Summary  ',
                                    barCount: 1,
                                    dataSources: [barData],
                                    yAxisTitle: 'No of ASNs Received',
                                    barColors: const [Color.fromARGB(255, 248, 190, 15)])),
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Customs.WMSCartesianChart(
                                    title: 'Supplier Wise Inbound Summary  ',
                                    barCount: 1,
                                    dataSources: [barData1],
                                    yAxisTitle: 'No of ASNs Received',
                                    barColors: const [Color.fromARGB(255, 248, 112, 15)])),
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Customs.WMSCartesianChart(
                                    title: 'User Receiving Efficiency  ',
                                    barCount: 1,
                                    dataSources: [barData2],
                                    yAxisTitle: 'No of LPNs Received',
                                    barColors: const [Color.fromARGB(255, 15, 123, 189)])),
                          ],
                        ),
                        Gap(size.height * 0.1),
                        Row(
                          children: [
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: SfCircularChart(
                                  title: ChartTitle(text: "Avg Receiving Time",textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: Container(
                                        width: 100, // Set the size of the shadowed circle
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color.fromARGB(255, 232, 229, 229),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              offset: Offset(0, 4), // Adjust to set shadow direction
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CircularChartAnnotation(
                                      widget: Container(
                                        child: const Text(
                                          '05h:32m',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 101, 10, 10),
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      radius: '60%', // Adjust the radius as needed
                                      innerRadius: '40%', // Optional: adjust for a thinner ring
                                      pointColorMapper: (ChartData data, _) => data.color,
                                    )
                                  ],
                                )),
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Stack(
                                  children: [
                                    SfRadialGauge(
                                      title: GaugeTitle(text: "Receiving Efficiency",textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            )),
                                  enableLoadingAnimation: true,
                                  animationDuration: 2000,
                                  axes: <RadialAxis>[

                                  
                                    RadialAxis(
                                      centerX: 0.5,
                                      centerY: 0.6,
                                      

                                      startAngle: 180,
                                      endAngle: 0,
                                       labelsPosition: ElementsPosition.outside, 
                                      showLabels: true,
                                      showAxisLine: false,
                                      showTicks: false,
                                      showLastLabel: true,
                                      
                                      
                                      minimum: 0, maximum: 100, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 50,
                color: const Color.fromARGB(255, 121, 43, 181),
                startWidth: 50,
                endWidth: 50),
                GaugeRange(
                startValue: 50,
                endValue: 100,
                color: const Color.fromARGB(255, 189, 200, 210),
                startWidth: 50,
                endWidth: 50),
                                    ])
                                  ],
                                ),

                                Positioned(
                                 
                                  bottom: 100,
                                  right: 150,
                                  child: Text("50%"),
                                )
                                  ],
                                )),
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.3,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: SfCircularChart(
                                  title: ChartTitle(text: "Avg PutAway Time",textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                                  annotations: <CircularChartAnnotation>[
                                    CircularChartAnnotation(
                                      widget: Container(
                                        width: 100, // Set the size of the shadowed circle
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color.fromARGB(255, 232, 229, 229),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              offset: Offset(0, 4), // Adjust to set shadow direction
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CircularChartAnnotation(
                                      widget: Container(
                                        child: const Text(
                                          '03h:15m',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 20, 21, 22),
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: chartData1,
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      radius: '60%', // Adjust the radius as needed
                                      innerRadius: '40%', // Optional: adjust for a thinner ring
                                      pointColorMapper: (ChartData data, _) => data.color,
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getRadialGauge() {
    return gauge.SfRadialGauge(
        animationDuration: 2000,
        title: gauge.GaugeTitle(text: 'Putaway Accuracy', textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <gauge.RadialAxis>[
          gauge.RadialAxis(minimum: 0, maximum: 100, ranges: <gauge.GaugeRange>[
            gauge.GaugeRange(startValue: 0, endValue: 50, color: Colors.orange, startWidth: 10, endWidth: 10),
            gauge.GaugeRange(startValue: 50, endValue: 100, color: Colors.green, startWidth: 10, endWidth: 10),
            gauge.GaugeRange(startValue: 100, endValue: 150, color: Colors.red, startWidth: 10, endWidth: 10)
          ], pointers: <gauge.GaugePointer>[
            gauge.NeedlePointer(
              value: 90,
              enableAnimation: true,
              animationType: gauge.AnimationType.ease,
              animationDuration: 2000,
            )
          ], annotations: <gauge.GaugeAnnotation>[
            gauge.GaugeAnnotation(
                widget: Container(child: const Text('90 %', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))), angle: 90, positionFactor: 0.5)
          ])
        ]);
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

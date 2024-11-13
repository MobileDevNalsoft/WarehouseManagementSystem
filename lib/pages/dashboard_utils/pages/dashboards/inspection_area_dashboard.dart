import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauge;

class InspectionAreaDashboard extends StatelessWidget {
  InspectionAreaDashboard({super.key});

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
  List<BarData> barData_sup = [
    BarData(xLabel: 'Oracle', yValue: 45, abbreviation: 'oracle'),
    BarData(xLabel: 'Nalsoft', yValue: 63, abbreviation: 'nalsoft'),
    BarData(xLabel: 'Abc', yValue: 24, abbreviation: 'abc'),
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

  final List<ChartData> chartData = [
    ChartData('David', 45, Color.fromRGBO(3, 109, 97, 1)),
    ChartData('sd', 55, Colors.transparent),
  ];

  @override
  Widget build(BuildContext context) {
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
          Gap(constraints.maxHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Inspection Area Dashboard',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Gap(constraints.maxHeight * 0.03),
          Expanded(
            child: ListView(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: constraints.maxHeight * 0.4,
                              width: constraints.maxWidth * 0.43,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                  const  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                     
                                      color: Color.fromARGB(255, 69, 65, 61)
                                    )
                                  ],
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Customs.WMSPieChart(
                                  title:  ChartTitle(
                          text: 'Today Quality Status',
                          alignment: ChartAlignment.near,
                          textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),),
                                  dataSource: [PieData(xData: "Marked for QC",yData:  10,text:  "10"), PieData(xData: "QC Approved",yData:  6,text:  "6"), PieData(xData: "QC Rejected", yData: 3,text:  "3")],
                                  pointColorMapper: (datum, index) {
                                    if (datum.text == '10') {
                                      return const Color.fromARGB(255, 7, 72, 100);
                                    } else if (datum.text == '6') {
                                      return const Color.fromARGB(255, 84, 9, 4);
                                    } else {
                                      return const Color.fromARGB(255, 17, 208, 119);
                                    }
                                  })),
                          Container(
                              height: constraints.maxHeight * 0.4,
                              width: constraints.maxWidth * 0.43,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  const  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                     
                                      color: Color.fromARGB(255, 69, 65, 61)
                                    )
                                  ],
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: _getRadialGauge()),
                        ],
                      ),
                      Gap(constraints.maxHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: constraints.maxHeight * 0.4,
                              width: constraints.maxWidth * 0.43,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  const  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                     
                                      color: Color.fromARGB(255, 69, 65, 61)
                                    )
                                  ],
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: SfCircularChart(
                                title: ChartTitle(text: "Material Quality", textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                                        '45%',
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
                                    innerRadius: '45%', // Optional: adjust for a thinner ring
                                    pointColorMapper: (ChartData data, _) => data.color,
                                  )
                                ],
                              )),
                          Container(
                              height: constraints.maxHeight * 0.4,
                              width: constraints.maxWidth * 0.43,
                              decoration: BoxDecoration(
                                 boxShadow: [
                                  const  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                     
                                      color: Color.fromARGB(255, 69, 65, 61)
                                    )
                                  ],
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Customs.WMSCartesianChart(
                                  title: 'Day Wise Quality Summary  ',
                                  barCount: 1,
                                  dataSources: [barData],
                                  yAxisTitle: 'Quality Enabled LPNs',
                                  barColors: const [Color.fromARGB(255, 114, 68, 5)])),
                        ],
                      ),
                      Gap(constraints.maxHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: constraints.maxHeight * 0.4,
                              width: constraints.maxWidth * 0.43,
                              decoration: BoxDecoration(
                                 boxShadow: [
                                  const  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                     
                                      color: Color.fromARGB(255, 69, 65, 61)
                                    )
                                  ],
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.white),
                              child: Customs.WMSCartesianChart(
                                  title: 'Supplier Wise Quality  ',
                                  barCount: 1,
                                  dataSources: [barData_sup],
                                  yAxisTitle: 'Quality In Percentage',
                                  barColors: const [Color.fromARGB(255, 114, 68, 5)]))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _getRadialGauge() {
    return gauge.SfRadialGauge(
        animationDuration: 2000,
        title: gauge.GaugeTitle(text: 'Quality Efficiency', textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        axes: <gauge.RadialAxis>[
          gauge.RadialAxis(labelsPosition: gauge.ElementsPosition.outside, showLastLabel: true, minimum: 0, maximum: 100, ranges: <gauge.GaugeRange>[
            gauge.GaugeRange(startValue: 0, endValue: 50, color: const Color.fromARGB(255, 4, 112, 122), startWidth: 30, endWidth: 30),
            gauge.GaugeRange(startValue: 50, endValue: 100, color: const Color.fromARGB(255, 178, 123, 223), startWidth: 30, endWidth: 30),
          ], pointers: <gauge.GaugePointer>[
            gauge.NeedlePointer(
              value: 20,
              enableAnimation: true,
              animationType: gauge.AnimationType.ease,
              animationDuration: 2000,
            )
          ], annotations: <gauge.GaugeAnnotation>[
            gauge.GaugeAnnotation(
                widget: Container(child: const Text('20', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))), angle: 90, positionFactor: 0.5)
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

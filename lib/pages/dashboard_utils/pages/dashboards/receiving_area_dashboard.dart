import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as gauge;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class ReceivingAreaDashboard extends StatefulWidget {
  ReceivingAreaDashboard({super.key});

  @override
  State<ReceivingAreaDashboard> createState() => _ReceivingAreaDashboardState();
}

class _ReceivingAreaDashboardState extends State<ReceivingAreaDashboard> {
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

  late DashboardsBloc _dashboardsBloc;

  @override
  void initState() {
    super.initState();

    _dashboardsBloc = context.read<DashboardsBloc>();

    _dashboardsBloc.add(GetReceivingDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 69, const Color.fromRGBO(9, 0, 136, 1)),
      ChartData('sd', 31, Colors.transparent),
    ];
    final List<ChartData> chartData1 = [
      ChartData('David', 81, const Color.fromRGBO(91, 9, 9, 1)),
      ChartData('sd', 19, Colors.transparent),
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

      return Column(
        children: [
          Gap(constraints.maxHeight * 0.03),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receiving Area Dashboard',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Gap(constraints.maxHeight * 0.03),
          Expanded(
            child: ListView(
              children: [
                BlocBuilder<DashboardsBloc, DashboardsState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                              child: Customs.WMSPieChart(
                                  title: "Total ASN Status",
                                  dataSource: [
                                    PieData(xData: "In-Transit", yData: 8, text: "8"),
                                    PieData(xData: "In Receiving", yData: 4, text: "4"),
                                    PieData(xData: "Received", yData: 3, text: "3"),
                                    PieData(xData: "Cancelled", yData: 1, text: "1")
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
                                  }),
                            ),
                            Container(
                              margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                              child: Column(
                                  children: [
                                    Skeletonizer(
                                      enableSwitchAnimation: true,
                                      enabled: state.getReceivingDashboardState != ReceivingDashboardState.success,
                                      child: Customs.WMSPieChart(
                                          title: "Total Inbound Summary",
                                          dataSource: state.getReceivingDashboardState != ReceivingDashboardState.success ? [
                                            PieData(xData: "Open", yData: 16, text: "16"),
                                            PieData(xData: "In Receiving", yData: 4, text: "4"),
                                            PieData(xData: "Received", yData: 5, text: "5")
                                          ] : state.receivingDashboardData!.totalInBoundSummary!.map((e) => PieData(xData: e.status!, yData: e.total!, text: e.total!.toString())).toList(),
                                          pointColorMapper: (datum, index) {
                                            if (index == 0) {
                                              return const Color.fromARGB(255, 219, 165, 27);
                                            } else if (index == 1) {
                                              return const Color.fromARGB(255, 163, 96, 2);
                                            } else {
                                              return const Color.fromARGB(255, 52, 129, 228);
                                            }
                                          }),
                                    ),
                                    const Text("Inbound orders status wise ")
                                  ],
                                )
                            ),
                            Container(
                                margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                                child: _getRadialGauge()),
                          ],
                        ),
                        Gap(constraints.maxHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                                child: Customs.WMSCartesianChart(
                                    title: 'Day Wise Inbound Summary  ',
                                    barCount: 1,
                                    dataSources: [barData],
                                    yAxisTitle: 'No of ASNs Received',
                                    barColors: [const Color.fromARGB(255, 248, 190, 15)])),
                            Container(
                                margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                                child: Customs.WMSCartesianChart(
                                    title: 'Supplier Wise Inbound Summary  ',
                                    barCount: 1,
                                    dataSources: [barData1],
                                    yAxisTitle: 'No of ASNs Received',
                                    barColors: [const Color.fromARGB(255, 248, 112, 15)])),
                            Container(
                                margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                                child: Customs.WMSCartesianChart(
                                    title: 'User Receiving Efficiency  ',
                                    barCount: 1,
                                    dataSources: [barData2],
                                    yAxisTitle: 'No of LPNs Received',
                                    barColors: [const Color.fromARGB(255, 15, 123, 189)]))
                          ],
                        ),
                        Gap(constraints.maxHeight * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                                child: SfCircularChart(
                                  title: const ChartTitle(
                                      text: "Avg Receiving Time",
                                      textStyle: TextStyle(
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
                                              offset: const Offset(0, 4), // Adjust to set shadow direction
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
                            Container(
                                margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                                child: Stack(
                                  children: [
                                    SfRadialGauge(
                                      title: const GaugeTitle(
                                          text: "Receiving Efficiency",
                                          textStyle: TextStyle(
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
                                            minimum: 0,
                                            maximum: 100,
                                            ranges: <GaugeRange>[
                                              GaugeRange(startValue: 0, endValue: 50, color: const Color.fromARGB(255, 121, 43, 181), startWidth: 50, endWidth: 50),
                                              GaugeRange(
                                                  startValue: 50, endValue: 100, color: const Color.fromARGB(255, 189, 200, 210), startWidth: 50, endWidth: 50),
                                            ])
                                      ],
                                    ),
                                    const Positioned(
                                      bottom: 100,
                                      right: 150,
                                      child: Text("50%"),
                                    )
                                  ],
                                )),
                            Container(
                                margin: EdgeInsets.all(constraints.maxWidth / constraints.maxHeight * 8),
                              height: constraints.maxHeight * 0.48,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                              padding: EdgeInsets.all(size.height * 0.035),
                              alignment: Alignment.topCenter,
                                child: SfCircularChart(
                                  title: const ChartTitle(
                                      text: "Avg PutAway Time",
                                      textStyle: TextStyle(
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
                                              offset: const Offset(0, 4), // Adjust to set shadow direction
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
                    );
                  }
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
        title: const gauge.GaugeTitle(text: 'Putaway Accuracy', textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <gauge.RadialAxis>[
          gauge.RadialAxis(
            showLastLabel: true,
            labelsPosition: ElementsPosition.outside,
            minimum: 0, maximum: 100, ranges: <gauge.GaugeRange>[
            gauge.GaugeRange(startValue: 0, endValue: 50, color: Colors.orange, startWidth: 30, endWidth: 30),
            gauge.GaugeRange(startValue: 50, endValue: 100, color: Colors.green, startWidth: 30, endWidth: 30),
   
          ], pointers: <gauge.GaugePointer>[
            const gauge.NeedlePointer(
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

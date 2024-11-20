import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;

class StagingAreaDashboard extends StatefulWidget {
  StagingAreaDashboard({super.key});

  @override
  State<StagingAreaDashboard> createState() => _StagingAreaDashboardState();
}

class _StagingAreaDashboardState extends State<StagingAreaDashboard> {
  late Map<String, List<String>> employeeSuggestionRange;
  var random = Random();
  late bool rangeSelection;
  String selectedUserRange = "";
  late List<String> userSuggestions;
  List<String> selectedUsers = [];
  List<BarData> userEfficiencyGraphData = [];
  SuggestionsController suggestionsController = SuggestionsController();

  late TextEditingController typeAheadController;
  late FocusNode typeAheadFocusNode;

  List<BarData> supplierWiseDataSource = [
    BarData(xLabel: 'S1', yValue: 10, abbreviation: 'Supplier1'),
    BarData(xLabel: 'S2', yValue: 4, abbreviation: 'Supplier2'),
    BarData(xLabel: 'S3', yValue: 6, abbreviation: 'Supplier3'),
    BarData(xLabel: 'S4', yValue: 3, abbreviation: 'Supplier4'),
    BarData(xLabel: 'S5', yValue: 20, abbreviation: 'Supplier5'),
    BarData(xLabel: 'S6', yValue: 2, abbreviation: 'Supplier6'),
    BarData(xLabel: 'S7', yValue: 2, abbreviation: 'Supplier7')
  ];

  List<BarData> dayWiseOrderSummary = [
    BarData(xLabel: 'Mon', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 6, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 8, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 5, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 2, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  List<BarData> channelWiseOrderSummary = [
    BarData(xLabel: 'X', yValue: 10, abbreviation: 'channel  1'),
    BarData(xLabel: 'Y', yValue: 4, abbreviation: 'channel 2'),
    BarData(xLabel: 'Z', yValue: 6, abbreviation: 'channel 3'),
  ];

  List<PieData> locationUtilizationDataSource = [
    PieData(xData: "Occupied Bins", yData: 30, color: const Color.fromRGBO(232, 212, 162, 1)),
    PieData(xData: "Avalable Bins", yData: 6, color: const Color.fromRGBO(139, 182, 162, 1)),
    PieData(xData: "Full Bins", yData: 16, color: const Color.fromRGBO(255, 116, 106, 1))
  ];

  List<PieData> warehouseUtilizationDataSource = [
    PieData(xData: "Occupied Bins", yData: 300, color: const Color.fromARGB(255, 181, 166, 221)),
    PieData(xData: "Avalable Bins", yData: 60, color: const Color.fromARGB(255, 238, 236, 135)),
  ];

  List<PieData> inventorySummaryDataSource = [
    PieData(xData: "In Stock", yData: 456, color: const Color.fromARGB(255, 148, 224, 214)),
    PieData(xData: "Running Out of Stock", yData: 68, color: const Color.fromARGB(255, 184, 172, 149)),
    PieData(xData: "Out of Stock", yData: 26, color: const Color.fromARGB(255, 221, 152, 184))
  ];

  List<PieData> orderSummaryDataSource = [
    PieData(xData: "Created", yData: 778, color: const Color.fromARGB(255, 148, 215, 224), text: "778"),
    PieData(xData: "Allocated", yData: 368, color: const Color.fromARGB(255, 159, 196, 161), text: "368"),
    PieData(xData: "Picked", yData: 93, color: const Color.fromARGB(255, 180, 140, 164), text: "93"),
    PieData(xData: "Loaded", yData: 102, color: const Color.fromARGB(255, 180, 140, 164), text: "102"),
    PieData(xData: "Shipped", yData: 256, color: const Color.fromARGB(255, 180, 140, 164), text: "256")
  ];

  final List<TimeData> avgLeadTimeData = [
    TimeData('resukt', 81, const Color.fromARGB(255, 83, 202, 166)),
    TimeData('rest', 19, Colors.transparent),
  ];

  final List<TimeData> avgFulfilmentTimeData = [
    TimeData('resukt', 45, Color.fromRGBO(165, 26, 139, 1)),
    TimeData('rest', 55, Colors.transparent),
  ];

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
  List<BarData> outBoundData = [
    BarData(xLabel: 'Mon', yValue: 6, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 8, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 15, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 7, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 10, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  List<BarData> orderAgingData = [
    BarData(xLabel: '<1 day', yValue: 10, abbreviation: '<1 day'),
    BarData(xLabel: '1-7 days', yValue: 4, abbreviation: '1-7 days'),
    BarData(xLabel: '>7 days', yValue: 6, abbreviation: '>7 days'),
  ];

  late DashboardsBloc _dashboardsBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rangeSelection = true;
    employeeSuggestionRange = {
      "101-110": [
        "101",
        "102",
        "103",
        "104",
        "105",
        "106",
        "107",
        "108",
        "109",
        "110",
      ],
      "111-120": ["111", "112", "113", "114", "115", "116", "117", "118", "119", "120"],
      "121-130": ["121", "122", "123", "124", "125", "126", "127", "128", "129", "130"],
      "131-140": ["131", "132", "133", "134", "135", "136", "137", "138", "139", "140"],
    };

    _dashboardsBloc = context.read<DashboardsBloc>();
    _dashboardsBloc.add(GetStagingDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return SingleChildScrollView(
        child: BlocBuilder<DashboardsBloc, DashboardsState>(
          builder: (context, state) {
            return Column(
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
                            height: size.height * 0.45,
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.topCenter,
                            child: SfCircularChart(
                              title: ChartTitle(
                                  text: "Avg Lead Time",
                                  alignment: ChartAlignment.center,
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
                                        '02h:15m',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.height * 0.02,
                                        ),
                                      )),
                                ),
                              ],
                              series: <CircularSeries>[
                                DoughnutSeries<TimeData, String>(
                                  dataSource: avgLeadTimeData,
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
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.topCenter,
                            child: Customs.WMSPieChart(
                              title: 'Inventory Summary',
                              dataSource: orderSummaryDataSource,
                              legendVisibility: true,
                            )),
            
                        Container(
                            margin: EdgeInsets.all(aspectRatio * 8),
                            height: size.height * 0.45,
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.topCenter,
                            child: Gauges.SfRadialGauge(
                              title: Gauges.GaugeTitle(
                                  text: "Shipping Efficiency",
                                  alignment: Gauges.GaugeAlignment.center,
                                  textStyle: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold)),
                              axes: [
                                Gauges.RadialAxis(
                                  maximum: 100,
                                  minimum: 0,
                                  interval: 25,
                                  canScaleToFit: true,
                                  annotations: [
                                    Gauges.GaugeAnnotation(
                                        verticalAlignment: Gauges.GaugeAlignment.center,
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
                                            "85%",
                                            style: TextStyle(fontSize: aspectRatio * 10),
                                          ),
                                        ))
                                  ],
                                  axisLineStyle: const Gauges.AxisLineStyle(
                                      thickness: 35, color: Color.fromARGB(255, 189, 187, 64), cornerStyle: Gauges.CornerStyle.bothCurve),
                                  showTicks: false,
                                  showLabels: false,
                                  radiusFactor: aspectRatio * 0.3,
                                  pointers: const [
                                    Gauges.MarkerPointer(
                                      value: 85,
                                      markerType: Gauges.MarkerType.invertedTriangle,
                                      markerHeight: 20,
                                      markerWidth: 20,
                                      color: Colors.white,
                                      enableAnimation: true,
                                      elevation: 10,
                                    )
                                  ],
                                )
                              ],
                            )),
            
                        //  Container(
                        //     margin: EdgeInsets.all(aspectRatio * 8),
                        //     height: size.height * 0.45,
                        //     width: size.width * 0.25,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(20),
                        //       boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]
                        //     ),
                        //     padding: EdgeInsets.all(size.height*0.035),
                        //     alignment: Alignment.bottomCenter,
                        //     child: Customs.WMSCartesianChart(
                        //       title: 'Supplierwise Inventory',
                        //             yAxisTitle: 'Number of Items', barCount: 1, barColors: [Colors.teal], dataSources: [supplierWiseDataSource]),
                        //   ),
            
                        //  Container(
                        //   margin: EdgeInsets.all(aspectRatio * 8),
                        //   height: size.height * 0.45,
                        //   width: size.width * 0.25,
                        //   decoration: BoxDecoration(
                        //       color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        //   padding: EdgeInsets.all(size.height * 0.035),
                        //   alignment: Alignment.topCenter,
                        //   child: SfCircularChart(
                        //     title: ChartTitle(
                        //       text: 'Order Lead Time',
                        //       alignment: ChartAlignment.center,
                        //       textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                        //     ),
                        //     legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                        //     series: <CircularSeries>[
                        //       // Renders radial bar chart
            
                        //       DoughnutSeries<PieData, String>(
                        //         dataSource: warehouseUtilizationDataSource,
                        //         dataLabelSettings: const DataLabelSettings(
                        //             // Renders the data label
                        //             isVisible: true,
                        //             textStyle: TextStyle(fontWeight: FontWeight.bold),
                        //             alignment: ChartAlignment.center),
                        //         pointColorMapper: (datum, index) {
                        //           return warehouseUtilizationDataSource[index].color;
                        //         },
                        //         xValueMapper: (PieData data, _) => data.xData,
                        //         yValueMapper: (PieData data, _) => data.yData,
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.all(aspectRatio * 8),
                            height: size.height * 0.45,
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Text(
                                  'Order Aging',
                                  style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: size.height * 0.3,
                                  width: size.width * 0.25,
                                  child: Customs.WMSCartesianChart(
                                      title: '',
                                      barCount: 1,
                                      dataSources: [orderAgingData],
                                      yAxisTitle: 'Aging time',
                                      legendVisibility: false,
                                      barColors: [Colors.deepPurple.shade200]),
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(aspectRatio * 8),
                            height: size.height * 0.45,
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.topCenter,
                            child: SfCircularChart(
                              title: ChartTitle(
                                  text: "Fulfilment Time",
                                  alignment: ChartAlignment.center,
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
                                        '01h:45m',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.height * 0.02,
                                        ),
                                      )),
                                ),
                              ],
                              series: <CircularSeries>[
                                DoughnutSeries<TimeData, String>(
                                  dataSource: avgFulfilmentTimeData,
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
                            width: size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Day Wise Order Summary',
                                  style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: size.height * 0.3,
                                  width: size.width * 0.25,
                                  child: Customs.WMSCartesianChart(
                                    title: "",
                                    legendVisibility: false,
                                    barCount: 1,
                                    dataSources: [dayWiseOrderSummary],
                                    yAxisTitle: 'Number of orders',
                                    barColors: [Colors.blueGrey.shade500],
                                  ),
                                ),
                              ],
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
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.all(size.height * 0.035),
                            alignment: Alignment.bottomCenter,
                            child: Customs.WMSCartesianChart(
                              title: "Today Channel Wise Order Summary",
                              legendVisibility: false,
                              barCount: 1,
                              dataSources: [channelWiseOrderSummary],
                              yAxisTitle: 'Number of orders',
                              barColors: [const Color.fromRGBO(202, 108, 15, 1)],
                            )),
            
            
                        Container(
                            margin: EdgeInsets.all(aspectRatio * 8),
                            height: size.height * 0.45,
                            width: size.width * 0.52,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                            padding: EdgeInsets.only(left: size.height * 0.035, top: size.height * 0.035, bottom: size.height * 0.035),
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.36,
                                  child: Customs.WMSCartesianChart(
                                      title: 'User Efficiency',
                                      barCount: 1,
                                      legendVisibility: false,
                                      dataSources: [userEfficiencyGraphData],
                                      yAxisTitle: 'Number of Orders',
                                      barColors: [Color.fromRGBO(147, 0, 120, 0.5)]),
                                ),
                                Gap(size.width * 0.016),
                                Container(
                                  width: size.width * 0.1,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TypeAheadField(
                                              suggestionsController: suggestionsController,
                                              builder: (context, textController, focusNode) {
                                                typeAheadController = textController;
                                                typeAheadFocusNode = focusNode;
                                                textController = textController;
                                                focusNode = focusNode;
                                                focusNode.addListener(() {
                                                  if (!focusNode.hasFocus) {
                                                    textController.clear();
                                                  }
                                                });
                                                return TextFormField(
                                                  textAlign: TextAlign.center,
                                                  onTap: () {},
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                      hintText: rangeSelection ? 'Choose' : "Compare",
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                                                      hintStyle: const TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                      // suffixIconConstraints: const BoxConstraints(minWidth: 16, minHeight: 8)
                                                      )
                                                      ,
                                                  controller: textController,
                                                  focusNode: focusNode,
                                                );
                                              },
                                              suggestionsCallback: (pattern) {
                                                userSuggestions = [];
                                                if (rangeSelection) {
                                                  userSuggestions = employeeSuggestionRange.keys.toList();
                                                } else {
                                                  for (var empList in employeeSuggestionRange.values) {
                                                    print(empList);
                                                    userSuggestions.addAll(empList);
                                                  }
                                                  print("emp suggestios $userSuggestions");
                                                }
                                                return userSuggestions;
                                              },
                                              itemBuilder: (context, suggestion) => Row(
                                                children: [
                                                  SizedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SizedBox(
                                                        // width: size.width*0.1,
                                                          child: Row(
                                                        children: [
                                                          Transform.scale(
                                                            scale: aspectRatio*0.4,
                                                            child: Checkbox(
                                                                visualDensity: VisualDensity.compact,
                                                                shape: OvalBorder(),
                                                                value: rangeSelection ? selectedUserRange == suggestion : selectedUsers.contains(suggestion),
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    if (rangeSelection != true) {
                                                                      if (selectedUsers.contains(suggestion)) {
                                                                        selectedUsers.remove(suggestion);
                                                                        userEfficiencyGraphData.removeWhere((data) => data.xLabel == suggestion);
                                                                        suggestionsController.refresh();
                                                                      } else if (selectedUsers.length < 10) {
                                                                        selectedUsers.add(suggestion);
                                                                        userEfficiencyGraphData
                                                                            .add(BarData(xLabel: suggestion, yValue: random.nextInt(10), abbreviation: suggestion));
                                                                        suggestionsController.refresh();
                                                                      }
                                                                    } else {
                                                                      selectedUserRange = suggestion;
                                                                      userEfficiencyGraphData = [];
                                                                      selectedUsers = [];
                                                                      List<String> employees = employeeSuggestionRange[suggestion]!;
                                                                      selectedUsers.addAll(employees);
                                                                      for (var emp in selectedUsers) {
                                                                        userEfficiencyGraphData
                                                                            .add(BarData(xLabel: emp, yValue: random.nextInt(10), abbreviation: suggestion));
                                                                      }
                                                                    }
                                                                  });
                                                                }),
                                                          ),
                                                          Text(
                                                            suggestion.toString(),
                                                            textAlign: TextAlign.justify,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onSelected: (suggestion) {
                                                if (rangeSelection == false) {
                                                  setState(
                                                    () {
                                                      if (selectedUsers.contains(suggestion)) {
                                                        selectedUsers.remove(suggestion);
                                                        userEfficiencyGraphData.removeWhere((data) => data.xLabel == suggestion);
                                                        suggestionsController.refresh();
                                                      } else if (selectedUsers.length < 10) {
                                                        selectedUsers.add(suggestion);
                                                        userEfficiencyGraphData
                                                            .add(BarData(xLabel: suggestion, yValue: random.nextInt(10), abbreviation: suggestion));
                                                        // typeAheadController.clear();
                                                        // suggestionsController.close();
                                                        suggestionsController.refresh();
                                                      }
                                                    },
                                                  );
                                                } else {
                                                  setState(() {
                                                    selectedUserRange = suggestion;
                                                    List<String> employees = employeeSuggestionRange[suggestion]!;
                                                    userEfficiencyGraphData = [];
                                                    selectedUsers = [];
                        
                                                    selectedUsers.addAll(employees);
                                                    for (var emp in selectedUsers) {
                                                      userEfficiencyGraphData.add(BarData(xLabel: emp, yValue: random.nextInt(10), abbreviation: suggestion));
                                                    }
                                                  });
                                                }
                                              },
                                              hideOnSelect: false,
                                            ),
                                          ),
                                          // Gap(size.width * 0.01),
                                          Transform.scale(
                                            scale: 0.7,
                                            child: Switch(
                                              value: rangeSelection,
                                              onChanged: (value) {
                                                print(rangeSelection);
                                                setState(() {
                                                  rangeSelection = value;
                                                  suggestionsController.refresh();
                                                  selectedUserRange = "";
                                                  selectedUsers = [];
                                                  userEfficiencyGraphData = [];
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      Gap(size.height * 0.012),
                                      Container(
                                          width: size.width * 0.1,
                                          height: size.height * 0.3,
                                          decoration: BoxDecoration(),
                                          child:
                                              ListView(
                                            children: selectedUsers
                                                .map((emp) => Container(
                                                    margin: EdgeInsets.only(bottom: 4),
                                                    decoration:
                                                        BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(12), color: Colors.black12),
                                                    child: Row(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Gap(size.width * 0.01),
                                                        Expanded(
                                                            child: Text(
                                                          emp,
                                                          style: TextStyle(fontSize: 22,overflow: TextOverflow.ellipsis),
                                                        )),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              selectedUsers.remove(emp);
                                                              userEfficiencyGraphData.removeWhere((data) => data.xLabel == emp);
                                                            });
                                                          },
                                                          icon: Icon(Icons.cancel_rounded),
                                                          iconSize: size.width * 0.01,
                                                          splashRadius: 5,
                                                          visualDensity: VisualDensity.compact,
                                                        ),
                                                      ],
                                                    )))
                                                .toList(),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              ],
            ),
                  ],
                );
          }
        ));
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class ActivityAreaDashboard extends StatefulWidget {
  ActivityAreaDashboard({super.key});

  @override
  State<ActivityAreaDashboard> createState() => _ActivityAreaDashboardState();
}

class _ActivityAreaDashboardState extends State<ActivityAreaDashboard> {
  SuggestionsController suggestionsController = SuggestionsController();


    static Widget WMSCartesianChart({String title = "title", int barCount = 1, List<List<BarData>>? dataSources, String yAxisTitle = "title" ,Color? primaryColor,Color? secondaryColor,List<String>? legendText,bool? isLegendVisible,int? spacing}){
    return SfCartesianChart(
                    title: ChartTitle(text: title,textStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    )),
                    
                    legend: isLegendVisible!=null? Legend(alignment: ChartAlignment.near,isVisible: isLegendVisible?? false,isResponsive: true,position: LegendPosition.bottom):Legend(),
                    onLegendItemRender: (legendRenderArgs) {
                      if(legendText!=null){
                      legendRenderArgs.text = legendText[legendRenderArgs.seriesIndex!];}
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
                    series: List.generate(barCount, (index) => ColumnSeries<BarData, String>(
                        dataSource: dataSources![index],
                        xValueMapper: (BarData data, _) => data.xLabel,
                        yValueMapper: (BarData data, _) => data.yValue,
                        borderRadius: BorderRadius.circular(10),
                        spacing: 0.1,
                        color: (primaryColor==null && secondaryColor==null)?Colors.blueAccent: (secondaryColor==null)?primaryColor: index==0?primaryColor:secondaryColor,
                        dataLabelMapper: (datum, index) => datum.yValue.toString(),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                          builder: (data, point, series, pointIndex, seriesIndex) {
                            return Text(
                            (data as BarData).yValue.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          );}
                        ),
                        width: 0.6,
                      ),)
                    );
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



  static Widget WMSSfCircularChart({required List<AnalogChartData> chartData,String? title,String? contentText,required Size size,double? height,double? width,String? radius,Color? textColor}){
                    return SfCircularChart(
                                  title: ChartTitle(text: title??"title"),
                                
                                  annotations: <CircularChartAnnotation>[
                                    
                                    CircularChartAnnotation(
                                      
                                      widget: Container(
                                        width: width??100,
                                        height: height??160,
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
                                        child:  Text(
                                          contentText??"chart",
                                          style: TextStyle(
                                            color: textColor??Color.fromARGB(255, 101, 10, 10),
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
                                      radius: radius??'50%', // Adjust the radius as needed
                                      innerRadius: '20%', // Optional: adjust for a thinner ring
                                      pointColorMapper: (AnalogChartData data, _) => data.color,
                                    )
                                  ],
                                );
  }

  static void AnimatedDialog({
    required BuildContext context,
    required Widget header,
    required List<Widget> content,
  }) {
    Size size = MediaQuery.of(context).size;
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.bounceInOut.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.4),
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Material(
                  color: Colors.transparent,
                  child: IntrinsicHeight(
                    child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.035),
                      padding: EdgeInsets.only(
                        bottom: size.height * 0.02,
                      ),
                      width: size.width * 0.16,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    weight: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(size.height * 0.01),
                          ...content
                        ],
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 35,
                  child: header,
                )
              ],
            ),
          ),
        );
      },
    );
  }
















  late TextEditingController typeAheadController;

  late FocusNode typeAheadFocusNode;
  List<String> selectedEmployees = [];
  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> taskdata = [
    BarData(xLabel: 'Mon', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 6, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 8, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 5, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 2, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  List<BarData> empTaskdata = [];

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

  final List<AnalogChartData> avgTaskExecutionTime = [
    AnalogChartData('Execution time', 60, Color.fromRGBO(147, 0, 119, 1)),
    AnalogChartData('rest', 40, Colors.transparent),
    // AnalogChartData('rest', 75, Color.fromRGBO(9, 0, 136, 1))
    // AnalogChartData('Jack', 34, Color.fromRGBO(228,0,124,1)),
    // AnalogChartData('Others', 52, Color.fromRGBO(255,189,57,1))
  ];

  final List<AnalogChartData> avgPickTime = [
    AnalogChartData('Execution time', 40, Color.fromRGBO(9, 0, 136, 1)),
    AnalogChartData('rest', 60, Colors.transparent),
  ];
  late Map<String, List<String>> employeeSuggestionRange;
  var random = Random();
  late bool rangeSelection;
  String selectedEmployeeRange = "";
  late List<String> employeeSuggestions;
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
   
  }

  void resetEmpGraphData(){
    if(rangeSelection){
      // to do
      selectedEmployeeRange = "101-110"; 
    }
    else{
      // to do
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Gap(size.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Activity Area Dashboard',
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: size.height * 0.32,
                              width: size.width * 0.26,
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0.4, spreadRadius: 0.4)],
                                  color: Colors.white),
                              child: WMSPieChart(
                                  title: "Trucks Info",
                                  dataSource: [
                                    PieData("Created", 16, "16"),
                                    PieData("Completed", 6, "6"),
                                    PieData("In Progress", 4, "4"),
                                    PieData("Cancelled", 2, "2"),
                                  ],
                                  pointColorMapper: (datum, index) {
                                    if (datum.xData == 'Created') {
                                      return Colors.lightBlueAccent.shade700;
                                    } else if (datum.xData == 'In Progress') {
                                      return Colors.orangeAccent;
                                    } else if (datum.xData == 'Completed') {
                                      return Colors.green;
                                    } else if (datum.xData == 'Cancelled') {
                                      return Colors.red;
                                    }
                                  })),
                          Container(
                              height: size.height * 0.32,
                              width: size.width * 0.26,
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: WMSPieChart(
                                  title: 'Task Type Summary',
                                  dataSource: [PieData("Cycle Count", 10, "10"), PieData("Pick Tasks", 4, "4"), PieData("Replenishment", 4, "4")])),
                          Container(
                              height: size.height * 0.32,
                              width: size.width * 0.26,
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0.4, spreadRadius: 0.4)],
                                  color: Colors.white),
                              child: WMSPieChart(
                                  title: "Today Work Order Summary",
                                  dataSource: [
                                    PieData("Created", 16, "16"),
                                    PieData("Work In Progress", 6, "6"),
                                    PieData("Completed", 4, "4"),
                                  ],
                                  pointColorMapper: (datum, index) {
                                    if (datum.xData == 'Created') {
                                      return Colors.lightBlueAccent.shade700;
                                    } else if (datum.xData == 'Work In Progress') {
                                      return Colors.orangeAccent;
                                    } else if (datum.xData == 'Completed') {
                                      return Colors.green;
                                    }
                                  })),
                        ],
                      ),
                      Gap(size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: size.height * 0.48,
                              width: size.width * 0.32,
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0.4, spreadRadius: 0.4)],
                                  color: Colors.white),
                              child: WMSCartesianChart(
                                  title: 'Day Wise Task Summary ',
                                  barCount: 1,
                                  dataSources: [taskdata],
                                  yAxisTitle: 'Number of Tasks',
                                  primaryColor: Color.fromRGBO(9, 0, 136, 0.692))),
                          Container(
                            height: size.height * 0.48,
                            width: size.width * 0.32,
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0.4, spreadRadius: 0.4)],
                                color: Colors.white),
                            child: WMSCartesianChart(
                                title: 'Employee Wise Task Summary',
                                barCount: 1,
                                dataSources: [taskdata],
                                yAxisTitle: 'Number of Tasks',
                                primaryColor: Color.fromRGBO(64, 133, 138, 1)),
                          ),
                          SizedBox(
                            height: size.height * 0.48,
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Container(
                                  height: size.height * 0.235,
                                  width: size.width * 0.14,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0.4, spreadRadius: 0.4)],
                                      color: Colors.white),
                                  child: WMSSfCircularChart(
                                      size: size,
                                      chartData: avgTaskExecutionTime,
                                      title: "Average Task Execution Time",
                                      contentText: "6h 40m",
                                      width: 136,
                                      height: 136,
                                      radius: "90%")),
                              Container(
                                  height: size.height * 0.235,
                                  width: size.width * 0.14,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0.4, spreadRadius: 0.4)],
                                      color: Colors.white),
                                  child: WMSSfCircularChart(
                                      size: size,
                                      chartData: avgPickTime,
                                      title: "Avg Pick Time",
                                      contentText: "2h 15m",
                                      textColor: Color.fromRGBO(13, 6, 109, 1),
                                      width: 136,
                                      height: 136,
                                      radius: "90%")),
                            ]),
                          )
                        ],
                      ),
                      Gap(size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: size.height * 0.48,
                              width: size.width * 0.56,
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0.4, spreadRadius: 0.4)],
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: WMSCartesianChart(
                                        title: 'Avg Task Taken by Employee ',
                                        barCount: 1,
                                        dataSources: [empTaskdata],
                                        yAxisTitle: 'Number of Tasks',
                                        primaryColor: Color.fromRGBO(147, 0, 120, 0.5)),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: EdgeInsets.only(right: size.width * 0.04, top: size.height * 0.04),
                                      // height: size.height * 0.04,
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
                                                          hintText: rangeSelection? 'Choose' : "Compare",
                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                                                          hintStyle: const TextStyle(
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                          suffixIconConstraints: const BoxConstraints(minWidth: 16, minHeight: 8)),
                                                      controller: textController,
                                                      focusNode: focusNode,
                                                    );
                                                  },
                                                  suggestionsCallback: (pattern) {
                                                    employeeSuggestions = [];
                                                    if (rangeSelection) {
                                                      employeeSuggestions = employeeSuggestionRange.keys.toList();
                                                    } else {
                                                      for (var empList in employeeSuggestionRange.values) {
                                                        print(empList);
                                                        employeeSuggestions.addAll(empList);
                                                      }
                                                      print("emp suggestios $employeeSuggestions");
                                                    }
                                                    return employeeSuggestions;
                                                  },
                                                  itemBuilder: (context, suggestion) => Row(
                                                    children: [
                                                      SizedBox(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                              child: Row(
                                                            children: [
                                                              Checkbox(
                                                                  shape: OvalBorder(),
                                                                  value: rangeSelection?selectedEmployeeRange==suggestion: selectedEmployees.contains(suggestion),
                                                                  onChanged: (value) {
                                                                    setState(() {
                                                                      if (rangeSelection != true) {
                                                                        if (selectedEmployees.contains(suggestion)) {
                                                                          selectedEmployees.remove(suggestion);
                                                                          empTaskdata.removeWhere((data) => data.xLabel == suggestion);
                                                                          suggestionsController.refresh();
                                                                        } else if (selectedEmployees.length <= 10) {
                                                                          selectedEmployees.add(suggestion);
                                                                          empTaskdata
                                                                              .add(BarData(xLabel: suggestion, yValue: random.nextInt(10), abbreviation: suggestion));
                                                                          suggestionsController.refresh();
                                                                        }
                                                                      } else {
                                                                        selectedEmployeeRange = suggestion;
                                                                         empTaskdata=[];
                                                                         selectedEmployees=[];
                                                                        List<String> employees = employeeSuggestionRange[suggestion]!;
                                                                        selectedEmployees.addAll(employees);
                                                                        for (var emp in selectedEmployees) {
                                                                          empTaskdata.add(BarData(xLabel: emp, yValue: random.nextInt(10), abbreviation: suggestion));
                                                                        }
                                                                      }
                                                                    });
                                                                  }),
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
                                                    if (rangeSelection==false) {
                                                      setState(
                                                        () {
                                                          if (selectedEmployees.contains(suggestion)) {
                                                            selectedEmployees.remove(suggestion);
                                                            empTaskdata.removeWhere((data) => data.xLabel == suggestion);
                                                            suggestionsController.refresh();
                                                          } else {
                                                            selectedEmployees.add(suggestion);
                                                            empTaskdata.add(BarData(xLabel: suggestion, yValue: random.nextInt(10), abbreviation: suggestion));
                                                            // typeAheadController.clear();
                                                            // suggestionsController.close();
                                                            suggestionsController.refresh();
                                                          }
                                                        },
                                                      );
                                                    } else {
                                                      setState(() {
                                                        selectedEmployeeRange = suggestion;
                                                        List<String> employees = employeeSuggestionRange[suggestion]!;
                                                        empTaskdata=[];
                                                        selectedEmployees=[];
                                                
                                                        selectedEmployees.addAll(employees);
                                                        for (var emp in selectedEmployees) {
                                                          empTaskdata.add(BarData(xLabel: emp, yValue: random.nextInt(10), abbreviation: suggestion));
                                                        }
                                                      });
                                                    }
                                                  },
                                                  hideOnSelect: false,
                                                ),
                                              ),
                                              Gap(size.width*0.01),
                                              SizedBox(
                                                // width:size.width*0.08,
                                                height: size.height*0.02,

                                                child:
                                                
                                                 Switch(value: rangeSelection, onChanged: (value) {
                                                  print(rangeSelection);
                                                    setState(() {
                                                      rangeSelection=value;
                                                      suggestionsController.refresh();
                                                      selectedEmployeeRange="";
                                                      selectedEmployees=[];
                                                      empTaskdata=[];
                                                    
                                                    });
                                                  
                                                },),
                                              )
                                           
                                            ],
                                          ),
                                          Gap(size.height * 0.01),

                                          Container(
                                              width: size.width * 0.1,
                                              height: size.height * 0.36,
                                              decoration: BoxDecoration(),
                                              child: rangeSelection
                                                  ? Text(selectedEmployeeRange)
                                                  : ListView(
                                                      children: selectedEmployees
                                                          .map((emp) => Container(
                                                                  child: Row(
                                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Gap(size.width * 0.01),
                                                                  Expanded(
                                                                      child: Text(
                                                                    emp,
                                                                    style: TextStyle(fontSize: 22),
                                                                  )),
                                                                  IconButton(
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        selectedEmployees.remove(emp);
                                                                        empTaskdata.removeWhere((data) => data.xLabel == emp);
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
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// models for charts
class PieData {
  PieData(this.xData, this.yData, [this.text]);
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


class AnalogChartData {
        AnalogChartData(this.x, this.y, this.color);
            final String x;
            final double y;
            final Color color;
    }
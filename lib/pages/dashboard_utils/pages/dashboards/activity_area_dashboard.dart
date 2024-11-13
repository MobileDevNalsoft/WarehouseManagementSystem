import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class ActivityAreaDashboard extends StatefulWidget {
  ActivityAreaDashboard({super.key});

  @override
  State<ActivityAreaDashboard> createState() => _ActivityAreaDashboardState();
}

class _ActivityAreaDashboardState extends State<ActivityAreaDashboard> {
  SuggestionsController suggestionsController = SuggestionsController();

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
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            )),
        legend: isLegendVisible != null
            ? Legend(alignment: ChartAlignment.near, isVisible: isLegendVisible ?? false, isResponsive: true, position: LegendPosition.bottom)
            : Legend(),
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

  void resetEmpGraphData() {
    if (rangeSelection) {
      // to do
      selectedEmployeeRange = "101-110";
    } else {
      // to do
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                          dataSource: [
                            PieData(xData: "Created", yData: 16, text: "16"),
                            PieData(xData: "Completed", yData: 6, text: "6"),
                            PieData(xData: "In Progress", yData: 4, text: "4"),
                            PieData(xData: "Cancelled", yData: 2, text: "2"),
                          ],
                          legendVisibility: true,
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
                    margin: EdgeInsets.all(aspectRatio * 8),
                    height: size.height * 0.45,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                    padding: EdgeInsets.all(size.height * 0.035),
                    alignment: Alignment.topCenter,
                    child: Customs.WMSPieChart(
                      title: 'Task Type Summary',
                      dataSource: [
                        PieData(xData: "Cycle Count", yData: 10, text: "10"),
                        PieData(xData: "Pick Tasks", yData: 4, text: "4"),
                        PieData(xData: "Replenishment", yData: 4, text: "4")
                      ],
                      legendVisibility: true,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter,
                      child: Customs.WMSPieChart(
                          title:'Today Work Order Summary',
                          dataSource: [
                            PieData(xData: "Created", yData: 16, text: "16"),
                            PieData(xData: "Work In Progress", yData: 6, text: "6"),
                            PieData(xData: "Completed", yData: 4, text: "4"),
                          ],
                          legendVisibility: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day Wise Task Summary ',
                            style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: size.height * 0.3,
                            width: size.width * 0.25,
                            child: Customs.WMSCartesianChart(
                              title: "",
                              legendVisibility: false,
                              barCount: 1,
                              dataSources: [taskdata],
                              yAxisTitle: 'Number of Tasks',
                              barColors: [Color.fromRGBO(9, 0, 136, 0.692)],
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.all(aspectRatio * 8),
                    height: size.height * 0.45,
                    width: size.width * 0.25,
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                    padding: EdgeInsets.all(size.height * 0.035),
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Employee Wise Task Summary',
                          style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: size.height * 0.3,
                            width: size.width * 0.25,
                            child: Customs.WMSCartesianChart(
                              title: "",
                              legendVisibility: false,
                              barCount: 1,
                              dataSources: [taskdata],
                              yAxisTitle: 'Number of Tasks',
                               barColors: [Color.fromRGBO(64, 133, 138, 1)],
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all( size.height * 0.035),
                      alignment: Alignment.topCenter,
                      child: Customs.WMSSfCircularChart(
                          size: size,
                          chartData: avgTaskExecutionTime,
                          title: "Average Task Execution Time",
                          contentText: "6h 40m",
                          width: 142,
                          height: 142,
                          radius: "70%")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter,
                      child: Customs.WMSSfCircularChart(
                          size: size,
                          chartData: avgPickTime,
                          title: "Avg Pick Time",
                          contentText: "2h 15m",
                          textColor: Color.fromRGBO(13, 6, 109, 1),
                          width: 142,
                          height: 142,
                          radius: "70%")),




                  LayoutBuilder(
                    builder: (context,constraints) {
                      return Container(
                          margin: EdgeInsets.all(aspectRatio * 8),
                          height: size.height * 0.45,
                          width: size.width * 0.52,
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                          padding: EdgeInsets.only(left:size.height * 0.035,top:size.height * 0.035,bottom: size.height * 0.035),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.36,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Avg Time Taken by Employee ',
                                      style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                                    ),
                                    WMSCartesianChart(
                                        title: '',
                                        barCount: 1,
                                        dataSources: [empTaskdata],
                                        yAxisTitle: 'Number of Tasks',
                                        primaryColor: Color.fromRGBO(147, 0, 120, 0.5)),
                                  ],
                                ),
                              ),
                              Gap(size.width*0.016),
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
                                                            value: rangeSelection ? selectedEmployeeRange == suggestion : selectedEmployees.contains(suggestion),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                if (rangeSelection != true) {
                                                                  if (selectedEmployees.contains(suggestion)) {
                                                                    selectedEmployees.remove(suggestion);
                                                                    empTaskdata.removeWhere((data) => data.xLabel == suggestion);
                                                                    suggestionsController.refresh();
                                                                  } else if (selectedEmployees.length < 10) {
                                                                    selectedEmployees.add(suggestion);
                                                                    empTaskdata
                                                                        .add(BarData(xLabel: suggestion, yValue: random.nextInt(10), abbreviation: suggestion));
                                                                    suggestionsController.refresh();
                                                                  }
                                                                } else {
                                                                  selectedEmployeeRange = suggestion;
                                                                  empTaskdata = [];
                                                                  selectedEmployees = [];
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
                                              if (rangeSelection == false) {
                                                setState(
                                                  () {
                                                    if (selectedEmployees.contains(suggestion)) {
                                                      selectedEmployees.remove(suggestion);
                                                      empTaskdata.removeWhere((data) => data.xLabel == suggestion);
                                                      suggestionsController.refresh();
                                                    } else if (selectedEmployees.length < 10){
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
                                                  empTaskdata = [];
                                                  selectedEmployees = [];
                      
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
                                                selectedEmployeeRange = "";
                                                selectedEmployees = [];
                                                empTaskdata = [];
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    Gap(size.height * 0.012),
                                    // if (rangeSelection)
                                      Container(
                                          width: size.width * 0.1,
                                          height: size.height * 0.3,
                                          decoration: BoxDecoration(),
                                          child:
                                              // rangeSelection
                                              //     ? Text(selectedEmployeeRange)
                                              //     :
                                              ListView(
                                            children: selectedEmployees
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
                            ],
                          ));
                    }
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
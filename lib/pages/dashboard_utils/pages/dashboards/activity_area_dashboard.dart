import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/dashboard_utils/shared/constants/defaults.dart';

class ActivityAreaDashboard extends StatefulWidget {
  const ActivityAreaDashboard({super.key});

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
          labelRotation: -90,
          majorTickLines: MajorTickLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: yAxisTitle),
          majorGridLines: const MajorGridLines(
            width: 0,
          ),
          majorTickLines: const MajorTickLines(width: 1),
          axisLine: const AxisLine(
            width: 1,
          ),
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

  List<BarData> empTaskdata = [];

  final List<PieData> avgTime = [PieData(xData: 'Execution time', yData: 60), PieData(xData: 'Rest', yData: 40)];
  late Map<String, List<String>> employeeSuggestionRange;
  var random = Random();
  late bool rangeSelection;
  String selectedEmployeeRange = "";
  late List<String> employeeSuggestions;

  late DashboardsBloc _dashboardsBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rangeSelection = false;
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
    _dashboardsBloc.add(GetActivityDashboardData(facilityID: 243));
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
      child: BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
        bool isEnabled = state.getActivityDashboardState != ActivityDashboardState.success;
        if (state.getActivityDashboardState == ActivityDashboardState.success) {
          employeeSuggestions = state.activityDashboardData!.empwiseTaskSummary!.map((e) => e.status!).toList();
          // selectedEmployees = employeeSuggestions;
        }
        return Column(
          children: [
            Row(
              children: [
                Customs.DashboardWidget(
                    size: Size(size.width * 0.25, size.height * 0.45),
                    margin: aspectRatio * 10,
                    loaderEnabled: isEnabled,
                    chartBuilder: (ratio) {
                      return Customs.WMSSfCircularChart(
                          ratio: ratio,
                          title: 'Today Task Summary',
                          titleFontSize: ratio*13,
                          legendVisibility: true,
                          series: SeriesName.pieSeries,
                          props: Props(
                            dataSource: state.activityDashboardData!.todayTaskSummary!
                                .map((e) => PieData(xData: e.status!, yData: e.count!, text: e.count!.toString()))
                                .toList(),
                            radius: '${ratio * 55}%',
                            pointColorMapper: (p0, p1) {
                              if (p1 == 0) {
                                return const Color.fromARGB(255, 80, 175, 230);
                              } else if (p1 == 1) {
                                return const Color.fromARGB(255, 115, 102, 189);
                              } else if (p1 == 2) {
                                return const Color.fromARGB(255, 110, 196, 163);
                              } else if (p1 == 3) {
                                return const Color.fromARGB(255, 159, 177, 80);
                              }
                            },
                          ));
                    }),
                Customs.DashboardWidget(
                    size: Size(size.width * 0.25, size.height * 0.45),
                    margin: aspectRatio * 10,
                    loaderEnabled: isEnabled,
                    chartBuilder: (ratio) {
                      return Customs.WMSSfCircularChart(
                          ratio: ratio,
                          title: 'Task Type Summary',
                          titleFontSize: ratio*13,
                          legendVisibility: true,
                          series: SeriesName.pieSeries,
                          props: Props(
                            dataSource: state.activityDashboardData!.taskTypeSummary!
                                .map((e) => PieData(xData: e.status!, yData: e.count!, text: e.count!.toString()))
                                .toList(),
                            radius: '${ratio * 55}%',
                            pointColorMapper: (p0, p1) {
                              if (p1 == 0) {
                                return const Color.fromARGB(255, 80, 175, 230);
                              } else if (p1 == 1) {
                                return const Color.fromARGB(255, 115, 102, 189);
                              } else if (p1 == 2) {
                                return const Color.fromARGB(255, 110, 196, 163);
                              } else if (p1 == 3) {
                                return const Color.fromARGB(255, 159, 177, 80);
                              }
                            },
                          ));
                    }),
                Customs.DashboardWidget(
                    size: Size(size.width * 0.25, size.height * 0.45),
                    margin: aspectRatio * 10,
                    loaderEnabled: isEnabled,
                    chartBuilder: (ratio) {
                      return Customs.WMSSfCircularChart(
                          ratio: ratio,
                          title: 'Today Work Order Summary',
                          titleFontSize: ratio*13,
                          legendVisibility: true,
                          series: SeriesName.pieSeries,
                          props: Props(
                            dataSource: state.activityDashboardData!.todayWorkOrderSummary!
                                .map((e) => PieData(xData: e.status!, yData: e.count!, text: e.count!.toString()))
                                .toList(),
                            radius: '${ratio * 55}%',
                            pointColorMapper: (p0, p1) {
                              if (p1 == 0) {
                                return const Color.fromARGB(255, 176, 113, 187);
                              } else if (p1 == 1) {
                                return const Color.fromARGB(255, 175, 147, 70);
                              } else if (p1 == 2) {
                                return const Color.fromARGB(255, 68, 158, 76);
                              } else {
                                return const Color.fromARGB(255, 165, 180, 79);
                              }
                            },
                          ));
                    }),
              ],
            ),
            Row(
              children: [
                Customs.DashboardWidget(
                    size: Size(size.width * 0.25, size.height * 0.45),
                    margin: aspectRatio * 10,
                    loaderEnabled: isEnabled,
                    chartBuilder: (ratio) {
                      return Customs.WMSCartesianChart(
                          title: 'Daywise Task Summary',
                          titleFontSize: ratio*13,
                          xlabelFontSize: ratio * 10,
                          ylabelFontSize: ratio * 10,
                          ytitleFontSize: ratio * 12,
                          barCount: 1,
                          dataSources: [
                            state.activityDashboardData!.daywiseTaskSummary!
                                .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                .toList()
                          ],
                          yAxisTitle: 'Number of Tasks',
                          legendVisibility: false,
                          barColors: [Color.fromRGBO(78, 72, 161, 0.69)]);
                    }),
                Customs.DashboardWidget(
                    size: Size(size.width * 0.25, size.height * 0.45),
                    margin: aspectRatio * 10,
                    loaderEnabled: isEnabled,
                    chartBuilder: (ratio) {
                      return Customs.WMSCartesianChart(
                          title: "Employee Wise Task Summary",
                          titleFontSize: ratio*13,
                          xlabelFontSize: ratio * 10,
                          ylabelFontSize: ratio * 10,
                          ytitleFontSize: ratio * 12,
                          barCount: 1,
                          dataSources: [
                            state.activityDashboardData!.empwiseTaskSummary!
                                .map((e) => BarData(xLabel: e.status!.split('_')[0], yValue: e.count!, abbreviation: e.status!))
                                .toList()
                          ],
                          yAxisTitle: 'Number of orders',
                          legendVisibility: false,
                          barColors: [Color.fromRGBO(64, 133, 138, 1)]);
                    }),
                Customs.DashboardWidget(
                  size: Size(size.width * 0.25, size.height * 0.45),
                  margin: aspectRatio * 10,
                  loaderEnabled: isEnabled,
                  chartBuilder: (ratio) => Customs.WMSSfCircularChart(
                      ratio: ratio,
                      title: "Average Task Execution Time",
                      titleFontSize: ratio*13,
                      enableAnnotation: true,
                      annotationText: state.activityDashboardData!.avgTaskExecTime!,
                      props: Props(
                        dataSource: avgTime,
                        pointColorMapper: (p0, p1) {
                          if (p1 == 0) {
                            return const Color.fromARGB(255, 148, 74, 134);
                          } else {
                            return Colors.transparent;
                          }
                        },
                      )),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Customs.DashboardWidget(
                  size: Size(size.width * 0.25, size.height * 0.45),
                  margin: aspectRatio * 10,
                  loaderEnabled: isEnabled,
                  chartBuilder: (ratio) => Customs.WMSSfCircularChart(
                      ratio: ratio,
                      title: "Avg Pick Time",
                      titleFontSize: ratio*13,
                      enableAnnotation: true,
                      annotationText: state.activityDashboardData!.avgPickTime!,
                      props: Props(
                        dataSource: avgTime,
                        pointColorMapper: (p0, p1) {
                          if (p1 == 0) {
                            return const Color.fromARGB(255, 97, 92, 170);
                          } else {
                            return Colors.transparent;
                          }
                        },
                      )),
                ),
                Customs.DashboardWidget(
                        size: Size(size.width * 0.52, size.height * 0.45),
                        margin: aspectRatio*16,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Row(
                            children: [
                              SizedBox(
                                width: ratio*300,
                                child: Customs.WMSCartesianChart(
                                    title: 'Avg Time Taken by Employee',
                                    titleFontSize: ratio*6,
                                    xlabelFontSize: ratio * 5,
                                    ylabelFontSize: ratio * 5,
                                    ytitleFontSize: ratio * 6,
                                    barCount: 1,
                                    barColors: [Color.fromRGBO(147, 0, 120, 0.5)],
                                    yAxisTitle: 'Number of Tasks',
                                    dataSources: [
                                      selectedEmployees
                                          .map((e) => BarData(
                                              xLabel: e.replaceAll('_', ' '),
                                              yValue: state.activityDashboardData!.avgTimeTakenByEmp!.firstWhere((test) => test.status == e).count!,
                                              abbreviation: e))
                                          .toList()
                                    ])
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
                                              hintText: "Compare",
                                              // rangeSelection ? 'Choose' : "Compare",
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
                                          for (var empList in state.activityDashboardData!.empwiseTaskSummary!) {
                                            print(empList);
                                            employeeSuggestions.add(empList.status.toString());
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
                                                    suggestion.toString().replaceAll('_', ' '),
                                                    // style: TextStyle(fontSize: ),
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
                                              } else if (selectedEmployees.length < 10) {
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
                                                  emp.replaceAll("_", " "),
                                                  style: TextStyle(fontSize: size.height * 0.02),
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
                          );
                        }
                      ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

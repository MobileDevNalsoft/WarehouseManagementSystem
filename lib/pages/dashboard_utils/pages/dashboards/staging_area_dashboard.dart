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

  final List<PieData> avgPieData = [
    PieData(xData: 'resukt', yData: 81),
    PieData(xData: 'rest', yData: 19),
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
    return SingleChildScrollView(child: BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
      bool isEnabled = state.getStagingDashboardState != StagingDashboardState.success;
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
                      Customs.DashboardWidget(
                          size: Size(size.width * 0.25, size.height * 0.45),
                          margin: aspectRatio * 10,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: "Avg Lead Time",
                                titleFontSize: ratio*13,
                                enableAnnotation: true,
                                annotationText: '${state.stagingDashboardData!.avgLeadTime!}m',
                                annotationFontSize: ratio * 12,
                                props: Props(dataSource: avgPieData, pointColorMapper: (p0, p1) {
                                  if(p1 == 0){
                                    return const Color.fromARGB(255, 116, 204, 178);
                                  }else{
                                    return Colors.white;
                                  }
                                },));
                          }),
                      Customs.DashboardWidget(
                          size: Size(size.width * 0.25, size.height * 0.45),
                          margin: aspectRatio * 10,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: 'Today Order Summary',
                                titleFontSize: ratio*13,
                                legendVisibility: true,
                                series: SeriesName.pieSeries,
                                props: Props(
                                  dataSource: state.stagingDashboardData!.todayOrderSummary!
                                      .map((e) => PieData(xData: e.status!, yData: e.count!, text: e.count!.toString()))
                                      .toList(),
                                  radius: '${ratio*55}%',
                                  pointColorMapper: (p0, p1) {
                                    if (p1 == 0) {
                                      return const Color.fromARGB(255, 80, 175, 230);
                                    } else if (p1 == 1) {
                                      return const Color.fromARGB(255, 115, 102, 189);
                                    } else if (p1 == 2) {
                                      return const Color.fromARGB(255, 110, 196, 163);
                                    } else if (p1 == 3) {
                                      return const Color.fromARGB(255, 159, 177, 80);
                                    } else if (p1 == 4) {
                                      return const Color.fromARGB(255, 175, 83, 140);
                                    }
                                  },
                                ));
                          }),
                      Customs.DashboardWidget(
                        size: Size(size.width * 0.25, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Customs.WMSRadialGuage(
                          title: "Shipping Efficiency",
                          titleFontSize: ratio*16,
                          annotationHeight: ratio*120,
                                  annotationText: state.stagingDashboardData!.shippingEfficiency!,
                                  annotationFontSize: ratio*14,
                                  axisLineColor: Color.fromARGB(255, 189, 187, 64),
                                  radiusFactor: ratio*0.55,
                                  markerValue: int.parse(state.stagingDashboardData!.shippingEfficiency!.replaceAll('%', '')).toDouble() + 3
                        );
                        }
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Customs.DashboardWidget(
                        size: Size(size.width * 0.25, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Customs.WMSCartesianChart(
                                    title: 'Order Aging',
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.stagingDashboardData!.orderAging!
                                          .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                          .toList()
                                    ],
                                    yAxisTitle: 'Aging time',
                                    legendVisibility: false,
                                    barColors: [Colors.deepPurple.shade200]);
                        }
                      ),
                      Customs.DashboardWidget(
                          size: Size(size.width * 0.25, size.height * 0.45),
                          margin: aspectRatio * 10,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: "Fulfilment Time",
                                titleFontSize: ratio*13,
                                enableAnnotation: true,
                                annotationText: '${state.stagingDashboardData!.fulfilmentTime!.toString()}h',
                                annotationFontSize: ratio * 12,
                                props: Props(dataSource: avgPieData, pointColorMapper: (p0, p1) {
                                  if(p1 == 0){
                                    return Color.fromRGBO(189, 125, 177, 1);
                                  }else{
                                    return Colors.white;
                                  }
                                },));
                          }),
                      Customs.DashboardWidget(
                        size: Size(size.width * 0.25, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Customs.WMSCartesianChart(
                                    title: 'Daywise Order Summary',
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.stagingDashboardData!.daywiseOrderSummary!
                                              .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                              .toList()
                                    ],
                                    yAxisTitle: 'Number of orders',
                                    legendVisibility: false,
                                    barColors: [Colors.blueGrey.shade500]);
                        }
                      ),
                      
                    ],
                  ),
                  Row(
                    children: [
                      Customs.DashboardWidget(
                        size: Size(size.width * 0.25, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Customs.WMSCartesianChart(
                                    title: "Today Channel Wise Order Summary",
                                    titleFontSize: ratio*13,
                                    xlabelFontSize: ratio * 10,
                                    ylabelFontSize: ratio * 10,
                                    ytitleFontSize: ratio * 12,
                                    barCount: 1,
                                    dataSources: [
                                      state.stagingDashboardData!.todayChannelSummary!
                                              .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                              .toList()
                                    ],
                                    yAxisTitle: 'Number of orders',
                                    legendVisibility: false,
                                    barColors: [const Color.fromARGB(255, 182, 143, 103)]);
                        }
                      ),
                      Customs.DashboardWidget(
                        size: Size(size.width * 0.52, size.height * 0.45),
                        margin: aspectRatio*10,
                        loaderEnabled: isEnabled,
                        chartBuilder: (ratio) {
                        return Row(
                            children: [
                              SizedBox(
                                width: ratio*300,
                                child: Customs.WMSCartesianChart(
                                        title: 'User Efficiency',
                                        titleFontSize: ratio*6,
                                        xlabelFontSize: ratio * 5,
                                        ylabelFontSize: ratio * 5,
                                        ytitleFontSize: ratio * 6,
                                        barCount: 1,
                                        legendVisibility: false,
                                        dataSources: [
                                          isEnabled
                                              ? userEfficiencyGraphData
                                              : state.stagingDashboardData!.userwiseEfficiency!
                                                  .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                                  .toList()
                                        ],
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
                                                ),
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
                                                          scale: aspectRatio * 0.4,
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
                                                                      userEfficiencyGraphData.add(
                                                                          BarData(xLabel: suggestion, yValue: random.nextInt(10), abbreviation: suggestion));
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
                                        child: ListView(
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
                                                        style: TextStyle(fontSize: 22, overflow: TextOverflow.ellipsis),
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
                          );
                        }
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      );
    }));
  }
}

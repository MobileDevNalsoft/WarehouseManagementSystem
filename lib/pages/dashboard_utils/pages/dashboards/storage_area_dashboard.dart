import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';

import 'package:wmssimulator/pages/customs/customs.dart';

class StorageAreaDashboard extends StatefulWidget {
  StorageAreaDashboard({super.key});

  @override
  State<StorageAreaDashboard> createState() => _StorageAreaDashboardState();
}

class _StorageAreaDashboardState extends State<StorageAreaDashboard> {

  final List<PieData> chartData1 = [
    PieData(xData: 'David', yData: 81),
    PieData(xData: 'sd', yData: 19),
  ];

  late DashboardsBloc _dashboardsBloc;

  SuggestionsController<Object?> suggestionsController = SuggestionsController();
  late TextEditingController typeAheadController;
  late FocusNode typeAheadFocusNode;

  @override
  void initState() {
    super.initState();

    _dashboardsBloc = context.read<DashboardsBloc>();
    _dashboardsBloc.add(GetStorageDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return SingleChildScrollView(child: BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
      bool isEnabled = state.getStorageDashboardState != StorageDashboardState.success;
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
                        size: size,
                        loaderEnabled: isEnabled,
                        chartBuilder: (lsize) => Stack(
                          children: [
                            Customs.WMSSfCircularChart(
                                height: lsize.maxHeight,
                                width: lsize.maxWidth,
                                title: 'Location Utilization',
                                series: SeriesName.radialBar,
                                legendVisibility: true,
                                props: Props(
                                    dataSource: state.storageDashboardData!.locationUtilization!
                                        .where((e) => e.locType!.replaceAll('"', '').split('/')[1] == state.selectedLocType!)
                                        .first
                                        .typeUtil!
                                        .asMap()
                                        .entries
                                        .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                                        .toList(),
                                    maximumValue: state.storageDashboardData!.locationUtilization!
                                        .where((e) => e.locType!.replaceAll('"', '').split('/')[1] == state.selectedLocType!)
                                        .first
                                        .typeUtil!
                                        .map((e) => e.count!)
                                        .toList()
                                        .reduce((curr, next) => curr > next ? curr : next)
                                        .toDouble(),
                                    labelFontSize: lsize.maxHeight * 0.04,
                                    innerRadius: '30%',
                                    pointColorMapper: (datum, index) {
                                      if (index == 0) {
                                        return const Color.fromRGBO(139, 182, 162, 1);
                                      } else if (index == 1) {
                                        return const Color.fromRGBO(232, 212, 162, 1);
                                      } else {
                                        return const Color.fromRGBO(255, 116, 106, 1);
                                      }
                                    })),
                            Positioned(
                              top: lsize.maxHeight * 0.02,
                              right: 0,
                              child: TypeAheadField(
                                suggestionsController: suggestionsController,
                                builder: (context, textController, focusNode) {
                                  typeAheadController = textController;
                                  typeAheadFocusNode = focusNode;
                                  focusNode = focusNode;
                                  focusNode.addListener(() {
                                    if (focusNode.hasFocus) {
                                      textController.clear();
                                    }
                                  });
                                  if (state.selectedLocType != null) {
                                    textController.text = state.selectedLocType!;
                                  }
                                  return SizedBox(
                                    height: lsize.maxHeight * 0.08,
                                    width: lsize.maxWidth * 0.25,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        onTap: () {},
                                        cursorColor: Colors.black,
                                        cursorHeight: lsize.maxHeight * 0.05,
                                        style: TextStyle(fontSize: lsize.maxHeight * 0.03),
                                        decoration: InputDecoration(
                                          hintText: 'Choose',
                                          contentPadding:
                                              EdgeInsets.only(top: lsize.maxHeight * 0.02, left: lsize.maxWidth * 0.01, right: lsize.maxWidth * 0.015),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                                          hintStyle: const TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        controller: textController,
                                        focusNode: focusNode,
                                      ),
                                    ),
                                  );
                                },
                                suggestionsCallback: (pattern) {
                                  return state.storageDashboardData!.locationUtilization!
                                      .map((e) => e.locType!.replaceAll('"', '').split('/')[1])
                                      .where((e) => e.toLowerCase().contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) => Container(
                                  height: lsize.maxHeight * 0.1,
                                  width: lsize.minWidth * 0.1,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    suggestion.toString(),
                                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                onSelected: (suggestion) {
                                  typeAheadController.clear();
                                  typeAheadController.text = suggestion.toString();
                                  _dashboardsBloc.add(ChangeLocType(locType: suggestion.toString()));
                                  suggestionsController.close();
                                  suggestionsController.refresh();
                                },
                                constraints: BoxConstraints(maxHeight: lsize.maxHeight * 0.7, maxWidth: lsize.maxWidth * 0.3),
                              ),
                            )
                          ],
                        ),
                      ),
                      Customs.DashboardWidget(
                        size: size,
                        loaderEnabled: isEnabled,
                        chartBuilder: (lsize) => Customs.WMSSfCircularChart(
                            height: lsize.maxHeight,
                            width: lsize.maxWidth,
                            title: 'Warehouse Utilization',
                            legendVisibility: true,
                            props: Props(
                              dataSource: state.storageDashboardData!.warehouseUtilization!
                                  .asMap()
                                  .entries
                                  .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                                  .toList(),
                              labelFontSize: lsize.maxHeight * 0.04,
                              radius: '${lsize.maxHeight * 0.3}%',
                              pointColorMapper: (datum, index) {
                                if (index == 1) {
                                  return const Color.fromARGB(255, 102, 82, 156);
                                } else {
                                  return const Color.fromARGB(255, 178, 166, 209);
                                }
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(builder: (context, lsize) {
                          return isEnabled
                              ? Customs.DashboardLoader(lsize: lsize)
                              : Customs.WMSSfCircularChart(
                                  title: 'Inventory Summary',
                                  series: SeriesName.pieSeries,
                                  legendVisibility: true,
                                  props: Props(
                                    dataSource: state.storageDashboardData!.inventorySummary!
                                        .asMap()
                                        .entries
                                        .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                                        .toList(),
                                    labelFontSize: lsize.maxHeight * 0.04,
                                    pointColorMapper: (p0, p1) {
                                      if (p1 == 0) {
                                        return const Color.fromARGB(255, 148, 224, 214);
                                      } else if (p1 == 1) {
                                        return const Color.fromARGB(255, 184, 172, 149);
                                      } else {
                                        return const Color.fromARGB(255, 221, 152, 184);
                                      }
                                    },
                                  ));
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(builder: (context, lsize) {
                          return isEnabled
                              ? Customs.DashboardLoader(lsize: lsize)
                              : Customs.WMSSfCircularChart(
                                  title: 'Inventory Aging',
                                  series: SeriesName.pieSeries,
                                  legendVisibility: true,
                                  props: Props(
                                    dataSource: [
                                      PieData(xData: "< 30 Days", yData: state.storageDashboardData!.inventoryAging!.count30Days!.toDouble()),
                                      PieData(xData: "30 - 90 Days", yData: state.storageDashboardData!.inventoryAging!.count30To90Days!.toDouble()),
                                      PieData(xData: "> 90 Days", yData: state.storageDashboardData!.inventoryAging!.countGreaterThan90Days!.toDouble())
                                    ],
                                    labelFontSize: lsize.maxHeight * 0.04,
                                    pointColorMapper: (p0, p1) {
                                      if (p1 == 0) {
                                        return const Color.fromARGB(255, 148, 215, 224);
                                      } else if (p1 == 1) {
                                        return const Color.fromARGB(255, 159, 196, 161);
                                      } else {
                                        return const Color.fromARGB(255, 180, 140, 164);
                                      }
                                    },
                                  ));
                        }),
                      ),
                      Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(builder: (context, lsize) {
                          return isEnabled
                              ? Customs.DashboardLoader(lsize: lsize)
                              : Customs.WMSCartesianChart(
                                  title: 'Supplierwise Inventory',
                                  yAxisTitle: 'Number of Items',
                                  barCount: 1,
                                  legendVisibility: false,
                                  barColors: [Colors.teal],
                                  dataSources:[state.storageDashboardData!.supplierWiseInventory!
                                              .map(
                                                (e) => BarData(xLabel: e.supplier.toString(), yValue: e.origQty!, abbreviation: e.supplier!),
                                              )
                                              .toList()
                                        ]);
                        }),
                      ),
                      Container(
                          margin: EdgeInsets.all(aspectRatio * 8),
                          height: size.height * 0.45,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                          padding: EdgeInsets.all(size.height * 0.035),
                          alignment: Alignment.center,
                          child: LayoutBuilder(builder: (context, lsize) {
                            return isEnabled
                                ? Customs.DashboardLoader(lsize: lsize)
                                : Customs.WMSSfCircularChart(
                                    title: "Avg Storage Time",
                                    enableAnnotation: true,
                                    annotationText: "${state.storageDashboardData!.averageStorageTime.toString()}d",
                                    annotationHeight: lsize.maxHeight * 0.3,
                                    annotationFontSize: lsize.maxHeight * 0.055,
                                    props: Props(
                                      dataSource: chartData1,
                                      innerRadius: '${lsize.maxHeight * 0.15}%',
                                      radius: '${lsize.maxHeight * 0.3}%',
                                      pointColorMapper: (p0, p1) {
                                        if (p1 == 0) {
                                          return const Color.fromARGB(255, 151, 174, 206);
                                        } else {
                                          return Colors.white;
                                        }
                                      },
                                    ));
                          })),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.all(aspectRatio * 8),
                          height: size.height * 0.45,
                          width: size.width * 0.25,
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                          padding: EdgeInsets.all(size.height * 0.035),
                          alignment: Alignment.center,
                          child: LayoutBuilder(builder: (context, lsize) {
                            return isEnabled
                                ? Customs.DashboardLoader(lsize: lsize)
                                : Customs.WMSRadialGuage(
                                  title: "Cycle Count Accuracy",
                                  annotationHeight: lsize.maxHeight*0.35,
                                  annotationText: '${state.storageDashboardData!.cycleCountAccuracy!.toStringAsFixed(2)}%',
                                  annotationFontSize: lsize.maxHeight*0.05,
                                  radiusFactor: lsize.maxHeight*0.003,
                                  markerValue: state.storageDashboardData!.cycleCountAccuracy!
                                );
                          })),
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

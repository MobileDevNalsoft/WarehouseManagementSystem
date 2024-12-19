import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
    return SingleChildScrollView(child: 
    BlocBuilder<DashboardsBloc, DashboardsState>(
      buildWhen: (previous, current) => previous.getStorageDashboardState != current.getStorageDashboardState,
      builder: (context, state) {
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
                          size: Size(size.width * 0.25, size.height * 0.45),
                          margin: aspectRatio * 10,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Stack(
                              children: [
                                Customs.WMSSfCircularChart(
                                    ratio: ratio,
                                    title: 'Location Utilization',
                                    titleFontSize: ratio * 13,
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
                                        labelFontSize: ratio * 10,
                                        maximumValue: state.storageDashboardData!.locationUtilization!
                                            .where((e) => e.locType!.replaceAll('"', '').split('/')[1] == state.selectedLocType!)
                                            .first
                                            .typeUtil!
                                            .map((e) => e.count!)
                                            .toList()
                                            .reduce((curr, next) => curr > next ? curr : next)
                                            .toDouble(),
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
                                  top: ratio * 5,
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
                                        height: ratio * 30,
                                        width: ratio * 100,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            onTap: () {},
                                            cursorColor: Colors.black,
                                            cursorHeight: ratio * 10,
                                            style: TextStyle(fontSize: ratio * 10),
                                            decoration: InputDecoration(
                                              hintText: 'Choose',
                                              contentPadding: EdgeInsets.only(top: ratio * 2, left: ratio * 1, right: ratio * 1.5),
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
                                      height: ratio * 30,
                                      width: ratio * 100,
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
                                    constraints: BoxConstraints(maxHeight: ratio * 300, maxWidth: ratio * 120),
                                  ),
                                )
                              ],
                            );
                          }),
                      Customs.DashboardWidget(
                          size: Size(size.width * 0.25, size.height * 0.45),
                          margin: aspectRatio * 10,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: 'Warehouse Utilization',
                                titleFontSize: ratio * 14,
                                legendVisibility: true,
                                props: Props(
                                  dataSource: state.storageDashboardData!.warehouseUtilization!
                                      .asMap()
                                      .entries
                                      .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                                      .toList(),
                                  labelFontSize: ratio * 10,
                                  radius: '${ratio * 55}%',
                                  innerRadius: '${ratio * 40}%',
                                  pointColorMapper: (datum, index) {
                                    if (index == 1) {
                                      return const Color.fromARGB(255, 102, 82, 156);
                                    } else {
                                      return const Color.fromARGB(255, 178, 166, 209);
                                    }
                                  },
                                  onPointTap: (pointInteractionDetails) {
                                    _dashboardsBloc.add(GetStorageDrilldownData(facilityID: 243, flag: 'WAREHOUSE UTILIZATION'));
                                    showGeneralDialog(
                                      context: context,
                                      barrierColor: Colors.black45,
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
                                        return BlocBuilder<DashboardsBloc, DashboardsState>(
                                          builder: (context, state) {
                                            bool isEnabled = state.getStorageDrilldownState != StorageDrilldownState.success;
                                            return Skeletonizer(
                                              enableSwitchAnimation: true,
                                              enabled: isEnabled,
                                              child: Container(
                                                height: size.height*0.5,
                                                width: size.width*0.25,
                                                padding: EdgeInsets.only(left: size.height*0.02, right: size.height*0.02, bottom: size.height*0.02),
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                                child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Material(
                                                          color: Colors.white,
                                                          child: Row(
                                                            children: [
                                                              Expanded(flex: 1,child: Text('Available', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height*0.02),)),
                                                              Expanded(flex: 1,child: Text('Occupied', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height*0.02),))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 9,
                                                        child: Material(
                                                          color: Colors.white,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: ListView.builder(
                                                                  itemCount: isEnabled ? 15 : state.warehouseUtilization!.available!.length,
                                                                  itemBuilder: (context, index) => Container(height: size.height*0.045, width: size.width*0.15,child: Text(isEnabled ? 'LOCATION' : state.warehouseUtilization!.available![index], textAlign: TextAlign.center,)),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: ListView.builder(
                                                                  itemCount: isEnabled ? 15 : state.warehouseUtilization!.occupied!.length,
                                                                  itemBuilder: (context, index) => Container(height: size.height*0.045, width: size.width*0.15,child: Text(isEnabled ? 'LOCATION' : state.warehouseUtilization!.occupied![index], textAlign: TextAlign.center)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                    );
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
                                title: 'Inventory Summary',
                                titleFontSize: ratio * 14,
                                series: SeriesName.pieSeries,
                                legendVisibility: true,
                                props: Props(
                                  dataSource: state.storageDashboardData!.inventorySummary!
                                      .asMap()
                                      .entries
                                      .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                                      .toList(),
                                  labelFontSize: ratio * 10,
                                  pointColorMapper: (p0, p1) {
                                    if (p1 == 0) {
                                      return const Color.fromARGB(255, 148, 224, 214);
                                    } else if (p1 == 1) {
                                      return const Color.fromARGB(255, 184, 172, 149);
                                    } else {
                                      return const Color.fromARGB(255, 221, 152, 184);
                                    }
                                  },
                                  onPointTap: (pointInteractionDetails) {
                                    _dashboardsBloc.add(GetStorageDrilldownData(facilityID: 243, flag: 'INVENTORY SUMMARY'));
                                    showGeneralDialog(
                                      context: context,
                                      barrierColor: Colors.black45,
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
                                        return BlocBuilder<DashboardsBloc, DashboardsState>(
                                          builder: (context, state) {
                                            bool isEnabled = state.getStorageDrilldownState != StorageDrilldownState.success;
                                            return Skeletonizer(
                                              enableSwitchAnimation: true,
                                              enabled: isEnabled,
                                              child: Container(
                                                height: size.height*0.5,
                                                width: size.width*0.35,
                                                padding: EdgeInsets.only(left: size.height*0.02, right: size.height*0.02, bottom: size.height*0.02),
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                                child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Material(
                                                          color: Colors.white,
                                                          child: Row(
                                                            children: [
                                                              Expanded(flex: 1,child: Text('In Stock', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height*0.02),)),
                                                              Expanded(flex: 1,child: Text('Running Out of Stock', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height*0.02),)),
                                                              Expanded(flex: 1,child: Text('Out of Stock', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height*0.02),))
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 9,
                                                        child: Material(
                                                          color: Colors.white,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: ListView.builder(
                                                                  itemCount: isEnabled ? 15 : state.inventorySummary!.inStock!.length,
                                                                  itemBuilder: (context, index) => Container(height: size.height*0.045, width: size.width*0.15,child: Text(isEnabled ? 'ITEM' : state.inventorySummary!.inStock![index], textAlign: TextAlign.center,)),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: ListView.builder(
                                                                  itemCount: isEnabled ? 15 : state.inventorySummary!.runningOutOfStock!.length,
                                                                  itemBuilder: (context, index) => Container(height: size.height*0.045, width: size.width*0.15,child: Text(isEnabled ? 'ITEM' : state.inventorySummary!.runningOutOfStock![index], textAlign: TextAlign.center)),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: ListView.builder(
                                                                  itemCount: isEnabled ? 15 : state.inventorySummary!.outOfStock!.length,
                                                                  itemBuilder: (context, index) => Container(height: size.height*0.045, width: size.width*0.15,child: Text(isEnabled ? 'ITEM' : state.inventorySummary!.outOfStock![index], textAlign: TextAlign.center)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                    );
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
                            return Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: 'Inventory Aging',
                                titleFontSize: ratio * 14,
                                series: SeriesName.pieSeries,
                                legendVisibility: true,
                                props: Props(
                                  dataSource: [
                                    PieData(xData: "< 30 Days", yData: state.storageDashboardData!.inventoryAging!.count30Days!.toDouble()),
                                    PieData(xData: "30 - 90 Days", yData: state.storageDashboardData!.inventoryAging!.count30To90Days!.toDouble()),
                                    PieData(xData: "> 90 Days", yData: state.storageDashboardData!.inventoryAging!.countGreaterThan90Days!.toDouble())
                                  ],
                                  labelFontSize: ratio * 10,
                                  radius: '${ratio * 60}%',
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
                      Customs.DashboardWidget(
                          size: Size(size.width * 0.25, size.height * 0.45),
                          margin: aspectRatio * 10,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Customs.WMSCartesianChart(
                                title: 'Supplierwise Inventory',
                                titleFontSize: ratio * 14,
                                xlabelFontSize: ratio * 10,
                                ylabelFontSize: ratio * 10,
                                ytitleFontSize: ratio * 12,
                                yAxisTitle: 'Number of Items',
                                barCount: 1,
                                legendVisibility: false,
                                barColors: [
                                  Colors.teal
                                ],
                                dataSources: [
                                  state.storageDashboardData!.supplierWiseInventory!
                                      .map(
                                        (e) => BarData(xLabel: e.supplier.toString(), yValue: e.origQty!, abbreviation: e.supplier!),
                                      )
                                      .toList()
                                ]);
                          }),
                      Customs.DashboardWidget(
                          size: Size(size.width * 0.25, size.height * 0.45),
                          margin: aspectRatio * 10,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Customs.WMSSfCircularChart(
                                ratio: ratio,
                                title: "Avg Storage Time",
                                titleFontSize: ratio * 13,
                                enableAnnotation: true,
                                annotationText: "${state.storageDashboardData!.averageStorageTime.toString()}d",
                                props: Props(
                                  dataSource: chartData1,
                                  pointColorMapper: (p0, p1) {
                                    if (p1 == 0) {
                                      return const Color.fromARGB(255, 151, 174, 206);
                                    } else {
                                      return Colors.white;
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
                          margin: aspectRatio * 12,
                          loaderEnabled: isEnabled,
                          chartBuilder: (ratio) {
                            return Customs.WMSRadialGuage(
                                title: "Cycle Count Accuracy",
                                titleFontSize: ratio * 16,
                                annotationHeight: ratio * 120,
                                annotationText: '${state.storageDashboardData!.cycleCountAccuracy!.toStringAsFixed(2)}%',
                                annotationFontSize: ratio * 12,
                                radiusFactor: ratio * 0.55,
                                markerValue: state.storageDashboardData!.cycleCountAccuracy!);
                          }),
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

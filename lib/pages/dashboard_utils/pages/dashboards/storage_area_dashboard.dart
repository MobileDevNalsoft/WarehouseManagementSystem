import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';

import 'package:wmssimulator/pages/customs/customs.dart';

class StorageAreaDashboard extends StatefulWidget {
  const StorageAreaDashboard({super.key});

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
    return BlocBuilder<DashboardsBloc, DashboardsState>(
        buildWhen: (previous, current) => previous.getStorageDashboardState != current.getStorageDashboardState,
        builder: (context, state) {
          bool isEnabled = state.getStorageDashboardState != StorageDashboardState.success;
          return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: size.height * 0.5),
            children: [
              BlocBuilder<DashboardsBloc, DashboardsState>(
                  buildWhen: (previous, current) => previous.selectedLocType != current.selectedLocType,
                  builder: (context, state) {
                    return Customs.DashboardWidget(
                        height: size.height * 0.45,
                        margin: size.height * 0.02,
                        loaderEnabled: isEnabled,
                        chartBuilder: (lsize) {
                          return Stack(
                            children: [
                              Customs.WMSSfCircularChart(
                                  lsize: lsize,
                                  title: 'Location Utilization',
                                  titleFontSize: 13,
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
                                      labelFontSize: 12,
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
                                top: lsize.maxHeight * 0.025,
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
                                          cursorHeight: lsize.maxHeight * 0.06,
                                          style: const TextStyle(fontSize: 11),
                                          decoration: InputDecoration(
                                            hintText: 'Choose',
                                            contentPadding:
                                                EdgeInsets.only(top: lsize.maxHeight * 0.02, left: lsize.maxHeight * 0.02, right: lsize.maxWidth * 0.02),
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
                                    height: lsize.maxHeight * 0.08,
                                    width: lsize.maxWidth * 0.2,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      suggestion.toString(),
                                      style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 11),
                                    ),
                                  ),
                                  onSelected: (suggestion) {
                                    typeAheadController.clear();
                                    typeAheadController.text = suggestion.toString();
                                    _dashboardsBloc.add(ChangeLocType(locType: suggestion.toString()));
                                    suggestionsController.close();
                                    suggestionsController.refresh();
                                  },
                                  constraints: BoxConstraints(maxHeight: lsize.maxHeight * 0.5, maxWidth: lsize.maxWidth * 0.3),
                                ),
                              )
                            ],
                          );
                        });
                  }),
              Customs.DashboardWidget(
                  height: size.height * 0.45,
                  margin: size.height * 0.02,
                  loaderEnabled: isEnabled,
                  chartBuilder: (lsize) {
                    return Customs.WMSSfCircularChart(
                        lsize: lsize,
                        title: 'Warehouse Utilization',
                        titleFontSize: 13,
                        legendVisibility: true,
                        props: Props(
                          dataSource: state.storageDashboardData!.warehouseUtilization!
                              .asMap()
                              .entries
                              .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                              .toList(),
                          labelFontSize: 12,
                          radius: '${lsize.maxWidth * 0.23}%',
                          innerRadius: '${lsize.maxWidth * 0.12}%',
                          pointColorMapper: (datum, index) {
                            if (index == 1) {
                              return const Color.fromARGB(255, 102, 82, 156);
                            } else {
                              return const Color.fromARGB(255, 178, 166, 209);
                            }
                          },
                          onPointTap: (pointInteractionDetails) {
                            _dashboardsBloc.add(GetStorageDrilldownData(facilityID: 243, flag: 'WAREHOUSE UTILIZATION'));
                            Customs.DrillDownDialog(
                              context: context,
                              dataSources: [
                                DataSource(
                                    dataGridSourceBuilder: (isEnabled, state) =>
                                        DrillDownDataSource(data: isEnabled ? dummyData : state.warehouseUtilization!.available!, columnName: 'Available'),
                                    columnName: 'Available'),
                                DataSource(
                                    dataGridSourceBuilder: (isEnabled, state) =>
                                        DrillDownDataSource(data: isEnabled ? dummyData : state.warehouseUtilization!.occupied!, columnName: 'Occupied'),
                                    columnName: 'Occupied'),
                              ],
                              onExport: (state) => Customs.sendMail(context: context, dashboardName: 'Warehouse Utilization', data: [
                                ['Available', ...state.warehouseUtilization!.available!],
                                ['Occupied', ...state.warehouseUtilization!.occupied!]
                              ]),
                            );
                          },
                        ));
                  }),
              Customs.DashboardWidget(
                  height: size.height * 0.45,
                  margin: size.height * 0.02,
                  loaderEnabled: isEnabled,
                  chartBuilder: (lsize) {
                    return Customs.WMSSfCircularChart(
                        lsize: lsize,
                        title: 'Inventory Summary',
                        titleFontSize: 13,
                        series: SeriesName.pieSeries,
                        legendVisibility: true,
                        props: Props(
                          dataSource: state.storageDashboardData!.inventorySummary!
                              .asMap()
                              .entries
                              .map((e) => PieData(xData: e.value.status!, yData: e.value.count!))
                              .toList(),
                          labelFontSize: 12,
                          pointColorMapper: (p0, p1) {
                            if (p1 == 0) {
                              return const Color.fromARGB(255, 148, 224, 214);
                            } else if (p1 == 1) {
                              return const Color.fromARGB(255, 184, 172, 149);
                            } else {
                              return const Color.fromARGB(255, 221, 152, 184);
                            }
                          },
                          radius: '${lsize.maxWidth * 0.27}%',
                          onPointTap: (pointInteractionDetails) {
                            _dashboardsBloc.add(GetStorageDrilldownData(facilityID: 243, flag: 'INVENTORY SUMMARY'));
                            Customs.DrillDownDialog(
                              context: context,
                              dataSources: [
                                DataSource(
                                    dataGridSourceBuilder: (isEnabled, state) =>
                                        DrillDownDataSource(data: isEnabled ? dummyData : state.inventorySummary!.inStock!, columnName: 'In Stock'),
                                    columnName: 'In Stock'),
                                DataSource(
                                    dataGridSourceBuilder: (isEnabled, state) => DrillDownDataSource(
                                        data: isEnabled ? dummyData : state.inventorySummary!.runningOutOfStock!, columnName: 'Running Out of Stock'),
                                    columnName: 'Running Out of Stock'),
                                DataSource(
                                    dataGridSourceBuilder: (isEnabled, state) =>
                                        DrillDownDataSource(data: isEnabled ? dummyData : state.inventorySummary!.outOfStock!, columnName: 'Out of Stock'),
                                    columnName: 'Out of Stock')
                              ],
                              onExport: (state) => Customs.sendMail(context: context, dashboardName: 'Inventory Summary', data: [
                                ['In Stock', ...state.inventorySummary!.inStock!],
                                ['Running Out of Stock', ...state.inventorySummary!.runningOutOfStock!],
                                ['Out of Stock', ...state.inventorySummary!.outOfStock!]
                              ]),
                            );
                          },
                        ));
                  }),
              Customs.DashboardWidget(
                  height: size.height * 0.45,
                  margin: size.height * 0.02,
                  loaderEnabled: isEnabled,
                  chartBuilder: (lsize) {
                    return Customs.WMSSfCircularChart(
                        lsize: lsize,
                        title: 'Inventory Aging',
                        titleFontSize: 13,
                        series: SeriesName.pieSeries,
                        legendVisibility: true,
                        props: Props(
                          dataSource: [
                            PieData(xData: "< 30 Days", yData: state.storageDashboardData!.inventoryAging!.count30Days!.toDouble()),
                            PieData(xData: "30 - 90 Days", yData: state.storageDashboardData!.inventoryAging!.count30To90Days!.toDouble()),
                            PieData(xData: "> 90 Days", yData: state.storageDashboardData!.inventoryAging!.countGreaterThan90Days!.toDouble())
                          ],
                          labelFontSize: 12,
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
                  height: size.height * 0.45,
                  margin: size.height * 0.02,
                  loaderEnabled: isEnabled,
                  chartBuilder: (lsize) {
                    return Customs.WMSCartesianChart(
                        title: 'Supplierwise Inventory',
                        titleFontSize: 13,
                        xlabelFontSize: 11,
                        ylabelFontSize: 11,
                        ytitleFontSize: 13,
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
                  height: size.height * 0.45,
                  margin: size.height * 0.02,
                  loaderEnabled: isEnabled,
                  chartBuilder: (lsize) {
                    return Customs.WMSSfCircularChart(
                        lsize: lsize,
                        title: "Avg Storage Time",
                        titleFontSize: 13,
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
              Customs.DashboardWidget(
                  height: size.height * 0.45,
                  margin: size.height * 0.02,
                  loaderEnabled: isEnabled,
                  chartBuilder: (lsize) {
                    return Customs.WMSRadialGuage(
                        title: "Cycle Count Accuracy",
                        titleFontSize: 15,
                        annotationHeight: lsize.maxHeight * 0.35,
                        annotationText: '${state.storageDashboardData!.cycleCountAccuracy!.toStringAsFixed(2)}%',
                        annotationFontSize: 15,
                        radiusFactor: lsize.maxHeight * 0.0021,
                        markerValue: state.storageDashboardData!.cycleCountAccuracy!);
                  }),
            ],
          );
        });
  }
}

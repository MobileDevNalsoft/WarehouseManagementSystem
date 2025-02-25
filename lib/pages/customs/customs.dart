// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // Import the HTML library

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel; // Ensure you have this package
import 'package:wmssimulator/bloc/container_management/container_bloc.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/bloc/work_queue/work_queue_bloc.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/inits/web_service.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/models/task_model.dart';
import 'package:wmssimulator/pages/customs/hover_dropdown.dart';
import 'package:wmssimulator/pages/customs/users_builder.dart';

class Customs {
  static Widget DataSheet({required Size size, required String title, required List<Widget> children, controller, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: const Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)]),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.height * 0.02),
          margin: EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.004, right: size.height * 0.01),
          height: size.height * 0.06,
          width: size.width * 0.22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: size.width * 0.012, letterSpacing: 1.6, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(
                  onTap: () async {
                    getIt<WebService>().inAppWebViewController!.evaluateJavascript(
                        source:
                            'switchToMainCam("${await context.read<WarehouseInteractionBloc>().state.inAppWebViewController!.webStorage.localStorage.getItem(key: "rack_cam") == "storageArea" ? "storageArea" : "compoundArea"}")');
                    getIt<WebService>().inAppWebViewController!.evaluateJavascript(source: 'resetBinColors()');

                    context.read<WarehouseInteractionBloc>().add(SelectedObject(dataFromJS: const {"object": "null"}, clearSearchText: true));

                    getIt<WebService>().inAppWebViewController!.evaluateJavascript(source: 'resetTrucksAnimation()');
                  },
                  child: const Icon(Icons.cancel_rounded, color: Colors.white))
            ],
          ),
        ),
        Container(
          height: size.height * 0.86,
          width: size.width * 0.22,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: const Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)]),
          padding: EdgeInsets.all(size.height * 0.012),
          child: LayoutBuilder(builder: (context, layout) {
            return Column(
              children: [Gap(size.height * 0.01), ...children],
            );
          }),
        ),
      ],
    );
  }

  static Widget DashboardWidget(
      {double height = 150, double? margin, Decoration? decoration, bool loaderEnabled = true, required Widget Function(BoxConstraints lsize) chartBuilder}) {
    return Container(
      margin: EdgeInsets.all(margin ?? 0),
      height: height,
      decoration: decoration ?? BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
      padding: EdgeInsets.all(height * 0.035),
      alignment: Alignment.center,
      child: LayoutBuilder(builder: (context, lsize) {
        return loaderEnabled ? DashboardLoader(lsize: lsize) : chartBuilder(lsize);
      }),
    );
  }

  static Widget ElevatedDashboardWidget(
      {Size size = const Size(100, 100),
      required BuildContext context,
      double? margin,
      required int index,
      required Widget Function(double ratio, DashboardsState state) chartBuilder,
      bool Function(DashboardsState, DashboardsState)? buildWhen}) {
    DashboardsBloc dashboardsBloc = context.read<DashboardsBloc>();
    return Stack(
      children: [
        BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
          return MouseRegion(
            onEnter: (event) {
              state.elevates![index] = true;
              dashboardsBloc.add(ElevateDashboard(elevates: state.elevates!));
            },
            onExit: (event) {
              state.elevates![index] = false;
              dashboardsBloc.add(ElevateDashboard(elevates: state.elevates!));
            },
            child: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: state.elevates![index] == true ? Colors.black : Colors.grey, blurRadius: 5)]),
            ),
          );
        }),
        BlocBuilder<DashboardsBloc, DashboardsState>(
            buildWhen: buildWhen,
            builder: (context, state) {
              bool isEnabled = state.getDockDashboardState != DockDashboardState.success;
              return IgnorePointer(
                child: Container(
                  margin: EdgeInsets.all(margin ?? 0),
                  padding: EdgeInsets.all(size.height * 0.035),
                  height: size.height,
                  width: size.width,
                  child: LayoutBuilder(builder: (context, lsize) {
                    double aspectRatio;
                    if (lsize.maxHeight > lsize.maxWidth) {
                      aspectRatio = lsize.maxHeight / lsize.maxWidth;
                    } else {
                      aspectRatio = lsize.maxWidth / lsize.maxHeight;
                    }
                    return isEnabled ? DashboardLoader(lsize: lsize) : chartBuilder(aspectRatio, state);
                  }),
                ),
              );
            })
      ],
    );
  }

  static Widget MapInfo({required Size size, required List<String> keys, required List<String> values}) {
    return Card(
      child: Row(
        children: [
          Gap(size.width * 0.025),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                keys.length * 2 - 1,
                (index) => index % 2 == 0 ? Text(keys[index ~/ 2]) : Gap(size.height * 0.02),
              )),
          Gap(size.width * 0.01),
          Column(
              children: List.generate(
            keys.length * 2 - 1,
            (index) => index % 2 == 0 ? const Text(':') : Gap(size.height * 0.02),
          )),
          Gap(size.width * 0.01),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                keys.length * 2 - 1,
                (index) => index % 2 == 0 ? Text(values[index ~/ 2]) : Gap(size.height * 0.02),
              ))
        ],
      ),
    );
  }

  static Widget WorkflowLayout({required Size size, required int buttonIndex, required Widget child, required void Function()? onApproved, required void Function()? onRejected}) {
    List<String> buttons = ['Pending', 'Completed'];

    return Column(
      children: [
        Container(
          height: size.height * 0.07,
          width: size.width * 0.18,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: Color.fromRGBO(68, 98, 136, 1), borderRadius: BorderRadius.all(Radius.circular(50))),
          padding: EdgeInsets.all(size.height * 0.01),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            itemCount: buttons.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                context.read<WorkflowBloc>().add(ButtonClicked(index: index));
              },
              child: Container(
                width: size.width * 0.08,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.0028),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: buttonIndex == index ? Colors.white : const Color.fromRGBO(12, 46, 87, 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  buttons[index],
                  style: TextStyle(color: buttonIndex == index ? Colors.black : Colors.white),
                ),
              ),
            ),
          ),
        ),
        Gap(size.height * 0.02),
        Expanded(
          child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
              padding: EdgeInsets.all(size.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (buttonIndex == 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: onApproved,
                          child: Text('Approve'),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        Gap(size.height * 0.01),
                        TextButton(
                          onPressed: onRejected,
                          child: Text('Reject'),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  Gap(size.height * 0.02),
                  child,
                ],
              )),
        ),
      ],
    );
  }

  static Widget WMSCartesianChart(
      {String title = "title",
      double titleFontSize = 16,
      double xlabelFontSize = 16,
      double ylabelFontSize = 16,
      double ytitleFontSize = 16,
      int barCount = 1,
      List<List<BarData>>? dataSources,
      String yAxisTitle = "title",
      List<Color> barColors = const [Colors.blue],
      bool? legendVisibility}) {
    return LayoutBuilder(builder: (context, constraints) {
      return SfCartesianChart(
          title: ChartTitle(text: title, alignment: ChartAlignment.center, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize)),
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(fontSize: xlabelFontSize),
            majorGridLines: const MajorGridLines(
              width: 0,
            ),
            labelRotation: -90,
            majorTickLines: const MajorTickLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
          legend: Legend(
            isVisible: legendVisibility ?? false,
            alignment: ChartAlignment.center,
            itemPadding: 0,
            padding: 0,
            position: LegendPosition.top,
            legendItemBuilder: (legendText, series, point, seriesIndex) => SizedBox(
              height: constraints.maxHeight * 0.1,
              width: constraints.maxWidth * 0.2,
              child: Row(
                children: <Widget>[
                  Container(
                    width: constraints.maxHeight * 0.05,
                    height: constraints.maxWidth * 0.05,
                    decoration: BoxDecoration(color: barColors[seriesIndex], shape: BoxShape.circle), // Use series color for icon
                  ),
                  const SizedBox(width: 8), // Space between icon and text
                  Text(seriesIndex == 0 ? 'IN' : 'OUT'), // Custom legend text
                ],
              ),
            ),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: yAxisTitle, textStyle: TextStyle(fontSize: ytitleFontSize)),
            // axisLabelFormatter: (axisLabelRenderArgs) => ChartAxisLabel('', TextStyle()),
            labelStyle: TextStyle(fontSize: ylabelFontSize),
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
          enableAxisAnimation: true,
          series: List.generate(
            barCount,
            (index) => ColumnSeries<BarData, String>(
              spacing: 0.15,
              dataSource: dataSources![index],
              xValueMapper: (BarData data, _) => data.xLabel,
              yValueMapper: (BarData data, _) => data.yValue,
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [barColors[index], Colors.black54],
                stops: const [0.8, 1],
              ),
              dataLabelMapper: (datum, index) => datum.yValue.toString(),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                useSeriesColor: true,
                builder: (data, point, series, pointIndex, seriesIndex) => Text(
                  (data as BarData).yValue.toString(),
                  style: TextStyle(color: Colors.black, fontSize: constraints.maxHeight * 0.04),
                ),
              ),
              width: 0.6,
            ),
          ));
    });
  }

  static Widget WMSPieChart({required String title, List<PieData>? dataSource, Color? Function(PieData, int)? pointColorMapper, bool legendVisibility = false}) {
    return SfCircularChart(
        title: ChartTitle(
            text: title,
            alignment: ChartAlignment.center,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        legend: Legend(
          isVisible: legendVisibility,
          alignment: ChartAlignment.far,
        ),
        margin: EdgeInsets.zero,
        series: <PieSeries<PieData, String>>[
          PieSeries<PieData, String>(
              explode: true,
              explodeIndex: 0,
              radius: '50%',
              dataSource: dataSource,
              pointColorMapper: pointColorMapper,
              xValueMapper: (PieData data, _) => data.xData,
              yValueMapper: (PieData data, _) => data.yData,
              dataLabelMapper: (PieData data, _) => data.text,
              enableTooltip: true,
              dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 16), labelAlignment: ChartDataLabelAlignment.top)),
        ]);
  }

  static Widget WMSRadialGuage(
      {String title = 'Title',
      double titleFontSize = 16,
      double annotationHeight = 50,
      String annotationText = 'AText',
      double annotationFontSize = 16,
      double radiusFactor = 0.95,
      Color axisLineColor = const Color.fromARGB(255, 86, 185, 152),
      double markerValue = 0}) {
    return Gauges.SfRadialGauge(
      title: Gauges.GaugeTitle(text: title, alignment: Gauges.GaugeAlignment.center, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize)),
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
                  height: annotationHeight,
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
                    annotationText,
                    style: TextStyle(fontSize: annotationFontSize),
                  ),
                ))
          ],
          axisLineStyle: Gauges.AxisLineStyle(thickness: 35, color: axisLineColor, cornerStyle: Gauges.CornerStyle.bothCurve),
          showTicks: false,
          showLabels: false,
          radiusFactor: radiusFactor,
          pointers: [
            Gauges.MarkerPointer(
              value: markerValue,
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
    );
  }

  static Widget WMSSfCircularChart(
      {required BoxConstraints lsize,
      String title = 'Title',
      double titleFontSize = 16,
      SeriesName series = SeriesName.doughnut,
      Props? props,
      bool legendVisibility = false,
      bool enableAnnotation = false,
      String? contentText,
      String annotationText = 'AText',
      double annotationFontSize = 16}) {
    return SfCircularChart(
      title: ChartTitle(text: title, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize)),
      legend: Legend(
        isVisible: legendVisibility,
        alignment: ChartAlignment.far,
      ),
      annotations: enableAnnotation
          ? <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Container(
                    height: lsize.maxHeight * 0.3,
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
                      annotationText,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: annotationFontSize,
                      ),
                    )),
              ),
            ]
          : [],
      series: <CircularSeries>[
        series == SeriesName.doughnut
            ? DoughnutSeries<PieData, String>(
                dataSource: props!.dataSource,
                xValueMapper: (PieData data, _) => data.xData,
                yValueMapper: (PieData data, _) => data.yData,
                onPointTap: props.onPointTap,
                dataLabelSettings: DataLabelSettings(isVisible: enableAnnotation ? false : true, textStyle: TextStyle(fontSize: props.labelFontSize, fontWeight: FontWeight.bold)),
                radius: props.radius ?? '${lsize.maxWidth * 0.18}%', // Adjust the radius as needed
                innerRadius: props.innerRadius ?? '${lsize.maxWidth * 0.15}%', // Optional: adjust for a thinner ring
                pointColorMapper: props.pointColorMapper,
              )
            : series == SeriesName.radialBar
                ? RadialBarSeries<PieData, String>(
                    dataSource: props!.dataSource,
                    maximumValue: props.maximumValue,
                    cornerStyle: CornerStyle.bothCurve,
                    radius: props.radius ?? '${lsize.maxWidth * 0.2}%', // Adjust the radius as needed
                    innerRadius: props.innerRadius ?? '${lsize.maxWidth * 0.1}%', // Optional: adjust for a thinner ring
                    dataLabelSettings: DataLabelSettings(
                        // Renders the data label
                        isVisible: true,
                        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: props.labelFontSize),
                        alignment: ChartAlignment.center),
                    pointColorMapper: props.pointColorMapper,
                    onPointTap: props.onPointTap,
                    xValueMapper: (PieData data, _) => data.xData,
                    yValueMapper: (PieData data, _) => data.yData,
                  )
                : PieSeries<PieData, String>(
                    dataSource: props!.dataSource,
                    dataLabelSettings: DataLabelSettings(
                        // Renders the data label
                        isVisible: true,
                        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: props.labelFontSize),
                        alignment: ChartAlignment.center),
                    radius: props.radius ?? '${lsize.maxWidth * 0.2}%',
                    pointColorMapper: props.pointColorMapper,
                    onPointTap: props.onPointTap,
                    xValueMapper: (PieData data, _) => data.xData,
                    yValueMapper: (PieData data, _) => data.yData,
                  )
      ],
    );
  }

  static void DrillDownDialog({
    required BuildContext context,
    required List<DataSource> dataSources,
    required void Function(DashboardsState state) onExport,
  }) {
    Size size = MediaQuery.of(context).size;
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black54,
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
        return BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
          bool isEnabled = state.getDrilldownState != DrilldownState.success;
          return Skeletonizer(
            enableSwitchAnimation: true,
            enabled: isEnabled,
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isEnabled)
                        Tooltip(
                          message: 'Export',
                          verticalOffset: -size.height * 0.075,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Transform.translate(
                            offset: Offset(size.width * 0.008, -size.height * 0.01),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                onTap: () => onExport(state),
                                child: Image.asset(
                                  'assets/images/export.png',
                                  height: size.height * 0.03,
                                  width: size.width * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!isEnabled) Gap(size.width * 0.01),
                      if (!isEnabled)
                        Transform.translate(
                          offset: Offset(0, -size.height * 0.009),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                              onTap: () => Navigator.pop(context),
                              child: CircleAvatar(
                                radius: size.width * 0.007,
                                backgroundColor: Colors.white,
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  weight: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                      height: size.height * 0.5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          dataSources.length,
                          (index) => SizedBox(
                              width: size.width * 0.17,
                              child: SfDataGrid(
                                allowFiltering: true,
                                allowSorting: true,
                                columnWidthMode: ColumnWidthMode.fitByColumnName,
                                source: dataSources[index].dataGridSourceBuilder(isEnabled, state),
                                columns: [
                                  GridColumn(
                                      columnName: dataSources[index].columnName,
                                      minimumWidth: size.width * 0.17,
                                      filterPopupMenuOptions: const FilterPopupMenuOptions(canShowSortingOptions: false),
                                      label: Container(
                                          padding: EdgeInsets.all(size.width * 0.002),
                                          alignment: Alignment.center,
                                          child: Text(
                                            dataSources[index].columnName,
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ))),
                                ],
                              )),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static void LPNSelection({
    required BuildContext context,
  }) {
    Size size = MediaQuery.of(context).size;
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
        FocusNode focusNode = FocusNode();
        SuggestionsController suggestionsController = SuggestionsController();
        TextEditingController textEditingController = TextEditingController();
        return PointerInterceptor(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.35),
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: size.width * 0.16,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.005, right: size.width * 0.002),
                        child: PointerInterceptor(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              weight: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text("Please select LPN"),
                    TypeAheadField(
                      focusNode: focusNode,
                      controller: textEditingController,
                      suggestionsController: suggestionsController,
                      builder: (context, controller, focusNode) {
                        controller.clear();
                        return TextField(
                            controller: controller, focusNode: focusNode, autofocus: true, decoration: InputDecoration(contentPadding: EdgeInsets.only(left: size.width * 0.005)));
                      },
                      itemBuilder: (context, value) {
                        return ListTile(
                          title: Text(
                            value.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        return [
                          "IBLPN12345678901",
                          "IBLPN12345678902",
                          "IBLPN12345678903",
                          "IBLPN12345678904",
                          "IBLPN12345678905",
                          "IBLPN12345678906",
                          "IBLPN12345678907",
                        ].where((element) => element.contains(pattern)).toList();
                      },
                      onSelected: (value) {
                        textEditingController.text = value;
                        focusNode.unfocus();
                      },
                    ),
                    Gap(size.height * 0.01),
                    TextButton(
                        onPressed: () {
                          context.read<WarehouseInteractionBloc>().add(SelectedObject(dataFromJS: {"lpn": textEditingController.text}, clearSearchText: true));
                          context.read<WarehouseInteractionBloc>().state.inAppWebViewController!.webStorage.localStorage.removeItem(key: 'lpnLifeCycle');
                          getIt<WebService>().inAppWebViewController!.evaluateJavascript(source: "lpnLifeCycle('true')");
                          Navigator.pop(context);
                        },
                        child: PointerInterceptor(child: const Text("Done"))),
                    Gap(size.height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void LocateContainerDialog({
    required BuildContext context,
  }) {
    Size size = MediaQuery.of(context).size;
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
        FocusNode containerNbrFocusNode = FocusNode();
        FocusNode toLocationFocusNode = FocusNode();
        SuggestionsController containerNbrSuggestionsController = SuggestionsController();
        SuggestionsController toLocationSuggestionsController = SuggestionsController();
        TextEditingController containerNbrTextEditingController = TextEditingController(text: context.read<ContainerBloc>().state.containerNbr);
        TextEditingController toLocationTextEditingController = TextEditingController(text: context.read<ContainerBloc>().state.toLocation);
        return BlocConsumer<ContainerBloc, ContainerState>(listener: (context, state) {
          containerNbrTextEditingController.text = state.containerNbr ?? '';
          toLocationTextEditingController.text = state.toLocation.toString();
        }, builder: (context, state) {
          List<int> availableLots = List.generate(
            48,
            (index) => index + 1,
          ).toList().where((e) => !state.containers!.map((e) => e.lotNbr!).toList().contains(e)).toList();
          return Container(
            margin: EdgeInsets.only(top: size.height * 0.35),
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: size.height * 0.30,
                width: size.width * 0.2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: size.height * 0.015, left: size.height * 0.015, right: size.height * 0.015, bottom: size.height * 0.01),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Container                 :   ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: TypeAheadField(
                                  focusNode: containerNbrFocusNode,
                                  controller: containerNbrTextEditingController,
                                  suggestionsController: containerNbrSuggestionsController,
                                  builder: (context, controller, focusNode) {
                                    return SizedBox(
                                      height: size.height * 0.04,
                                      child: TextFormField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: size.width * 0.005), focusedBorder: OutlineInputBorder(), enabledBorder: OutlineInputBorder())),
                                    );
                                  },
                                  itemBuilder: (context, value) {
                                    return ListTile(
                                      title: Text(
                                        value.toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  },
                                  suggestionsCallback: (pattern) {
                                    return state.containers!
                                        .where((e) => e.containerNbr!.contains(pattern))
                                        .map(
                                          (e) => e.containerNbr,
                                        )
                                        .toList();
                                  },
                                  onSelected: (value) {
                                    context.read<ContainerBloc>().add(SelectedContainer(containerNbr: value));
                                    containerNbrSuggestionsController.close();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Gap(size.height * 0.01),
                          Row(
                            children: [
                              const Text(
                                "Current Location     :   ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: containerNbrTextEditingController.text.isNotEmpty
                                    ? Text(state.containers!.where((e) => e.containerNbr == state.containerNbr).first.lotNbr!.toString())
                                    : SizedBox(),
                              ),
                            ],
                          ),
                          Gap(size.height * 0.01),
                          Row(
                            children: [
                              const Text(
                                "To Location              :   ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: TypeAheadField(
                                  focusNode: toLocationFocusNode,
                                  controller: toLocationTextEditingController,
                                  suggestionsController: toLocationSuggestionsController,
                                  builder: (context, controller, focusNode) {
                                    return SizedBox(
                                      height: size.height * 0.04,
                                      child: TextFormField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          onChanged: (value) => state.toLocation = value,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: size.width * 0.005), focusedBorder: OutlineInputBorder(), enabledBorder: OutlineInputBorder())),
                                    );
                                  },
                                  itemBuilder: (context, value) {
                                    return ListTile(
                                      title: Text(
                                        value.toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  },
                                  suggestionsCallback: (pattern) {
                                    return availableLots.where((e) => e.toString().contains(pattern)).toList();
                                  },
                                  onSelected: (value) {
                                    context.read<ContainerBloc>().add(SelectedToLocation(toLocation: value.toString()));
                                    toLocationSuggestionsController.close();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Gap(size.height * 0.02),
                          TextButton(
                              onPressed: () {
                                if (toLocationTextEditingController.text != '' && availableLots.contains(int.parse(state.toLocation!))) {
                                  context.read<ContainerBloc>().add(RelocateContainer(containerNbr: state.containerNbr!, toLocation: state.toLocation!));
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Please Select Available Slot!'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              child: PointerInterceptor(child: const Text("Done"))),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.005, right: size.width * 0.002),
                        child: PointerInterceptor(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              weight: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static void AnimatedDialog({required BuildContext context, required Widget header, required List<Widget> content, Function? onClose}) {
    Size size = MediaQuery.of(context).size;

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
        return StatefulBuilder(builder: (context, state) {
          return PointerInterceptor(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.4),
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.035),
                      width: size.width * 0.16,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: size.height * 0.005, right: size.width * 0.002),
                              child: PointerInterceptor(
                                child: InkWell(
                                  onTap: () {
                                    if (onClose != null) {
                                      onClose();
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    weight: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ...content,
                          Gap(size.height * 0.01),
                        ],
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: DialogTopClipper(),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 35,
                      child: Transform.translate(offset: Offset(0, -size.height * 0.01), child: header),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static void UsersDialog({required BuildContext context}) {
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
        return const UsersBuilder();
      },
    );
  }

  static Widget DashboardLoader({BoxConstraints? lsize}) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Color.fromRGBO(68, 98, 136, 1),
        BlendMode.srcATop,
      ),
      child: LottieBuilder.asset(
        'assets/jsons/dashboard_loader.json',
        height: lsize!.maxHeight * 0.4,
        width: lsize.maxWidth * 0.4,
        alignment: Alignment.center,
      ),
    );
  }

  // This function displays a custom flushbar message on the screen
  static Future WMSFlushbar(Size size, BuildContext context, {String message = 'message', Widget? icon}) async {
    // Show the flushbar using Flushbar package
    await Flushbar(
      backgroundColor: Colors.white,
      blockBackgroundInteraction: true,
      messageColor: Colors.black,
      message: message,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.005),
      messageSize: 16,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      icon: icon,
      boxShadows: [BoxShadow(blurRadius: 12, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.blue.shade900, offset: const Offset(0, 0))],
      margin: EdgeInsets.only(top: size.height * 0.016, left: size.width * 0.8, right: size.width * 0.02),
    ).show(context);
  }

  static Future<void> sendMail({required BuildContext context, required String dashboardName, required List<List<String>> data}) async {
    // Create a new Excel workbook
    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    // Set worksheet name and headers
    sheet.name = '$dashboardName ${DateTime.now().toString().split(' ')[0]} data';

    for (int i = 1; i <= data.length; i++) {
      for (int j = 1; j <= data[i - 1].length; j++) {
        sheet.getRangeByIndex(j, i).setText(data[i - 1][j - 1]);
        if (j == 1) {
          sheet.getRangeByIndex(j, i).cellStyle.bold = true;
        }
      }
    }

    // Auto-fit columns
    for (int i = 1; i <= sheet.getLastColumn(); i++) {
      sheet.autoFitColumn(i);
    }

    // Save the workbook to a byte array
    final List<int> bytes = workbook.saveAsStream();

    // Create a Blob from the byte array
    final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

    // Create an anchor element and trigger download
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '${sheet.name}.xlsx')
      ..click();

    // Clean up
    html.Url.revokeObjectUrl(url);
  }

  static void PendigDialog({required BuildContext context, Widget? content}) {
    Size size = MediaQuery.of(context).size;
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
        return StatefulBuilder(builder: (context, state) {
          return PointerInterceptor(
            child: BlocBuilder<WorkQueueBloc, WorkQueueState>(builder: (context, state) {
              print("state change ${state.workQueueStatus}");
              return Container(
                  height: size.height * 0.6,
                  width: size.width * 0.54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: const Color(0xFFF2F2F2),
                  ),
                  child: LayoutBuilder(builder: (context, parent) {
                    return Column(
                      children: [
                        Gap(parent.maxHeight * 0.024),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Gap(parent.maxWidth * 0.33),
                            SizedBox(
                              width: parent.maxWidth * 0.33,
                              child: Text(
                                "Warehouse Work Queue",
                                style: TextStyle(fontSize: size.height * 0.032, color: Colors.black, decoration: TextDecoration.none, letterSpacing: 0.4),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: parent.maxWidth * 0.33,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 8),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: size.height * 0.032,
                                  )),
                            )
                          ],
                        ),
                        Gap(parent.maxHeight * 0.048),
                        Skeletonizer(
                          enabled: state.workQueueStatus == WorkQueueStatus.loading,
                          child: Align(
                            alignment: Alignment.center,
                            child: Wrap(
                                spacing: parent.maxWidth * 0.02,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                runSpacing: parent.maxWidth * 0.02,
                                children: [
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 120, 154, 95),
                                      contentValue: state.workQueueData != null ? state.workQueueData!.ordersAwaitingReceiving.toString() : " null value",
                                      imagePath: "assets/images/orders_awaiting_receiving.png",
                                      heading: "Orders Awaiting Receiving"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 236, 178, 102),
                                      contentValue: state.workQueueData!.ordersAwaitingFulfilment.toString(),
                                      imagePath: "assets/images/order_awaiting_fulfilment.png",
                                      heading: "Orders Awaiting Fulfilment"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 10, 162, 222),
                                      contentValue: state.workQueueData!.openPickingTask.toString(),
                                      imagePath: "assets/images/open_picking_tasks.png",
                                      heading: "Open Picking Task"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 120, 154, 95),
                                      contentValue: state.workQueueData!.pendingAsn.toString(),
                                      imagePath: "assets/images/asn_awaiting_receipt.png",
                                      heading: "ASNs Awaiting Receipt"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 236, 178, 102),
                                      contentValue: state.workQueueData!.loadingQueue.toString(),
                                      imagePath: "assets/images/loading_queue.png",
                                      heading: "Loading Queue"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 10, 162, 222),
                                      contentValue: state.workQueueData!.pendingCycleCounts.toString(),
                                      imagePath: "assets/images/cycle_count.png",
                                      heading: "Pending Cycle Counts"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 120, 154, 95),
                                      contentValue: state.workQueueData!.pendingPutaways.toString(),
                                      imagePath: "assets/images/pending_putaway.png",
                                      heading: "Pending Putaways"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 236, 178, 102),
                                      contentValue: state.workQueueData!.ordersToBeShipped.toString(),
                                      imagePath: "assets/images/orders_to_be_shipped.png",
                                      heading: "Orders To Be Shipped"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 10, 162, 222),
                                      contentValue: state.workQueueData!.openWorkOrders.toString(),
                                      imagePath: "assets/images/open_work_orders.png",
                                      heading: "Open Work Orders"),
                                ]),
                          ),
                        ),
                        Gap(parent.maxHeight * 0.032),
                        Padding(
                          padding: EdgeInsets.only(right: parent.maxHeight * 0.04),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () {
                                  UrlNavigator().launchOrFocusUrl('https://tg1.wms.ocs.oraclecloud.com/emg_test/index/');
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                    minimumSize: WidgetStatePropertyAll(Size(parent.maxWidth * 0.064, parent.maxHeight * 0.088)), // Set the desired size

                                    foregroundColor: WidgetStateColor.resolveWith((state) {
                                      if (state.contains(WidgetState.hovered)) {
                                        return Colors.black;
                                      }
                                      return Colors.white;
                                    }),
                                    backgroundColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                                      if (states.contains(WidgetState.hovered)) {
                                        return Colors.white;
                                      }
                                      return Color.fromRGBO(68, 98, 136, 1);
                                    })),
                                child: Text(
                                  "Take Action",
                                  style: TextStyle(),
                                )),
                          ),
                        )
                      ],
                    );
                  }));
            }),
          );
        });
      },
    );
  }

  static Widget PendingDialogChildContianer({required BoxConstraints parent, String? imagePath, Color? iconBgColor, String? contentValue, required String heading}) {
    return Container(
      alignment: Alignment.center,
      height: parent.maxHeight * 0.21,
      width: parent.maxWidth * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.blue.shade900, spreadRadius: 2, blurRadius: 2, blurStyle: BlurStyle.outer)],
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Flex(
            direction: Axis.horizontal,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.3,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(constraints.maxHeight * 0.08),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBgColor,
                  ),
                  height: constraints.maxHeight * 0.5,
                  child: Image.asset(
                    color: Colors.white,
                    imagePath ?? "assets/images/status.png",
                    // fit: BoxFit.cover,
                    height: constraints.maxHeight * 0.3,
                  ),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.7,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      heading,
                      style: TextStyle(decoration: TextDecoration.none, fontSize: constraints.maxWidth * 0.054, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      contentValue ?? "NA",
                      style: TextStyle(decoration: TextDecoration.none, fontSize: constraints.maxWidth * 0.1, color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// this class is used to add shadow along the clipped path
@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    super.key,
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

// this class is used to paint the shadow along the path that is clipped.
class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// models for charts
class PieData {
  PieData({required this.xData, required this.yData, this.text, this.color});
  final String xData;
  final num yData;
  String? text;
  Color? color;
}

class BarData {
  String xLabel;
  int yValue;
  String abbreviation;
  BarData({required this.xLabel, required this.yValue, required this.abbreviation});
}

class TimeData {
  TimeData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class AnalogChartData {
  AnalogChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class DialogTopClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double x1 = 0;
    double y1 = 0;
    double x = size.width;
    double y = size.height;

    Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x1, y / 1.4);
    path.lineTo(x, y / 1.4);
    path.lineTo(x, y1);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

enum SeriesName { doughnut, radialBar, pieSeries }

class Props {
  List<PieData>? dataSource;
  double labelFontSize;
  String? radius;
  String? innerRadius;
  double? maximumValue;
  Color? Function(PieData, int)? pointColorMapper;
  void Function(ChartPointDetails pointInteractionDetails)? onPointTap;
  Props({this.dataSource, this.labelFontSize = 14, this.radius, this.innerRadius, this.maximumValue, this.pointColorMapper, this.onPointTap});
}

class DrillDownDataSource extends DataGridSource {
  DrillDownDataSource({required List<String> data, required String columnName}) {
    _data = List.generate(
      data.length,
      (index) => DataGridRow(cells: [
        DataGridCell(columnName: columnName, value: index < data.length ? data[index] : ''),
      ]),
    );
  }

  List<DataGridRow> _data = [];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }

  @override
  List<DataGridRow> get effectiveRows => super.effectiveRows;
}

class DataSource {
  DataSource({required this.dataGridSourceBuilder, required this.columnName});
  DataGridSource Function(bool isEnabled, DashboardsState state) dataGridSourceBuilder;
  String columnName;
}

List<String> dummyData = List.generate(10, (index) => 'data $index');

class WorkflowQualityCheckDataSource extends DataGridSource {
  WorkflowQualityCheckDataSource({required List<QualityCheckTask> data, void Function(bool?, DataGridRow)? onChanged, bool isCompleted = false}) {
    _onChanged = onChanged;
    _data = List.generate(
      data.length,
      (index) => DataGridRow(cells: [
        if (!isCompleted) DataGridCell(columnName: '', value: index < data.length ? data[index].isChecked : ''),
        DataGridCell(columnName: 'Facility', value: index < data.length ? data[index].facility : ''),
        DataGridCell(columnName: 'LPN Nbr', value: index < data.length ? data[index].lpnNbr : ''),
        DataGridCell(columnName: 'Status', value: index < data.length ? data[index].status : ''),
        DataGridCell(
            columnName: 'QC Status',
            value: index < data.length
                ? data[index].qcStatus == '20'
                    ? "Accepted"
                    : data[index].qcStatus == '30'
                        ? "Rejected"
                        : "Pending"
                : ''),
        DataGridCell(columnName: 'Item Code', value: index < data.length ? data[index].itemCode : ''),
        DataGridCell(columnName: 'Item Description', value: index < data.length ? data[index].itemDescription : ''),
        DataGridCell(columnName: 'Curr Qty', value: index < data.length ? data[index].currQty : ''),
        DataGridCell(columnName: 'UOM', value: index < data.length ? data[index].uom : ''),
        DataGridCell(columnName: 'Location', value: index < data.length ? data[index].location : ''),
        DataGridCell(columnName: 'Batch Nbr', value: index < data.length ? data[index].batchNbr : ''),
        DataGridCell(columnName: 'Expiry Date', value: index < data.length ? data[index].expiryDate : ''),
        DataGridCell(columnName: 'Manufacture Date', value: index < data.length ? data[index].manufactureDate : ''),
        DataGridCell(columnName: 'Orig Qty', value: index < data.length ? data[index].origQty : ''),
        DataGridCell(columnName: 'Received Qty', value: index < data.length ? data[index].receivedQty : ''),
        DataGridCell(columnName: 'PO Nbr', value: index < data.length ? data[index].poNbr : ''),
        DataGridCell(columnName: 'Received Shipment', value: index < data.length ? data[index].receivedShipment : ''),
        DataGridCell(columnName: 'Putaway Type', value: index < data.length ? data[index].putawayType : ''),
        DataGridCell(columnName: 'Receiving User', value: index < data.length ? data[index].receivedUser : ''),
        DataGridCell(columnName: 'Shipment Type', value: index < data.length ? data[index].shipmentType : ''),
        DataGridCell(columnName: 'Weight', value: index < data.length ? data[index].weight : ''),
        // DataGridCell(columnName: 'uom_wt', value: index < data.length ? data[index].uomwt : ''),
        DataGridCell(columnName: 'Volume', value: index < data.length ? data[index].volume : ''),
        // DataGridCell(columnName: 'uom_vol', value: index < data.length ? data[index].uomvol : ''),
        DataGridCell(columnName: (!isCompleted) ? 'Submitted by' : 'Updated by', value: index < data.length ? data[index].modUser : ''),
        DataGridCell(columnName: (!isCompleted) ? 'Submitted timestamp' : 'Updated timestamp', value: index < data.length ? data[index].modTs : ''),
      ]),
    );
  }

  List<DataGridRow> _data = [];
  void Function(bool?, DataGridRow)? _onChanged;

  @override
  List<DataGridRow> get rows => _data;

  @override
  // TODO: implement effectiveRows
  List<DataGridRow> get effectiveRows => super.effectiveRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return dataGridCell.columnName != ''
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(dataGridCell.value.toString()),
            )
          : BlocBuilder<WorkflowBloc, WorkflowState>(builder: (context, state) {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Checkbox(
                    value: state.selectedQaulityCheckTasks!.contains(row.getCells()[2].value),
                    onChanged: (value) => _onChanged!(value, row),
                  ));
            });
    }).toList());
  }
}

class WorkflowCycleCountDataSource extends DataGridSource {
  WorkflowCycleCountDataSource({required List<CycleCountTask> data, void Function(bool?, DataGridRow)? onChanged, bool isCompleted = false}) {
    _onChanged = onChanged;
    _data = List.generate(
      data.length,
      (index) => DataGridRow(cells: [
        if (!isCompleted) DataGridCell(columnName: '', value: index < data.length ? data[index].status : ''),
        DataGridCell(columnName: 'Facility', value: index < data.length ? data[index].facility : ''),
        DataGridCell(columnName: 'Company ID', value: index < data.length ? data[index].companyID : ''),
        DataGridCell(columnName: 'Group Nbr', value: index < data.length ? data[index].grpNbr : ''),
        DataGridCell(columnName: 'Task', value: index < data.length ? data[index].task : ''),
        DataGridCell(columnName: 'Total Expected Qty', value: index < data.length ? data[index].totalExpectedQuantity : ''),
        DataGridCell(columnName: 'UOM', value: index < data.length ? data[index].uom : ''),
        DataGridCell(columnName: 'Total Counted Qty', value: index < data.length ? data[index].totalCountedQty : ''),
        DataGridCell(columnName: 'UOM2', value: index < data.length ? data[index].uom2 : ''),
        DataGridCell(columnName: 'Total Adjusted Qty', value: index < data.length ? data[index].totalAdjustedQty : ''),
        DataGridCell(columnName: 'UOM3', value: index < data.length ? data[index].uom3 : ''),
        DataGridCell(columnName: 'Total Adjusted Cost', value: index < data.length ? data[index].totalAdjustedCost : ''),
        DataGridCell(columnName: 'Status', value: index < data.length ? data[index].status : ''),
        DataGridCell(columnName: 'Location', value: index < data.length ? data[index].location : ''),
        DataGridCell(columnName: 'Create User', value: index < data.length ? data[index].createUser : ''),
        DataGridCell(columnName: 'Create Timestamp', value: index < data.length ? data[index].createTimestamp : ''),
      ]),
    );
  }

  List<DataGridRow> _data = [];
  void Function(bool?, DataGridRow)? _onChanged;

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return dataGridCell.columnName != ''
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(dataGridCell.value.toString()),
            )
          : BlocBuilder<WorkflowBloc, WorkflowState>(builder: (context, state) {
              return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Checkbox(
                    value: state.cycleCountTasks.where((element) => element.task == row.getCells()[4].value).first.isChecked,
                    onChanged: (value) => _onChanged!(value, row),
                  ));
            });
    }).toList());
  }
  // @override
  // handleLoadMoreRows() async {
  //   if
  // }
}

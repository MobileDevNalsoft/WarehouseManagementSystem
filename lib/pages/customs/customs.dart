import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart' as Gauges;
import 'package:wmssimulator/pages/customs/users_builder.dart';

class Customs {
  static Widget DataSheet({required Size size, required String title, required List<Widget> children, controller, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
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
              Spacer(),
              InkWell(
                  onTap: () async {
                    getIt<JsInteropService>().switchToMainCam("");
                    getIt<JsInteropService>().switchToMainCam(
                        await context.read<WarehouseInteractionBloc>().state.inAppWebViewController!.webStorage.localStorage.getItem(key: "rack_cam") ==
                                "storageArea"
                            ? "storageArea"
                            : "compoundArea");
                    getIt<JsInteropService>().resetBoxColors();

                    context.read<WarehouseInteractionBloc>().add(SelectedObject(dataFromJS: {"object": "null"}));

                    getIt<JsInteropService>().resetTrucks();
                  },
                  child: Icon(Icons.cancel_rounded, color: Colors.white))
            ],
          ),
        ),
        Container(
          height: size.height * 0.86,
          width: size.width * 0.22,
          decoration: BoxDecoration(
              color: Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
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

  static Widget DashboardWidget({Size size = const Size(100, 100), double? margin, Decoration? decoration, bool loaderEnabled = true, required Widget Function(double ratio) chartBuilder}) {
    return Container(
      margin: EdgeInsets.all(margin??0),
      height: size.height,
      width: size.width,
      decoration: decoration ?? BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
      padding: EdgeInsets.all(size.height * 0.035),
      alignment: Alignment.center,
      child: LayoutBuilder(builder: (context, lsize) {
        double aspectRatio;
        if (lsize.maxHeight > lsize.maxWidth) {
          aspectRatio = lsize.maxHeight / lsize.maxWidth;
        } else {
          aspectRatio = lsize.maxWidth / lsize.maxHeight;
        }
        return loaderEnabled ? DashboardLoader(lsize: lsize) : chartBuilder(aspectRatio);
      }),
    );
  }

  static Widget ElevatedDashboardWidget({Size size = const Size(100, 100),required BuildContext context, double? margin,required int index, required Widget Function(double ratio, DashboardsState state) chartBuilder, bool Function(DashboardsState, DashboardsState)? buildWhen}) {
    DashboardsBloc _dashboardsBloc = context.read<DashboardsBloc>();
    return Stack(
      children: [
        BlocBuilder<DashboardsBloc, DashboardsState>(
          builder: (context, state) {
            return MouseRegion(
              onEnter: (event) {
                state.elevates![index] = true;
                _dashboardsBloc.add(ElevateDashboard(elevates: state.elevates!));
              },
              onExit: (event) {
                state.elevates![index] = false;
                _dashboardsBloc.add(ElevateDashboard(elevates: state.elevates!));
              },
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: state.elevates![index] == true ? Colors.black : Colors.grey, blurRadius: 5)]),
              ),
            );
          }
        ),
        BlocBuilder<DashboardsBloc, DashboardsState>(
          buildWhen: buildWhen,
          builder: (context, state) {
            bool isEnabled = state.getDockDashboardState != DockDashboardState.success;
            return IgnorePointer(
              child: Container(
                margin: EdgeInsets.all(margin??0),
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
          }
        )
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
          margin: EdgeInsets.zero,
          title: ChartTitle(
              text: title,
              alignment: ChartAlignment.center,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize
              )),
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

  static Widget WMSPieChart(
      {required String title, List<PieData>? dataSource, Color? Function(PieData, int)? pointColorMapper, bool legendVisibility = false}) {
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
      {required double ratio,
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
      legend: Legend(isVisible: legendVisibility, alignment: ChartAlignment.far),
      annotations: enableAnnotation
          ? <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Container(
                    height: ratio*75,
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
                dataLabelSettings: DataLabelSettings(
                    isVisible: enableAnnotation ? false : true, textStyle: TextStyle(fontSize: props.labelFontSize, fontWeight: FontWeight.bold)),
                radius: props.radius ?? '${ratio*45}%', // Adjust the radius as needed
                innerRadius: props.innerRadius ?? '${ratio*32}%', // Optional: adjust for a thinner ring
                pointColorMapper: props.pointColorMapper,
              )
            : series == SeriesName.radialBar
                ? RadialBarSeries<PieData, String>(
                    dataSource: props!.dataSource,
                    maximumValue: props.maximumValue,
                    cornerStyle: CornerStyle.bothCurve,
                    radius: props.radius ?? '${ratio*50}%', // Adjust the radius as needed
                    innerRadius: props.innerRadius ?? '${ratio*32}%', // Optional: adjust for a thinner ring
                    dataLabelSettings: DataLabelSettings(
                        // Renders the data label
                        isVisible: true,
                        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: props.labelFontSize),
                        alignment: ChartAlignment.center),
                    pointColorMapper: props.pointColorMapper,
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
                    radius: props.radius ?? '${ratio*70}%',
                    pointColorMapper: props.pointColorMapper,
                    xValueMapper: (PieData data, _) => data.xData,
                    yValueMapper: (PieData data, _) => data.yData,
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
      },
    );
  }

  static void UsersDialog({
    required BuildContext context
  }) {
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
        return UsersBuilder();
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
  Props({this.dataSource, this.labelFontSize = 14, this.radius, this.innerRadius, this.maximumValue, this.pointColorMapper});
}

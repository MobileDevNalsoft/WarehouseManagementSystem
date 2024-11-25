import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:another_flushbar/flushbar.dart';

class Customs {
  static Widget DataSheet({required Size size, required String title, required List<Widget> children, controller, required BuildContext context}) {
    return Container(
      height: size.height * 0.92,
      width: size.width * 0.22,
      decoration: const BoxDecoration(color: Color.fromRGBO(206, 218, 233, 1), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
      padding: EdgeInsets.all(size.height * 0.02),
      child: LayoutBuilder(builder: (context, layout) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Color.fromRGBO(68, 98, 136, 1), fontSize: layout.maxWidth * 0.1, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                InkWell(
                    onTap: () async {
                      getIt<JsInteropService>().switchToMainCam(
                          await context.read<WarehouseInteractionBloc>().state.inAppWebViewController!.webStorage.localStorage.getItem(key: "rack_cam") ==
                                  "storageArea"
                              ? "storageArea"
                              : "compoundArea");
                      getIt<JsInteropService>().resetBoxColors();

                      context.read<WarehouseInteractionBloc>().add(SelectedObject(dataFromJS: {"object": "null"}));

                      getIt<JsInteropService>().resetTrucks();
                    },
                    child: Icon(Icons.cancel_rounded, color: Color.fromRGBO(68, 98, 136, 1)))
              ],
            ),
            Gap(size.height * 0.01),
            ...children
          ],
        );
      }),
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
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          primaryXAxis: CategoryAxis(
            labelStyle: TextStyle(color: Colors.black, fontSize: constraints.maxHeight * 0.04),
            majorGridLines: const MajorGridLines(
              width: 0,
            ),
            labelRotation: -90,
            majorTickLines: const MajorTickLines(width: 0),
            axisLine: const AxisLine(width: 0),
          ),
          legend: Legend(
            isVisible: legendVisibility ?? true,
            alignment: ChartAlignment.near,
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
            title: AxisTitle(text: yAxisTitle, textStyle: TextStyle(fontSize: constraints.maxHeight * 0.05)),
            // axisLabelFormatter: (axisLabelRenderArgs) => ChartAxisLabel('', TextStyle()),
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
                  style: TextStyle(color: Colors.black, fontSize: constraints.maxHeight * 0.06),
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
          alignment: ChartAlignment.center,
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
              dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(fontSize: 24),
                  labelAlignment: ChartDataLabelAlignment.top)),
        ]);
  }

  static Widget WMSSfCircularChart(
      {required List<AnalogChartData> chartData,
      String? title,
      String? contentText,
      required Size size,
      double? height,
      double? width,
      String? radius,
      Color? textColor}) {
    return SfCircularChart(
      title: ChartTitle(text: title ?? "title", textStyle: TextStyle(fontWeight: FontWeight.bold)),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Container(
            width: size.height * 0.12,
            height: size.height * 0.12,
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
            height: size.height * 0.12,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueGrey.shade100, boxShadow: [
              BoxShadow(
                color: Colors.grey.shade900,
                blurRadius: 10, // Adjust to set shadow direction
              ),
            ]),
            child: Text(
              contentText ?? "chart",
              style: TextStyle(
                color: textColor ?? Color.fromARGB(255, 101, 10, 10),
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
          radius: radius ?? '50%', // Adjust the radius as needed
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

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
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          border: Border(left: BorderSide(), top: BorderSide(), bottom: BorderSide())),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () async {
                    getIt<JsInteropService>().switchToMainCam(
                        await context.read<WarehouseInteractionBloc>().state.inAppWebViewController!.webStorage.localStorage.getItem(key: "rack_cam") ==
                                "storageArea"
                            ? "storageArea"
                            : "compoundArea");
                    getIt<JsInteropService>().resetTrucks();
                  },
                  icon: const Icon(Icons.close_rounded))
            ],
          ),
          Container(
            height: size.height * 0.06,
            width: size.width * 0.12,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.005),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Gap(size.height * 0.02),
          ...children
        ],
      ),
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

  static Widget WMSCartesianChart({String title = "title", int barCount = 1, List<List<BarData>>? dataSources, String yAxisTitle = "title",Color? color}){
    return SfCartesianChart(
                    title: ChartTitle(text: title,textStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      
                    )),
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
                        color: color,
                        dataLabelMapper: (datum, index) => datum.yValue.toString(),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                          builder: (data, point, series, pointIndex, seriesIndex) => Text(
                            (data as BarData).yValue.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          ),
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
              decoration: TextDecoration.underline,
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
                  labelAlignment: ChartDataLabelAlignment.top)),
        ]);
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
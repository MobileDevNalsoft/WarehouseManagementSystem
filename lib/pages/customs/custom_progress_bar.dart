import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wmssimulator/responsive/responsive.dart';

// ignore: must_be_immutable
class CustomProgressBar extends StatefulWidget {
  double progress;
  double height;
  double width;
  CustomProgressBar({super.key, required this.progress, this.height = 500, this.width = 600});

  @override
  // ignore: library_private_types_in_public_api
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: const BoxDecoration(color: Color.fromRGBO(192, 208, 230, 1)),
      child: LayoutBuilder(builder: (context, lsize) {
        double fontSize;
        Device device = getDevice(context);
        switch (device) {
          case Device.mobile:
            fontSize = 16;
            break;
          case Device.tab:
            fontSize = 20;
            break;
          case Device.desktop:
            fontSize = 26;
            break;
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Loading Your Warehouse Experience...',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: fontSize),
              ),
              LinearPercentIndicator(
                padding: EdgeInsets.only(left: lsize.maxWidth * 0.12),
                width: lsize.maxWidth - lsize.maxWidth * 0.2,
                lineHeight: lsize.maxHeight * 0.02,
                barRadius: const Radius.circular(15),
                progressBorderColor: Colors.white,
                trailing: Padding(
                  padding: EdgeInsets.only(left: lsize.maxWidth * 0.01),
                  child: Text(
                    "${(widget.progress * 100).toString().split('.')[0]}%",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize - 6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                percent: widget.progress,
                backgroundColor: Colors.grey[300],
                progressColor: const Color.fromRGBO(68, 98, 136, 1),
              ),
            ],
          ),
        );
      }),
    );
  }
}

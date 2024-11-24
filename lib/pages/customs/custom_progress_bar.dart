import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomProgressBar extends StatefulWidget {
  double progress;
  double height;
  double width;
  CustomProgressBar({required this.progress, this.height = 500, this.width= 600});

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Color.fromRGBO(192, 208, 230, 1)
      ),
      child: LayoutBuilder(
        builder: (context, lsize) {
          double aspectRatio;
          if (lsize.maxHeight > lsize.maxWidth) {
            aspectRatio = lsize.maxHeight / lsize.maxWidth;
          } else {
            aspectRatio = lsize.maxWidth / lsize.maxHeight;
          }
          return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Building Your Warehouse...', style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: aspectRatio*16
                  ),),
                  LinearPercentIndicator(
                    padding: EdgeInsets.only(left: lsize.maxWidth*0.12),
                    width: lsize.maxWidth - lsize.maxWidth*0.2,
                    lineHeight: lsize.maxHeight*0.03,
                    barRadius: Radius.circular(15),
                    progressBorderColor: Colors.white,
                    trailing:  Padding(
                      padding: EdgeInsets.only(left: lsize.maxWidth*0.01),
                      child: Text(
                        "${(widget.progress*100).toString().split('.')[0]}%",
                        style: TextStyle(color: Colors.black, fontSize: aspectRatio*10, fontWeight: FontWeight.bold,),
                      ),
                    ),
                    percent: widget.progress,
                    backgroundColor: Colors.grey[300],
                    progressColor: Color.fromRGBO(68, 98, 136, 1),
                  ),
                ],
              ),
            );
        }
      ),
    );
  }
}
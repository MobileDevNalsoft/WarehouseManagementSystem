import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LPNStepper extends StatefulWidget {
  LPNStepper({super.key, required this.stepperLength, required this.statusBuilder, required this.contentBuilder});

  Widget Function(int index) statusBuilder;
  Widget Function(int index) contentBuilder;
  int stepperLength;

  @override
  State<LPNStepper> createState() => _LPNStepperState();
}

class _LPNStepperState extends State<LPNStepper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemBuilder: (context, index) {
        return SizedBox(
          height: size.height * 0.15,
          width: size.width * 0.2,
          child: LayoutBuilder(builder: (context, lsize) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.statusBuilder(index),
                Gap(lsize.maxHeight * 0.03),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: lsize.maxWidth * 0.1, top: lsize.maxHeight * 0.01),
                      child: CircleAvatar(backgroundColor: Colors.green.shade300, maxRadius: lsize.maxHeight * 0.1, child: Icon(Icons.abc)),
                    ),
                    Gap(lsize.maxWidth * 0.1),
                    widget.contentBuilder(index)
                  ],
                ),
                if (index < widget.stepperLength - 1)
                  Padding(
                    padding: EdgeInsets.only(left: lsize.maxWidth * 0.111),
                    child: SizedBox(
                      height: lsize.maxHeight * 0.3,
                      child: VerticalDivider(
                        thickness: 2,
                        color: Colors.green.shade300,
                      ),
                    ),
                  ),
              ],
            );
          }),
        );
      },
      itemCount: widget.stepperLength,
    );
  }
}

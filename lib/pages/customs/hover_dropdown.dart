import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/entry_point.dart';

class HoverDropdown extends StatefulWidget {
  const HoverDropdown({super.key});

  @override
  State<HoverDropdown> createState() => _HoverDropdownState();
}

class _HoverDropdownState extends State<HoverDropdown> {
  double height = 80;
  double bottomHeight = 70;
  double turns = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: height,
      width: size.width * 0.08,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: bottomHeight,
            width: size.width * 0.1,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Gap(size.height * 0.08),
                  PointerInterceptor(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              height = height == 180 ? 80 : 180; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == 180 ? 70 : 180;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EntryPoint(),));
                          },
                          child: ForHover(text: "DashBoard"))),
                  PointerInterceptor(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              height = height == 180 ? 80 : 180; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == 180 ? 70 : 180;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                          },
                          child: ForHover(text: "WMS Cloud"))),
                ],
              ),
            ),
          ),
          // Container that holds the main profiles section
          Padding(
            padding: EdgeInsets.all(size.width * 0.008),
            child: InkWell(
              onTap: () {
                setState(() {
                  height = height == 80 ? 180 : 80; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                  bottomHeight = bottomHeight == 70 ? 180 : 70;
                  turns = turns == 0.5 ? 1 : 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/profile.png',
                    scale: 6,
                  ),
                  Gap(size.width * 0.003),
                  AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Widget that holds hover animation for the text and its background
class ForHover extends StatefulWidget {
  final String text;
  const ForHover({super.key, required this.text});

  @override
  State<ForHover> createState() => _ForHoverState();
}

class _ForHoverState extends State<ForHover> {
  Color? hoverColor;
  Color? textColor;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        // change color on hover
        setState(() {
          hoverColor = Colors.blue.shade900;
          textColor = Colors.white;
        });
      },
      // Revert color when not hovering
      onExit: (event) {
        setState(() {
          hoverColor = Colors.white;
          textColor = Colors.black;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(right: 25),
        color: hoverColor,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

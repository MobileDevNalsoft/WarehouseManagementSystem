import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/dock_area_model.dart';

class ThreeLevelDropdown extends StatefulWidget {
  ThreeLevelDropdown({super.key, required this.l1StyleData, required this.l2StyleData, required this.l3StyleData});
  L1StyleData l1StyleData;
  L2StyleData l2StyleData;
  L3StyleData l3StyleData;

  @override
  _ThreeLevelDropdownState createState() => _ThreeLevelDropdownState();
}

class _ThreeLevelDropdownState extends State<ThreeLevelDropdown> {
  List<double> heights = [];
  List<double> bottomHeights = [];
  List<double> turns = [];
  List<List<double>> innerHeights = [];
  List<List<double>> innerBottomHeights = [];
  List<List<double>> innerTurns = [];
  int? openDropdownIndex; // Track which dropdown is currently open
  int? outerOpenDropdownIndex;

  @override
  void initState() {
    super.initState();
    heights = List.filled(widget.l1StyleData.itemCount!, widget.l1StyleData.height);
    bottomHeights = List.filled(widget.l1StyleData.itemCount!, widget.l1StyleData.height);
    turns = List.filled(widget.l1StyleData.itemCount!, 1);
    innerHeights = List.filled(widget.l1StyleData.itemCount!, []);
    innerBottomHeights = List.filled(widget.l1StyleData.itemCount!, []);
    innerTurns = List.filled(widget.l1StyleData.itemCount!, []);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListView.builder(
          itemCount: widget.l1StyleData.itemCount!,
          itemBuilder: (context, oindex) {
            int l2ItemCount = widget.l2StyleData.itemCount(oindex);
            if (innerHeights[oindex].isEmpty) {
              innerHeights[oindex] = List.filled(l2ItemCount, widget.l2StyleData.height);
              innerBottomHeights[oindex] = List.filled(l2ItemCount, widget.l2StyleData.height);
              innerTurns[oindex] = List.filled(l2ItemCount, 1);
            }
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: heights[oindex],
              width: widget.l1StyleData.width,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: bottomHeights[oindex],
                    width: widget.l1StyleData.width,
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.only(top: 65, bottom: 5),
                      decoration: BoxDecoration(
                        color: widget.l1StyleData.dropDownColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: l2ItemCount,
                            itemBuilder: (context, index) {
                              int l3ItemCount = widget.l3StyleData.itemCount(oindex, index);
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: innerHeights[oindex][index],
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      height: innerBottomHeights[oindex][index],
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 65, bottom: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: widget.l2StyleData.dropDownColor,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: l3ItemCount,
                                            itemBuilder: (context, inindex) => Container(
                                                padding: const EdgeInsets.all(10),
                                                height: widget.l3StyleData.height,
                                                margin: const EdgeInsets.only(bottom: 5),
                                                decoration: BoxDecoration(
                                                  color: widget.l3StyleData.color,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: LayoutBuilder(builder: (context, lsize) {
                                                  return widget.l3StyleData.builder(lsize, oindex, index, inindex);
                                                })),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Close other opened dropdowns
                                          if (openDropdownIndex == index) {
                                            // If the same dropdown is tapped, close it
                                            innerHeights[oindex][index] = innerHeights[oindex][index] == widget.l2StyleData.height
                                                ? (l3ItemCount) * (widget.l3StyleData.height + 5) + (widget.l2StyleData.height + 25)
                                                : widget.l2StyleData.height;
                                            innerBottomHeights[oindex][index] = innerBottomHeights[oindex][index] == widget.l2StyleData.height
                                                ? (l3ItemCount) * (widget.l3StyleData.height + 5) + (widget.l2StyleData.height + 25)
                                                : widget.l2StyleData.height;
                                            innerTurns[oindex][index] = innerTurns[oindex][index] == 0.5 ? 1 : 0.5; // Rotate icon
                                            openDropdownIndex = null; // Reset opened index
                                            if (heights[oindex] == (l2ItemCount) * widget.l2StyleData.height + (widget.l1StyleData.height + 25)) {
                                              heights[oindex] = (l3ItemCount) * (widget.l3StyleData.height + 5) +
                                                  25 +
                                                  (l2ItemCount) * widget.l2StyleData.height +
                                                  (widget.l1StyleData.height + 25);
                                              bottomHeights[oindex] = (l3ItemCount) * (widget.l3StyleData.height + 5) +
                                                  25 +
                                                  (l2ItemCount) * widget.l2StyleData.height +
                                                  (widget.l1StyleData.height + 25);
                                            } else {
                                              heights[oindex] = (l2ItemCount) * widget.l2StyleData.height + (widget.l1StyleData.height + 25);
                                              bottomHeights[oindex] = (l2ItemCount) * widget.l2StyleData.height + (widget.l1StyleData.height + 25);
                                            }
                                          } else {
                                            // Close previously opened dropdown and open the new one
                                            if (openDropdownIndex != null) {
                                              innerHeights[oindex][openDropdownIndex!] = widget.l2StyleData.height; // Reset previous dropdown
                                              innerBottomHeights[oindex][openDropdownIndex!] = widget.l2StyleData.height; // Reset previous bottom height
                                              innerTurns[oindex][openDropdownIndex!] = 1;
                                            }
                                            openDropdownIndex = index; // Set current index as opened
                                            heights[oindex] = (l3ItemCount) * (widget.l3StyleData.height + 5) +
                                                25 +
                                                (l2ItemCount) * widget.l2StyleData.height +
                                                (widget.l1StyleData.height + 25);
                                            bottomHeights[oindex] = (l3ItemCount) * (widget.l3StyleData.height + 5) +
                                                25 +
                                                (l2ItemCount) * widget.l2StyleData.height +
                                                (widget.l1StyleData.height + 25);
                                            innerHeights[oindex][index] =
                                                (l3ItemCount) * (widget.l3StyleData.height + 5) + (widget.l2StyleData.height + 25); // Expand current dropdown
                                            innerBottomHeights[oindex][index] = (l3ItemCount) * (widget.l3StyleData.height + 5) +
                                                (widget.l2StyleData.height + 25); // Expand current bottom height
                                            innerTurns[oindex][index] = 0.5;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: widget.l2StyleData.height,
                                        margin: const EdgeInsets.only(bottom: 5),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: widget.l2StyleData.color,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: LayoutBuilder(builder: (context, lsize) {
                                          return Row(
                                            children: [
                                              Image.asset(
                                                widget.l2StyleData.iconPath,
                                                scale: lsize.maxHeight * 0.05,
                                                color: Colors.white,
                                              ),
                                              Gap(lsize.maxWidth * 0.01),
                                              SizedBox(
                                                width: lsize.maxWidth * 0.6,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    widget.l2StyleData.title(oindex, index),
                                                    style:  TextStyle(color: Colors.white,fontSize: lsize.maxHeight * 0.36 ),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: widget.l1StyleData.height * 0.5,
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        width: widget.l1StyleData.width * 0.1,
                                                        child: Text(
                                                          l3ItemCount.toString(),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: lsize.maxHeight * 0.3, fontWeight: FontWeight.w500),
                                                        )),
                                                    AnimatedRotation(
                                                      turns: innerTurns[oindex][index],
                                                      duration: const Duration(milliseconds: 200),
                                                      child: const Icon(
                                                        Icons.keyboard_arrow_down_rounded,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    Gap(widget.l1StyleData.width * 0.02)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (heights[oindex] == widget.l1StyleData.height) {
                          // If outer dropdown is expanding, close all inner dropdowns first
                          for (int i = 0; i < innerHeights[oindex].length; i++) {
                            innerHeights[oindex][i] = widget.l2StyleData.height; // Reset all inner heights to closed state
                            innerBottomHeights[oindex][i] = widget.l2StyleData.height; // Reset all bottom heights to closed state
                          }
                          openDropdownIndex = null; // Reset opened index for inner dropdowns
                        }
                        // Close other opened dropdowns
                        if (outerOpenDropdownIndex == oindex) {
                          // If the same dropdown is tapped, close it
                          heights[oindex] = heights[oindex] == widget.l1StyleData.height
                              ? (l2ItemCount) * widget.l2StyleData.height + (widget.l1StyleData.height + 25)
                              : widget.l1StyleData.height;
                          bottomHeights[oindex] = bottomHeights[oindex] == widget.l1StyleData.height
                              ? (l2ItemCount) * widget.l2StyleData.height + (widget.l1StyleData.height + 25)
                              : widget.l1StyleData.height;
                          turns[oindex] = turns[oindex] == 0.5 ? 1 : 0.5; // Rotate icon
                          outerOpenDropdownIndex = null; // Reset opened index
                        } else {
                          // Close previously opened dropdown and open the new one
                          if (outerOpenDropdownIndex != null) {
                            heights[outerOpenDropdownIndex!] = widget.l1StyleData.height; // Reset previous dropdown
                            bottomHeights[outerOpenDropdownIndex!] = widget.l1StyleData.height; // Reset previous bottom height
                            turns[outerOpenDropdownIndex!] = 1;
                          }
                          outerOpenDropdownIndex = oindex; // Set current index as opened
                          heights[oindex] = (l2ItemCount) * widget.l2StyleData.height + (widget.l1StyleData.height + 25); // Expand current dropdown
                          bottomHeights[oindex] = (l2ItemCount) * widget.l2StyleData.height + (widget.l1StyleData.height + 25); // Expand current bottom height
                          turns[oindex] = 0.5;
                        }
                      });
                    },
                    child: Container(
                      height: widget.l1StyleData.height,
                      width: widget.l1StyleData.width,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: widget.l1StyleData.color, // Purple background
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: LayoutBuilder(builder: (context, lsize) {
                        return Row(
                          children: [
                            Image.asset(
                              widget.l1StyleData.iconPath,
                              scale: lsize.maxHeight * 0.05,
                            ),
                            Gap(lsize.maxWidth * 0.01),
                            Text(
                              widget.l1StyleData.title(oindex),
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            const Spacer(),
                            Container(
                              height: widget.l1StyleData.height * 0.5,
                              decoration: BoxDecoration(color: const Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: widget.l1StyleData.width * 0.1,
                                      child: Text(
                                        l2ItemCount.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: lsize.maxHeight * 0.25),
                                      )),
                                  AnimatedRotation(
                                    turns: turns[oindex],
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Gap(widget.l1StyleData.width * 0.02)
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class L1StyleData {
  double height;
  double width;
  Color? color;
  Color? dropDownColor;
  int? itemCount;
  String iconPath;
  String Function(int index) title;
  L1StyleData(
      {required this.height,
      required this.width,
      required this.itemCount,
      required this.iconPath,
      this.color = const Color.fromRGBO(68, 98, 136, 1),
      this.dropDownColor = const Color.fromRGBO(163, 183, 209, 1),
      required this.title});
}

class L2StyleData {
  double height;
  Color? color;
  Color? dropDownColor;
  String iconPath;
  String Function(int l1Index, int l2Index) title;
  int Function(int index) itemCount;
  L2StyleData(
      {required this.height,
      this.color = const Color.fromRGBO(68, 98, 136, 1),
      this.dropDownColor = const Color.fromRGBO(194, 213, 238, 1),
      required this.iconPath,
      required this.title,
      required this.itemCount});
}

class L3StyleData {
  double height;
  Color? color;
  int Function(int l1Index, int l2Index) itemCount;
  Widget Function(BoxConstraints lsize, int l1Index, int l2Index, int l3Index) builder;
  L3StyleData({required this.height, this.color = Colors.white, required this.itemCount, required this.builder});
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/dock_area_model.dart';

class ExpandableListView extends StatefulWidget {
  ExpandableListView({super.key, required this.data, required this.l1StyleData, required this.l2StyleData, required this.l3StyleData});
  List<DockAreaItem> data;
  L1StyleData l1StyleData;
  L2StyleData l2StyleData;
  L3StyleData l3StyleData;

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  List<double> heights = [];
  List<double> bottomHeights = [];
  List<double> turns = [];
  List<List<double>> innerHeights = [];
  List<List<double>> innerBottomHeights = [];
  List<List<double>> innerTurns = [];
  int? openDropdownIndex; // Track which dropdown is currently open
  int? outerOpenDropdownIndex;
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();
    heights = List.filled(widget.data.length, widget.l1StyleData.height);
    bottomHeights = List.filled(widget.data.length, widget.l1StyleData.height);
    turns = List.filled(widget.data.length, 1);
    innerHeights = List.filled(widget.data.length, []);
    innerBottomHeights = List.filled(widget.data.length, []);
    innerTurns = List.filled(widget.data.length, []);
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ListView.builder(
          itemCount: widget.data.length,
          itemBuilder: (context, oindex) {
            if (innerHeights[oindex].isEmpty) {
              innerHeights[oindex] = List.filled(widget.data[oindex].vendors!.length, widget.l2StyleData.height);
              innerBottomHeights[oindex] = List.filled(widget.data[oindex].vendors!.length, widget.l2StyleData.height);
              innerTurns[oindex] = List.filled(widget.data[oindex].vendors!.length, 1);
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
                      margin: EdgeInsets.only(top: 65, bottom: 5),
                      decoration: BoxDecoration(
                        color: widget.l1StyleData.dropDownColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ListView.builder(
                            itemCount: widget.data[oindex].vendors!.length,
                            itemBuilder: (context, index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: innerHeights[oindex][index],
                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      height: innerBottomHeights[oindex][index],
                                      child: Container(
                                        margin: EdgeInsets.only(top: 65, bottom: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: widget.l2StyleData.dropDownColor,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: ListView.builder(
                                            itemCount: widget.data[oindex].vendors![index].items!.length,
                                            itemBuilder: (context, inindex) => Container(
                                                padding: EdgeInsets.all(10),
                                                height: widget.l3StyleData.height,
                                                margin: EdgeInsets.only(bottom: 5),
                                                decoration: BoxDecoration(
                                                  color: widget.l3StyleData.color,
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                child: LayoutBuilder(
                                                  builder: (context, lsize) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('DNO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].vendors![index].items![inindex].dockNbr!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)],
                                                        ),
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('ASN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].vendors![index].items![inindex].asn!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)],
                                                        ),
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('PO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].vendors![index].items![inindex].poNbr!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].vendors![index].items![inindex].qty!.toString(), style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)],
                                                            ),
                                                            Spacer(),
                                                            Text(widget.data[oindex].vendors![index].items![inindex].checkinTS!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.04),)
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  }
                                                )),
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
                                                ? (widget.data[oindex].vendors![index].items!.length) * (widget.l3StyleData.height + 5) + (widget.l2StyleData.height+25)
                                                : widget.l2StyleData.height;
                                            innerBottomHeights[oindex][index] = innerBottomHeights[oindex][index] == widget.l2StyleData.height
                                                ? (widget.data[oindex].vendors![index].items!.length) * (widget.l3StyleData.height + 5) + (widget.l2StyleData.height+25)
                                                : widget.l2StyleData.height;
                                            innerTurns[oindex][index] = innerTurns[oindex][index] == 0.5 ? 1 : 0.5; // Rotate icon
                                            openDropdownIndex = null; // Reset opened index
                                            heights[oindex] = (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                            bottomHeights[oindex] = (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                          } else {
                                            // Close previously opened dropdown and open the new one
                                            if (openDropdownIndex != null) {
                                              innerHeights[oindex][openDropdownIndex!] = widget.l2StyleData.height; // Reset previous dropdown
                                              innerBottomHeights[oindex][openDropdownIndex!] = widget.l2StyleData.height; // Reset previous bottom height
                                              innerTurns[oindex][openDropdownIndex!] = 1;
                                            }
                                            openDropdownIndex = index; // Set current index as opened
                                            heights[oindex] = (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                            bottomHeights[oindex] = (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                            innerHeights[oindex][index] =
                                                (widget.data[oindex].vendors![index].items!.length) * (widget.l3StyleData.height + 5) +
                                                    (widget.l2StyleData.height+25); // Expand current dropdown
                                            innerBottomHeights[oindex][index] =
                                                (widget.data[oindex].vendors![index].items!.length) * (widget.l3StyleData.height + 5) +
                                                    (widget.l2StyleData.height+25); // Expand current bottom height
                                            innerTurns[oindex][index] = 0.5;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: widget.l2StyleData.height,
                                        margin: EdgeInsets.only(bottom: 5),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: widget.l2StyleData.color,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: LayoutBuilder(builder: (context, lsize) {
                                          return Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/businessman.png',
                                                scale: lsize.maxHeight * 0.05,
                                                color: Colors.white,
                                              ),
                                              Gap(lsize.maxWidth * 0.01),
                                              Text('${widget.data[oindex].vendors![index].vendorName} (${widget.data[oindex].vendors![index].items!.length})', style: TextStyle(color: Colors.white),),
                                              Spacer(),
                                              AnimatedRotation(
                                                turns: innerTurns[oindex][index],
                                                duration: const Duration(milliseconds: 200),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_rounded,
                                                  size: 20,
                                                  // color: Colors.white,
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
                              ? (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25)
                              : widget.l1StyleData.height;
                          bottomHeights[oindex] = bottomHeights[oindex] == widget.l1StyleData.height
                              ? (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25)
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
                          heights[oindex] = (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25); // Expand current dropdown
                          bottomHeights[oindex] = (widget.data[oindex].vendors!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25); // Expand current bottom height
                          turns[oindex] = 0.5;
                        }
                      });
                    },
                    child: Container(
                      height: widget.l1StyleData.height,
                      width: widget.l1StyleData.width,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        color: widget.l1StyleData.color, // Purple background
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: LayoutBuilder(builder: (context, lsize) {
                        return Row(
                          children: [
                            Image.asset(
                              'assets/images/truck.png',
                              scale: lsize.maxHeight * 0.05,
                            ),
                            Gap(lsize.maxWidth * 0.01),
                            Text(
                              widget.data[oindex].truckNum!,
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            Spacer(),
                            AnimatedRotation(
                              turns: turns[oindex],
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                // color: Colors.white,
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
    );
  }
}

class L1StyleData {
  double height;
  double width;
  Color? color;
  Color? dropDownColor;
  L1StyleData({required this.height, required this.width, this.color = const Color.fromRGBO(68, 98, 136, 1), this.dropDownColor = const Color.fromRGBO(163, 183, 209, 1)});
}

class L2StyleData {
  double height;
  Color? color;
  Color? dropDownColor;
  L2StyleData({required this.height, this.color = const Color.fromRGBO(68, 98, 136, 1), this.dropDownColor = const Color.fromRGBO(194, 213, 238, 1)});
}

class L3StyleData {
  double height;
  Color? color;
  L3StyleData({required this.height, this.color = Colors.white});
}

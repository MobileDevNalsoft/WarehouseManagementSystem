import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/staging/staging_bloc.dart';
import 'package:wmssimulator/bloc/staging/staging_event.dart';
import 'package:wmssimulator/bloc/staging/staging_state.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/staging_area_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class StagingAreaDataSheet extends StatefulWidget {
  const StagingAreaDataSheet({super.key});

  @override
  State<StagingAreaDataSheet> createState() => _StagingAreaDataSheetState();
}

class _StagingAreaDataSheetState extends State<StagingAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  StagingBloc? _stagingBloc;
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();
    _stagingBloc = context.read<StagingBloc>();
    _stagingBloc!.add(GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    _controller.addListener(_scrollListener);
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        _stagingBloc!.state.stagingList!.length + 1 > (_stagingBloc!.state.pageNum! + 1) * 100) {
      print("reached end of the screen");

      _stagingBloc!.state.pageNum = _stagingBloc!.state.pageNum! + 1;

      print("before api call in scroll");

      _stagingBloc!.add(GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Staging Area', children: [
      BlocBuilder<StagingBloc, StagingState>(
        builder: (context, state) {
          bool isEnabled = state.stagingStatus != StagingAreaStatus.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (!isEnabled && state.stagingList!.isEmpty)
                  ? Column(
                      children: [
                        Text(
                          _warehouseInteractionBloc.state.searchText != null && _warehouseInteractionBloc.state.searchText != ""
                              ? _warehouseInteractionBloc.state.searchText!
                              : "",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: lsize.maxWidth * 0.048),
                        ),
                        Text("Data not found")
                      ],
                    )
                  : isEnabled
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : StagingListView(
                          data: state.stagingList!,
                          l1StyleData: L1StyleData(height: 60, width: 400),
                          l2StyleData: L2StyleData(
                              height: lsize.maxHeight * 0.13));
            }),
          );
        },
      )
    ]);
  }
}

class StagingListView extends StatefulWidget {
  StagingListView({super.key, required this.data, required this.l1StyleData, required this.l2StyleData});
  List<StagingAreaItem> data;
  L1StyleData l1StyleData;
  L2StyleData l2StyleData;

  @override
  _StagingListViewState createState() => _StagingListViewState();
}

class _StagingListViewState extends State<StagingListView> {
  List<double> heights = [];
  List<double> bottomHeights = [];
  List<double> turns = [];
  int? openDropdownIndex; // Track which dropdown is currently open
  int? outerOpenDropdownIndex;
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();
    heights = List.filled(widget.data.length, widget.l1StyleData.height);
    bottomHeights = List.filled(widget.data.length, widget.l1StyleData.height);
    turns = List.filled(widget.data.length, 1);
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: ListView.builder(
          itemCount: widget.data.length,
          itemBuilder: (context, oindex) {
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.data[oindex].items!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: EdgeInsets.all(10),
                                  height: widget.l2StyleData.height,
                                  margin: EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    color: widget.l2StyleData.color,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: LayoutBuilder(builder: (context, lsize) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: lsize.maxWidth * 0.16,
                                                child: Text(
                                                  'Item',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045, color: Colors.white),
                                                )),
                                            Gap(lsize.maxWidth * 0.01),
                                            Text(
                                              widget.data[oindex].items![index].item!,
                                              style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: lsize.maxWidth * 0.16,
                                                child: Text(
                                                  'OD',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045, color: Colors.white),
                                                )),
                                            Gap(lsize.maxWidth * 0.01),
                                            Text(
                                              widget.data[oindex].items![index].od!,
                                              style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: lsize.maxWidth * 0.16,
                                                child: Text(
                                                  'QTY',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045, color: Colors.white),
                                                )),
                                            Gap(lsize.maxWidth * 0.01),
                                            Text(
                                              widget.data[oindex].items![index].qty!,
                                              style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    );
                                  }));
                            }),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (heights[oindex] == widget.l1StyleData.height) {
                          openDropdownIndex = null; // Reset opened index for inner dropdowns
                        }
                        // Close other opened dropdowns
                        if (outerOpenDropdownIndex == oindex) {
                          // If the same dropdown is tapped, close it
                          heights[oindex] = heights[oindex] == widget.l1StyleData.height
                              ? (widget.data[oindex].items!.length) * (widget.l2StyleData.height+5) + (widget.l1StyleData.height + 25)
                              : widget.l1StyleData.height;
                          bottomHeights[oindex] = bottomHeights[oindex] == widget.l1StyleData.height
                              ? (widget.data[oindex].items!.length) * (widget.l2StyleData.height+5) + (widget.l1StyleData.height + 25)
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
                          heights[oindex] =
                              (widget.data[oindex].items!.length) * (widget.l2StyleData.height+5) + (widget.l1StyleData.height + 25); // Expand current dropdown
                          bottomHeights[oindex] = (widget.data[oindex].items!.length) * (widget.l2StyleData.height+5) +
                              (widget.l1StyleData.height + 25); // Expand current bottom height
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: LayoutBuilder(builder: (context, lsize) {
                        return Row(
                          children: [
                            Image.asset(
                              'assets/images/businessman.png',
                              scale: lsize.maxHeight * 0.05,
                            ),
                            Gap(lsize.maxWidth * 0.01),
                            Text(
                              widget.data[oindex].customerName!.replaceAll('"', ''),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Spacer(),
                            Container(
                              height: widget.l1StyleData.height * 0.5,
                              decoration: BoxDecoration(color: Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: widget.l1StyleData.width * 0.1,
                                      child: Text(
                                        widget.data[oindex].items!.length.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: lsize.maxHeight * 0.25),
                                      )),
                                  AnimatedRotation(
                                    turns: turns[oindex],
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
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
  L1StyleData({required this.height, required this.width, this.color = Colors.white, this.dropDownColor = Colors.white});
}

class L2StyleData {
  double height;
  Color? color;
  L2StyleData({required this.height, this.color = const Color.fromRGBO(43, 79, 122, 1)});
}

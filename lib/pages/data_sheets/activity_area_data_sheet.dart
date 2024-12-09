import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/activity_area/activity_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/models/activity_area_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/dashboard_utils/shared/constants/ghaps.dart';

class ActivityAreaDataSheet extends StatefulWidget {
  const ActivityAreaDataSheet({super.key});

  @override
  State<ActivityAreaDataSheet> createState() => _ActivityAreaDataSheetState();
}

class _ActivityAreaDataSheetState extends State<ActivityAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late ActivityAreaBloc _activityBloc;
late  WarehouseInteractionBloc _warehouseInteractionBloc ;
  @override
  void initState() {
    super.initState();

    _activityBloc = context.read<ActivityAreaBloc>();
     _activityBloc.add( GetActivityAreaData( searchText: context.read<WarehouseInteractionBloc>().state.searchText));

  
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent && _activityBloc.state.activityAreaItems!.length + 1 > (_activityBloc.state.pageNum! + 1) * 100) {
      _activityBloc.state.pageNum = _activityBloc.state.pageNum! + 1;
      _activityBloc.add( GetActivityAreaData( searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Activity Area',
      children: [
        BlocBuilder<ActivityAreaBloc, ActivityAreaState>(
            builder: (context, state) {
              bool isEnabled = state.getDataState != GetDataState.success;
              return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (!isEnabled &&  state.activityAreaItems!.isEmpty)?
                      Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.048),),Text("Data not found")],)
                     : isEnabled ? Center(child: CircularProgressIndicator(),) : ActivityListView(data: state.activityAreaItems!, l1StyleData: L1StyleData(height: 60, width: 400, color: Colors.white, dropDownColor: Colors.white), l2StyleData: L2StyleData(height: lsize.maxHeight*0.145, color: Color.fromRGBO(43, 79, 122, 1), dropDownColor: Color.fromRGBO(43, 79, 122, 1)));
            }),
          );
            },
          )
      ]
    );
  }
}

class ActivityListView extends StatefulWidget {
  ActivityListView({super.key, required this.data, required this.l1StyleData, required this.l2StyleData});
  List<ActivityAreaItem> data;
  L1StyleData l1StyleData;
  L2StyleData l2StyleData;

  @override
  _ActivityListViewState createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView> {
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
      borderRadius: BorderRadius.circular(25),
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
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ListView.builder(
                            itemCount: widget.data[oindex].items!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                                padding: EdgeInsets.all(10),
                                                height: widget.l2StyleData.height,
                                                margin: EdgeInsets.only(bottom: 5),
                                                decoration: BoxDecoration(
                                                  color: widget.l2StyleData.color,
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                child: LayoutBuilder(
                                                  builder: (context, lsize) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045, color: Colors.white),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].items![index].item!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold, color: Colors.white),)],
                                                        ),
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('OD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045, color: Colors.white),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].items![index].od!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold, color: Colors.white),)],
                                                        ),
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045, color: Colors.white),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].items![index].qty!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold, color: Colors.white),)],
                                                        )
                                                      ],
                                                    );
                                                  }
                                                ));
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
                              ? (widget.data[oindex].items!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25)
                              : widget.l1StyleData.height;
                          bottomHeights[oindex] = bottomHeights[oindex] == widget.l1StyleData.height
                              ? (widget.data[oindex].items!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25)
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
                          heights[oindex] = (widget.data[oindex].items!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25); // Expand current dropdown
                          bottomHeights[oindex] = (widget.data[oindex].items!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25); // Expand current bottom height
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
                              'assets/images/wo_type.png',
                              scale: lsize.maxHeight * 0.05,
                            ),
                            Gap(lsize.maxWidth * 0.01),
                            Text(
                              '${widget.data[oindex].workOrderType!.replaceAll('"', '')} (${widget.data[oindex].items!.length})',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
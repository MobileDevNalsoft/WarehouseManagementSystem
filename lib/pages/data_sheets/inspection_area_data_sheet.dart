import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/receiving_area_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class InspectionAreaDataSheet extends StatefulWidget {
  const InspectionAreaDataSheet({super.key});

  @override
  State<InspectionAreaDataSheet> createState() => _InspectionAreaDataSheetState();
}

class _InspectionAreaDataSheetState extends State<InspectionAreaDataSheet> {
  late InspectionAreaBloc _inspectionAreaBloc;
  final ScrollController _controller = ScrollController();
late  WarehouseInteractionBloc _warehouseInteractionBloc ;
  @override
  void initState() {
    super.initState();

    _inspectionAreaBloc = context.read<InspectionAreaBloc>();
   
      _inspectionAreaBloc.add(GetInspectionAreaData(
          searchText: context.read<WarehouseInteractionBloc>().state.searchText
              ));
    
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent && _inspectionAreaBloc.state.inspectionAreaItems!.length + 1 > (_inspectionAreaBloc.state.pageNum! + 1) * 100) {
      _inspectionAreaBloc.state.pageNum = _inspectionAreaBloc.state.pageNum! + 1;
      _inspectionAreaBloc.add( GetInspectionAreaData(   searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Inspection Area',
      children: [
        BlocBuilder<InspectionAreaBloc, InspectionAreaState>(
            builder: (context, state) {
              bool isEnabled = state.getDataState != GetDataState.success;
              return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (!isEnabled &&  state.inspectionAreaItems!.isEmpty)?
                      Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.048),),Text("Data not found")],)
                     : isEnabled ? Center(child: CircularProgressIndicator(),) : ReceivingListView(data: state.inspectionAreaItems!, l1StyleData: L1StyleData(height: 60, width: 400, color: Colors.white, dropDownColor: Colors.white), l2StyleData: L2StyleData(height: 60, color: Color.fromRGBO(43, 79, 122, 1), dropDownColor: Color.fromRGBO(43, 79, 122, 1)), l3StyleData: L3StyleData(height: lsize.maxHeight*0.145, color: Color.fromRGBO(127, 161, 202, 1)),);
            }),
          );
            },
          )
      ]
    );
  }
}


class ReceivingListView extends StatefulWidget {
  ReceivingListView({super.key, required this.data, required this.l1StyleData, required this.l2StyleData, required this.l3StyleData});
  List<ReceivingAreaItem> data;
  L1StyleData l1StyleData;
  L2StyleData l2StyleData;
  L3StyleData l3StyleData;

  @override
  _ReceivingListViewState createState() => _ReceivingListViewState();
}

class _ReceivingListViewState extends State<ReceivingListView> {
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
              innerHeights[oindex] = List.filled(widget.data[oindex].shipments!.length, widget.l2StyleData.height);
              innerBottomHeights[oindex] = List.filled(widget.data[oindex].shipments!.length, widget.l2StyleData.height);
              innerTurns[oindex] = List.filled(widget.data[oindex].shipments!.length, 1);
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
                            itemCount: widget.data[oindex].shipments!.length,
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
                                            itemCount: widget.data[oindex].shipments![index].items!.length,
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
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].shipments![index].items![inindex].item!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)],
                                                        ),
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('PO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child : Text(widget.data[oindex].shipments![index].items![inindex].po!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)))],
                                                        ),
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('CO No.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].shipments![index].items![inindex].containerNBR!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)],
                                                        ),
                                                        Row(
                                                          children: [SizedBox(width: lsize.maxWidth*0.16, child: Text('QTY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth*0.045),)), Gap(lsize.maxWidth*0.01), Text(widget.data[oindex].shipments![index].items![inindex].qty!, style: TextStyle(fontSize: lsize.maxWidth*0.042,fontWeight: FontWeight.bold),)],
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
                                                ? (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height + 5) + (widget.l2StyleData.height+25)
                                                : widget.l2StyleData.height;
                                            innerBottomHeights[oindex][index] = innerBottomHeights[oindex][index] == widget.l2StyleData.height
                                                ? (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height + 5) + (widget.l2StyleData.height+25)
                                                : widget.l2StyleData.height;
                                            innerTurns[oindex][index] = innerTurns[oindex][index] == 0.5 ? 1 : 0.5; // Rotate icon
                                            openDropdownIndex = null; // Reset opened index
                                            if(heights[oindex] == (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25)){
                                              heights[oindex] = (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height+5) + 25 + (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                              bottomHeights[oindex] = (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height+5) + 25 + (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                            }else{
                                              heights[oindex] = (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                              bottomHeights[oindex] = (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                            }
                                          } else {
                                            // Close previously opened dropdown and open the new one
                                            if (openDropdownIndex != null) {
                                              innerHeights[oindex][openDropdownIndex!] = widget.l2StyleData.height; // Reset previous dropdown
                                              innerBottomHeights[oindex][openDropdownIndex!] = widget.l2StyleData.height; // Reset previous bottom height
                                              innerTurns[oindex][openDropdownIndex!] = 1;
                                            }
                                            openDropdownIndex = index; // Set current index as opened
                                            heights[oindex] = (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height+5) + 25 + (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                            bottomHeights[oindex] = (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height+5) + 25 + (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25);
                                            innerHeights[oindex][index] =
                                                (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height + 5) +
                                                    (widget.l2StyleData.height+25); // Expand current dropdown
                                            innerBottomHeights[oindex][index] =
                                                (widget.data[oindex].shipments![index].items!.length) * (widget.l3StyleData.height + 5) +
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
                                                'assets/images/shipment.png',
                                                scale: lsize.maxHeight * 0.05,
                                                color: Colors.white,
                                              ),
                                              Gap(lsize.maxWidth * 0.01),
                                              Text('${widget.data[oindex].shipments![index].shipmentNo!.replaceAll('"', '')} (${widget.data[oindex].shipments![index].items!.length})', style: TextStyle(color: Colors.white),),
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
                              ? (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25)
                              : widget.l1StyleData.height;
                          bottomHeights[oindex] = bottomHeights[oindex] == widget.l1StyleData.height
                              ? (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25)
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
                          heights[oindex] = (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25); // Expand current dropdown
                          bottomHeights[oindex] = (widget.data[oindex].shipments!.length) * widget.l2StyleData.height + (widget.l1StyleData.height+25); // Expand current bottom height
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
                              'assets/images/businessman.png',
                              scale: lsize.maxHeight * 0.05,
                            ),
                            Gap(lsize.maxWidth * 0.01),
                            Text(
                              widget.data[oindex].vendorName!,
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

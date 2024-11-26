import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/dock_area/dock_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/expandable_list_view.dart';

class DockAreaDataSheet extends StatefulWidget {
  const DockAreaDataSheet({super.key});

  @override
  State<DockAreaDataSheet> createState() => _DockAreaDataSheetState();
}

class _DockAreaDataSheetState extends State<DockAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late DockAreaBloc _dockAreaBloc;

  

late  WarehouseInteractionBloc _warehouseInteractionBloc ;
  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _dockAreaBloc = context.read<DockAreaBloc>();
    _dockAreaBloc.add(GetDockAreaData(
        searchText: context.read<WarehouseInteractionBloc>().state.searchText,
        searchArea: context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in') ? "DOCK_IN" : "DOCK_OUT"));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _dockAreaBloc.state.pageNum = _dockAreaBloc.state.pageNum! + 1;
      _dockAreaBloc.add(GetDockAreaData(
          searchText: context.read<WarehouseInteractionBloc>().state.searchText,
          searchArea: context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in') ? "DOCK_IN" : "DOCK_OUT"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Dock Area', children: [
      BlocBuilder<DockAreaBloc, DockAreaState>(
        builder: (context, state) {
          bool isEnabled = state.getDataState != GetDataState.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child:(state.getDataState== GetDataState.success &&  state.dockAreaItems!.length==0)?
                        Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.048),),Text("Data not found")],)
                       : ListView.builder(
                        
                    controller: _controller,
                    itemBuilder: (context, index) => index < state.dockAreaItems!.length
                        ? Container(
                            height: lsize.maxHeight * 0.16,
                            width: lsize.maxWidth * 0.96,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(lsize.maxHeight * 0.01),
                            margin: EdgeInsets.only(top: lsize.maxWidth * 0.01),
                            child: LayoutBuilder(builder: (context, containerSize) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/truck.png',
                                          height: containerSize.maxHeight * 0.24,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      Text(
                                        state.dockAreaItems![index].truckNum!,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: containerSize.maxWidth * 0.048, height: containerSize.maxHeight * 0.0016, fontWeight: FontWeight.bold, ),
                                      ),
                                      Spacer(),
                                      Image.asset(
                                        'assets/images/businessman.png',
                                        height: containerSize.maxHeight * 0.2,
                                        width: containerSize.maxWidth * 0.08,
                                      ),
                                      Text(
                                        state.dockAreaItems![index].vendor!,
                                        style: TextStyle(
                                            fontSize: containerSize.maxWidth * 0.048, height: containerSize.maxHeight * 0.0016, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  // Gap(size.height*0.01),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/po.png',
                                          height: containerSize.maxHeight * 0.12,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      SizedBox(
                                          width: containerSize.maxWidth * 0.35,
                                          child: SingleChildScrollView(
                                            child: Text(
                                              state.dockAreaItems![index].poNum!,
                                              style: TextStyle(
                                                  fontSize: containerSize.maxWidth * 0.048,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      Spacer(),
                                     
                                      Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/qty.png',
                                          height: containerSize.maxHeight * 0.12,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      Text(
                                        state.dockAreaItems![index].qty!.toString(),
                                        style: TextStyle(
                                            fontSize: containerSize.maxWidth * 0.048, height: containerSize.maxHeight * 0.0016, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  // Gap(size.height*0.01),
                                 
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/clock.png',
                                          height: containerSize.maxHeight * 0.14,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      Text(
                                        state.dockAreaItems![index].checkInTS == "null" ? "2024-07-23" : state.dockAreaItems![index].checkInTS!,
                                        style: TextStyle(
                                            fontSize: containerSize.maxWidth * 0.048, height: containerSize.maxHeight * 0.0016, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }),
                          )
                        : Container(
                            height: lsize.maxHeight * 0.16,
                            width: lsize.maxWidth * 0.96,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(size.height * 0.01),
                            margin: EdgeInsets.only(top: size.height * 0.01),
                            child: LayoutBuilder(builder: (context, containerSize) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                       Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/truck.png',
                                          height: containerSize.maxHeight * 0.24,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      Skeletonizer(
                                          enableSwitchAnimation: true,
                                          child: Text(
                                            '------------',
                                            style: TextStyle(
                                                fontSize: containerSize.maxWidth * 0.048,
                                                height: containerSize.maxHeight * 0.0016,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Spacer(),
                                       Image.asset(
                                        'assets/images/businessman.png',
                                        height: containerSize.maxHeight * 0.2,
                                        width: containerSize.maxWidth * 0.08,
                                      ),
                                      Skeletonizer(
                                          enableSwitchAnimation: true,
                                          child: Text(
                                            '--------',
                                            style: TextStyle(
                                                fontSize: containerSize.maxWidth * 0.048,
                                                height: containerSize.maxHeight * 0.0016,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  // Gap(size.height * 0.01),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/po.png',
                                          height: containerSize.maxHeight * 0.12,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      Skeletonizer(
                                          enableSwitchAnimation: true,
                                          child: Text(
                                            '--------',
                                            style: TextStyle(
                                                fontSize: containerSize.maxWidth * 0.048,
                                                height: containerSize.maxHeight * 0.0016,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Spacer(),
                                        Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/qty.png',
                                          height: containerSize.maxHeight * 0.12,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      Skeletonizer(
                                          enableSwitchAnimation: true,
                                          child: Text(
                                            '------',
                                            style: TextStyle(
                                                fontSize: containerSize.maxWidth * 0.048,
                                                height: containerSize.maxHeight * 0.0016,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  // Gap(size.height * 0.01),
                                  Row(
                                    children: [
                                        Padding(
                                        padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                        child: Image.asset(
                                          'assets/images/clock.png',
                                          height: containerSize.maxHeight * 0.14,
                                          width: containerSize.maxWidth * 0.12,
                                        ),
                                      ),
                                      Skeletonizer(
                                          enableSwitchAnimation: true,
                                          child: Text(
                                            'Time',
                                            style: TextStyle(
                                                fontSize: containerSize.maxWidth * 0.048,
                                                height: containerSize.maxHeight * 0.0016,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  )
                                ],
                              );
                            }),
                          ),
                    itemCount: isEnabled
                        ? 8
                        : state.dockAreaItems!.length + 1 > (state.pageNum! + 1) * 100
                            ? state.dockAreaItems!.length + 1
                            : state.dockAreaItems!.length),
              );
            }),
          );
        },
      )
    ]);
  }
}


/*
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/dock_area/dock_area_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/customs/expandable_list_view.dart';

class DockAreaDataSheet extends StatefulWidget {
  const DockAreaDataSheet({super.key});

  @override
  State<DockAreaDataSheet> createState() => _DockAreaDataSheetState();
}

class _DockAreaDataSheetState extends State<DockAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late DockAreaBloc _dockAreaBloc;

  final Map<String, dynamic> response1 = {
    "Truck-01" : [
      {
        "name": "Vendor-101"
      },
      {
        "name": "Vendor-102"
      },
      {
        "name": "Vendor-103"
      }
    ],
    "Truck-02" : [
      {
        "name": "Vendor-201"
      },
      {
        "name": "Vendor-202"
      },
      {
        "name": "Vendor-203"
      }
    ],
    "Truck-03" : [
      {
        "name": "Vendor-301"
      },
      {
        "name": "Vendor-302"
      },
      {
        "name": "Vendor-303"
      }
    ],
    "Truck-04" : [
      {
        "name": "Vendor-401"
      },
      {
        "name": "Vendor-402"
      },
      {
        "name": "Vendor-403"
      }
    ],
    "Truck-05" : [
      {
        "name": "Vendor-501"
      },
      {
        "name": "Vendor-502"
      },
      {
        "name": "Vendor-503"
      }
    ]
  };

  final Map<String, dynamic> response2 = {
    "Vendor-101": [
      {
        "po_num": "PO-101-1",
        "create_ts": "3:00pm",
        "qty": 5,
      },
      {
        "po_num": "PO-101-1",
        "create_ts": "3:00pm",
        "qty": 5,
      },
      {
        "po_num": "PO-101-1",
        "create_ts": "3:00pm",
        "qty": 5,
      }
    ],
    "Vendor-102": [
      {
        "po_num": "PO-102-1",
        "create_ts": "3:00pm",
        "qty": 5,
      },
      {
        "po_num": "PO-102-1",
        "create_ts": "3:00pm",
        "qty": 5,
      },
      {
        "po_num": "PO-102-1",
        "create_ts": "3:00pm",
        "qty": 5,
      }
    ]
  };


  @override
  void initState() {
    super.initState();

    _dockAreaBloc = context.read<DockAreaBloc>();
      _dockAreaBloc.add( GetDockAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText,searchArea:context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in')?"DOCK_IN":"DOCK_OUT" ));
    
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _dockAreaBloc.state.pageNum = _dockAreaBloc.state.pageNum! + 1;
      _dockAreaBloc.add( GetDockAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText,searchArea:context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in')?"DOCK_IN":"DOCK_OUT" ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Dock Area',
      children: [
          BlocBuilder<DockAreaBloc, DockAreaState>(
            builder: (context, state) {
              bool isEnabled = state.getDataState != GetDataState.success;
              return Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ListView.builder(
                        controller: _controller,
                        itemBuilder: (context, index) => index < state.dockAreaItems!.length
                                ? 
                           Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(112, 144, 185, 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.all(size.height*0.01),
                                  margin: EdgeInsets.only(top: size.height*0.01),
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        Image.asset('assets/images/truck.png', scale: size.height*0.0018,),
                                        Text(state.dockAreaItems![index].truckNum!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                        Spacer(),
                                        Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                        Text(state.dockAreaItems![index].vendor!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)
                                      ],),
                                      Gap(size.height*0.01),
                                      Row(children: [
                                        Padding(
                                          padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.007),
                                          child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                        ),
                                        Text(state.dockAreaItems![index].poNum!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(right: size.width*0.008),
                                          child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                        ),
                                        Text(state.dockAreaItems![index].qty!.toString(), style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)
                                      ],),
                                      Gap(size.height*0.01),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.009),
                                            child: Image.asset('assets/images/clock.png', scale: size.height*0.0008,),
                                          ),
                                          Text(state.dockAreaItems![index].checkInTS!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            : 
                            Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(112, 144, 185, 1),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                padding: EdgeInsets.all(size.height*0.01),
                                margin: EdgeInsets.only(top: size.height*0.01),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      Image.asset('assets/images/truck.png', scale: size.height*0.0018,),
                                      Skeletonizer(enableSwitchAnimation: true,child: Text('TS 02 ED 7884', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                      Spacer(),
                                      Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                      Skeletonizer(enableSwitchAnimation: true,child: Text('ORACLE', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                    ],),
                                    Gap(size.height*0.01),
                                    Row(children: [
                                      Padding(
                                        padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.007),
                                        child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                      ),
                                      Skeletonizer(enableSwitchAnimation: true,child: Text('MI-PO-234', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(right: size.width*0.008),
                                        child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                      ),
                                      Skeletonizer(enableSwitchAnimation: true,child: Text('2000', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                    ],),
                                    Gap(size.height*0.01),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.009),
                                          child: Image.asset('assets/images/clock.png', scale: size.height*0.0008,),
                                        ),
                                        Skeletonizer(enableSwitchAnimation: true,child: Text('3:15pm', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        itemCount: isEnabled ? 8 : state.dockAreaItems!.length + 1 > (state.pageNum!+1)*100 ? state.dockAreaItems!.length + 1 : state.dockAreaItems!.length),
                ),
              );
            },
          )
      ]
    );
  }
}


/*
*/
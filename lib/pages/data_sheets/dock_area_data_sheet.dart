import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/dock_area/dock_area_bloc.dart';
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
    if (_dockAreaBloc.state.getDataState == GetDataState.initial) {
      _dockAreaBloc.add(const GetDockAreaData());
    }
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _dockAreaBloc.state.pageNum = _dockAreaBloc.state.pageNum! + 1;
      _dockAreaBloc.add(const GetDockAreaData());
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
                child: Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: ExpandableListView(data: [response1, response2])
                ),
              );
            },
          )
      ]
    );
  }
}


/*
ListView.builder(
                        controller: _controller,
                        itemBuilder: (context, index) => index < response1.length
                                ? 
                            ExpandableListView(height: size.height, data: [response1, response2],)
                            //     Customs.MapInfo(size: size, keys: [
                            //   // 'Dock Type',
                            //   'Truck No.',
                            //   'PO No.',
                            //   'Vendor',
                            //   'CheckIn TS',
                            //   'Quantity'
                            // ], values: [
                            //   // isEnabled ? 'Dock Type' : state.dockAreaItems![index].dockType!,
                            //   isEnabled ? 'Truck No.' : state.dockAreaItems![index].truckNum!,
                            //   isEnabled ? 'PO No.' : state.dockAreaItems![index].poNum!,
                            //   isEnabled ? 'Vendor' : state.dockAreaItems![index].vendor!,
                            //   isEnabled ? 'CheckIn TS': state.dockAreaItems![index].checkInTS!,
                            //   isEnabled ? 'Quantity' : state.dockAreaItems![index].qty!.toString()
                            // ]) 
                            : 
                            Skeletonizer(
                              child: SizedBox(
                              height: size.height*0.1,
                              width: size.width*0.15,
                              child: Card(
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Column(
                                        children: [
                                          const Text("10", style: TextStyle(color: Colors.white),),
                                          Image.asset('assets/images/truck.png', color: Colors.white,)
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ),
                            )
                              // Customs.MapInfo(size: size, keys: [
                              //   // 'Dock Type',
                              //   'Truck No.',
                              //   'PO No.',
                              //   'Vendor',
                              //   'CheckIn TS',
                              //   'Quantity'
                              // ], values: [
                              //   // 'Dock Type',
                              //   'Truck No.',
                              //   'PO No.',
                              //   'Vendor',
                              //   'CheckIn TS',
                              //   'Quantity'
                              // ]),
                            ),
                        itemCount: isEnabled ? 8 : state.dockAreaItems!.length + 1 > (state.pageNum!+1)*100 ? state.dockAreaItems!.length + 1 : state.dockAreaItems!.length),*/
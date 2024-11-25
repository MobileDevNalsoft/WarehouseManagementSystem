import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/yard/yard_bloc.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class YardAreaDataSheet extends StatefulWidget {
  const YardAreaDataSheet({super.key});

  @override
  State<YardAreaDataSheet> createState() => _YardAreaDataSheetState();
}

class _YardAreaDataSheetState extends State<YardAreaDataSheet> {
  late YardBloc _yardBloc;
  final ScrollController _controller = ScrollController();
late  WarehouseInteractionBloc _warehouseInteractionBloc ;
  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _yardBloc = context.read<YardBloc>();
    _yardBloc.add(GetYardData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _yardBloc.state.pageNum = _yardBloc.state.pageNum! + 1;
      _yardBloc.add(GetYardData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Customs.DataSheet(context: context, size: size, title: 'Yard Area', children: [
      BlocBuilder<YardBloc, YardState>(
        builder: (context, state) {
          bool isEnabled = state.yardAreaStatus != YardAreaStatus.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: (state.yardAreaStatus== YardAreaStatus.success &&  state.yardAreaItems!.length==0)?
                        Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.044),),Text("Data not found")],)
                       :ListView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) => index < state.yardAreaItems!.length
                        ? Container(
                            height: lsize.maxHeight * 0.12,
                            width: lsize.maxWidth * 0.96,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(lsize.maxHeight * 0.01),
                            margin: EdgeInsets.only(top: lsize.maxWidth * 0.01),
                            child: LayoutBuilder(builder: (context, containerSize) {
                              return Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.016),
                                        child: Image.asset(
                                          'assets/images/truck.png',
                                          height: containerSize.maxHeight*0.36, width: containerSize.maxWidth*0.16,
                                        ),
                                      ),
                                      Text(
                                        state.yardAreaItems![index].truckNbr!,
                                        style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.016),
                                        child: Image.asset(
                                          'assets/images/location.png',
                                          height: containerSize.maxHeight*0.28, width: containerSize.maxWidth*0.16,
                                        ),
                                      ),
                                      Text(
                                        state.yardAreaItems![index].vehicleLocation!,
                                        style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.001),
                                        child: Image.asset('assets/images/clock.png',height: containerSize.maxHeight*0.32, width: containerSize.maxWidth*0.12,),
                                      ),
                                      SizedBox(
                                          width: containerSize.maxWidth*0.16,
                                          child: Text(
                                            
                                            state.yardAreaItems![index].vehicleEntryTime!.split('T')[1].substring(0, 5),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                ],
                              );
                            }),
                          )
                        : Container(
                           height: lsize.maxHeight*0.12,
                                  width: lsize.maxWidth*0.96,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all( lsize.maxHeight*0.01),
                                      margin: EdgeInsets.only(top: lsize.maxWidth*0.01),
                                      child: LayoutBuilder(
                                        builder: (context,containerSize) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                         Padding(
                                        padding:  EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.016),
                                        child: Image.asset(
                                          'assets/images/truck.png',
                                          height: containerSize.maxHeight*0.36, width: containerSize.maxWidth*0.16,
                                        ),
                                      ),
                                        Skeletonizer(
                                            enableSwitchAnimation: true,
                                            child: Text(
                                              'TRUCK NUMBER',
                                              style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                       Padding(
                                        padding:EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.016),
                                        child: Image.asset(
                                          'assets/images/location.png',
                                          height: containerSize.maxHeight*0.28, width: containerSize.maxWidth*0.16,
                                        ),
                                      ),
                                        Skeletonizer(
                                            enableSwitchAnimation: true,
                                            child: Text(
                                              'LOCATION',
                                              style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),
                                            )),
                                        Spacer(),
                                          Padding(
                                        padding:EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.001),
                                        child: Image.asset('assets/images/clock.png',height: containerSize.maxHeight*0.32, width: containerSize.maxWidth*0.12,),
                                      ),
                                        Skeletonizer(
                                          enableSwitchAnimation: true,
                                          child: Text('TIME', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              }
                            ),
                          ),
                    itemCount: isEnabled
                        ? 8
                        : state.yardAreaItems!.length + 1 > (state.pageNum! + 1) * 100
                            ? state.yardAreaItems!.length + 1
                            : state.yardAreaItems!.length),
              );
            }),
          );
        },
      )
    ]);
  }
}

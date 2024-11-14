
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

  @override
  void initState() {
    super.initState();

    _yardBloc = context.read<YardBloc>();
    if (_yardBloc.state.yardAreaStatus == YardAreaStatus.initial) {
      _yardBloc.add(const GetYardData());
    }
  
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _yardBloc.state.pageNum = _yardBloc.state.pageNum! + 1;
      _yardBloc.add(const GetYardData());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Customs.DataSheet(
      context: context,
      size: size,
      title: 'Yard Area',
      children: [
        BlocBuilder<YardBloc, YardState>(
            builder: (context, state) {
              bool isEnabled = state.yardAreaStatus != YardAreaStatus.success;
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.yardAreaItems!.length
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
                                            Text(state.yardAreaItems![index].truckNbr!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.008, right: size.width*0.008),
                                              child: Image.asset('assets/images/location.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.yardAreaItems![index].vehicleLocation!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(right: size.width*0.005),
                                              child: Image.asset('assets/images/clock.png', scale: size.height*0.001),
                                            ),
                                            SizedBox(width: lsize.maxWidth*0.15, child: Text(state.yardAreaItems![index].vehicleEntryTime!.split('T')[1].substring(0,5), style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                          ],),
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
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('TRUCK NUMBER', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.007),
                                              child: Image.asset('assets/images/location.png', scale: size.height*0.0018,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('LOCATION', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(right: size.width*0.008),
                                              child: Image.asset('assets/images/clock.png', scale: size.height*0.001,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('TIME', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold)),)
                                          ],),
                                      ],
                                    ),
                                  ),
                            itemCount: isEnabled ? 8 : state.yardAreaItems!.length + 1 > (state.pageNum!+1)*100 ? state.yardAreaItems!.length + 1 : state.yardAreaItems!.length),
                    );
                  }
                ),
              );
            },
          )
      ]
    );
  
  }
}
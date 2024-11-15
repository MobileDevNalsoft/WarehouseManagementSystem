import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/activity_area/activity_area_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class ActivityAreaDataSheet extends StatefulWidget {
  const ActivityAreaDataSheet({super.key});

  @override
  State<ActivityAreaDataSheet> createState() => _ActivityAreaDataSheetState();
}

class _ActivityAreaDataSheetState extends State<ActivityAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late ActivityAreaBloc _activityBloc;

  @override
  void initState() {
    super.initState();

    _activityBloc = context.read<ActivityAreaBloc>();
     _activityBloc.add( GetActivityAreaData( searchText: context.read<WarehouseInteractionBloc>().state.searchText));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
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
                child: LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.activityAreaItems!.length
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
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.008, right: size.width*0.006),
                                              child: Image.asset('assets/images/wo.png', scale: size.height*0.0019, color: Colors.grey.shade900,),
                                            ),
                                            Text(state.activityAreaItems![index].workOrderNum!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.005, right: size.width*0.004),
                                              child: Image.asset('assets/images/wo_type.png', scale: size.height*0.0018,color: Colors.grey.shade900),
                                            ),
                                            Text(state.activityAreaItems![index].workOrderType!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.01, right: size.width*0.006),
                                              child: Image.asset('assets/images/item.png', scale: size.height*0.0045,color: Colors.grey.shade900),
                                            ),
                                            Text(state.activityAreaItems![index].item!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(right: size.width*0.005),
                                              child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                            ),
                                            SizedBox(width: lsize.maxWidth*0.15, child: Text(state.activityAreaItems![index].qty!.toString(), style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
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
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.008, right: size.width*0.006),
                                              child: Image.asset('assets/images/wo.png', scale: size.height*0.0019, color: Colors.grey.shade900,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text("WORK ORDER", style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.005, right: size.width*0.004),
                                              child: Image.asset('assets/images/wo_type.png', scale: size.height*0.0018,color: Colors.grey.shade900),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('WORK TYPE', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.01, right: size.width*0.006),
                                              child: Image.asset('assets/images/item.png', scale: size.height*0.0045,color: Colors.grey.shade900),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('ITEM', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(right: size.width*0.005),
                                              child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('QTY', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                          ],),
                                      ],
                                    ),
                                  ),
                            itemCount: isEnabled ? 8 : state.activityAreaItems!.length + 1 > (state.pageNum!+1)*100 ? state.activityAreaItems!.length + 1 : state.activityAreaItems!.length),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/activity_area/activity_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
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
                      child: (state.getDataState== GetDataState.success &&  state.activityAreaItems!.length==0)?
                        Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.044),),Text("Data not found")],)
                       : ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.activityAreaItems!.length
                                    ? 
                               Container(
                                   height: lsize.maxHeight*0.18,
                                  width: lsize.maxWidth*0.96,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all(size.height*0.01),
                                      margin: EdgeInsets.only(top: size.height*0.01),
                                      child: LayoutBuilder(
                                        builder: (context,containerSize) {
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.002, right: containerSize.maxWidth*0.004),
                                                  child: Image.asset('assets/images/wo.png',  height: containerSize.maxHeight*0.2, width: containerSize.maxWidth*0.12, color: Colors.grey.shade900,),
                                                ),
                                                Text(state.activityAreaItems![index].workOrderNum!, style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                              ],),
                                              // Gap(size.height*0.01),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.002, right: containerSize.maxWidth*0.004),
                                                  child: Image.asset('assets/images/wo_type.png', height: containerSize.maxHeight*0.2, width: containerSize.maxWidth*0.12,color: Colors.grey.shade900),
                                                ),
                                                Text(state.activityAreaItems![index].workOrderType!, style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                              ],),
                                              // Gap(size.height*0.01),
                                              Row(children: [
                                              Padding(
                                                  padding: EdgeInsets.only( right:containerSize.maxWidth*0.046,left: containerSize.maxWidth*0.018),
                                                  child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.125, width: containerSize.maxWidth*0.095,),
                                                ),
                                                Text(state.activityAreaItems![index].item!, style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                Spacer(),
                                               Padding(
                                                  padding: EdgeInsets.only(right: containerSize.maxWidth*0.016),
                                                  child: Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.12,),
                                                ),
                                                Gap(containerSize.maxWidth*0.024),
                                                SizedBox(width: containerSize.maxWidth*0.16, child: Text(state.activityAreaItems![index].qty!.toString(), style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))
                                              ],),
                                            ],
                                          );
                                        }
                                      ),
                                    )
                                : 
                                Container(
                                  height: lsize.maxHeight*0.18,
                                  width: lsize.maxWidth*0.96,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    padding: EdgeInsets.all(size.height*0.01),
                                    margin: EdgeInsets.only(top: size.height*0.01),
                                    child: LayoutBuilder(
                                        builder: (context,containerSize) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.002, right: containerSize.maxWidth*0.004),
                                                  child: Image.asset('assets/images/wo.png',  height: containerSize.maxHeight*0.2, width: containerSize.maxWidth*0.12, color: Colors.grey.shade900,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: Text("WORK ORDER", style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                              ],),
                                              // Gap(size.height*0.01),
                                              Row(children: [
                                               Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.002, right: containerSize.maxWidth*0.004),
                                                  child: Image.asset('assets/images/wo_type.png', height: containerSize.maxHeight*0.2, width: containerSize.maxWidth*0.12,color: Colors.grey.shade900),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: Text('WORK TYPE', style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                              ],),
                                              // Gap(size.height*0.01),
                                              Row(children: [
                                             Padding(
                                                  padding: EdgeInsets.only( right:containerSize.maxWidth*0.046,left: containerSize.maxWidth*0.018),
                                                  child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.125, width: containerSize.maxWidth*0.095,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: Text('ITEM', style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                             Padding(
                                                  padding: EdgeInsets.only(right: containerSize.maxWidth*0.016),
                                                  child: Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.12,),
                                                ),
                                                SizedBox(width: containerSize.maxWidth*0.16,child: Skeletonizer(enableSwitchAnimation: true,child: Text('QTY', style: TextStyle(fontSize:containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)))
                                              ],),
                                          ],
                                        );
                                      }
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

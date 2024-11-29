import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/staging/staging_bloc.dart';
import 'package:wmssimulator/bloc/staging/staging_event.dart';
import 'package:wmssimulator/bloc/staging/staging_state.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class StagingAreaDataSheet extends StatefulWidget {
  const StagingAreaDataSheet({super.key});

  @override
  State<StagingAreaDataSheet> createState() => _StagingAreaDataSheetState();
}

class _StagingAreaDataSheetState extends State<StagingAreaDataSheet> {
   final ScrollController _controller = ScrollController();
   StagingBloc? _stagingBloc;
  late  WarehouseInteractionBloc _warehouseInteractionBloc ;

  @override
  void initState() {
    super.initState();
     _stagingBloc = context.read<StagingBloc>();
     _stagingBloc!.add( GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    _controller.addListener(_scrollListener);
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }



  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent && _stagingBloc!.state.stagingList!.length + 1 > (_stagingBloc!.state.pageNum! + 1) * 100) {
      print("reached end of the screen");

        _stagingBloc!.state.pageNum = _stagingBloc!.state.pageNum! + 1;

        print("before api call in scroll");

       _stagingBloc!.add( GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));


    
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Staging Area',
      children: [
        BlocBuilder<StagingBloc, StagingState>(
            builder: (context, state) {
              bool isEnabled = state.stagingStatus != StagingAreaStatus.success;
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:  (state.stagingStatus== StagingAreaStatus.success &&  state.stagingList!.length==0)?
                        Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.044),),Text("Data not found")],)
                       : 
                      ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.stagingList!.length
                                    ? 
                               Container(
                                height: lsize.maxHeight*0.16,
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
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/od.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.12,),
                                                ),
                                                SizedBox(width: containerSize.maxWidth*0.8, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.stagingList![index].orderNum!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold), maxLines: 1,))),
                                                
                                               ],),
                                               Padding(
                                                 padding:  EdgeInsets.only(right: containerSize.maxWidth*0.016),
                                                 child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [ Image.asset('assets/images/businessman.png', height:   containerSize.maxHeight*0.18, width: containerSize.maxWidth*0.16,),
                                                  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.stagingList![index].custName!=""?state.stagingList![index].custName!:"NA", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))
                                                                                               ],),
                                               ),
                                              
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only( right:containerSize.maxWidth*0.046,left: containerSize.maxWidth*0.018),
                                                  child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.125, width: containerSize.maxWidth*0.095,),
                                                ),
                                                Text(state.stagingList![index].item!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(right: containerSize.maxWidth*0.016),
                                                  child: Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.12,),
                                                ),
                                                SizedBox(width: containerSize.maxWidth*0.2, child: Text(state.stagingList![index].qty!.toString(), style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))
                                              ],)
                                            ],
                                          );
                                        }
                                      ),
                                    )
                                : 
                                Container(
                                   height: lsize.maxHeight*0.16,
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
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/od.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.12,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: Text('ORDER NUM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold), maxLines: 1,),),
                                                
                                               
                                              ],),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(children: [ Image.asset('assets/images/businessman.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                  Skeletonizer(enableSwitchAnimation: true,child: Text('CUSTOMER ', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))],),
                                              ),
                                              Row(children: [
                                               Padding(
                                                  padding: EdgeInsets.only( right:containerSize.maxWidth*0.046,left: containerSize.maxWidth*0.018),
                                                  child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.125, width: containerSize.maxWidth*0.095,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: Text('ITEM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                               Padding(
                                                  padding: EdgeInsets.only(right: containerSize.maxWidth*0.016),
                                                  child: Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.12,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: SizedBox(width: containerSize.maxWidth*0.2, child: Text('QTY', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)))
                                              ],)
                                          ],
                                        );
                                      }
                                    ),
                                  ),
                            itemCount: isEnabled ? 8 : state.stagingList!.length + 1 > (state.pageNum!+1)*100 ? state.stagingList!.length + 1 : state.stagingList!.length),
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

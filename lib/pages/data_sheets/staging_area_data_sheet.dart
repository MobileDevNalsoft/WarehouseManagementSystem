import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/staging/staging_bloc.dart';
import 'package:warehouse_3d/bloc/staging/staging_event.dart';
import 'package:warehouse_3d/bloc/staging/staging_state.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class StagingAreaDataSheet extends StatefulWidget {
  const StagingAreaDataSheet({super.key});

  @override
  State<StagingAreaDataSheet> createState() => _StagingAreaDataSheetState();
}

class _StagingAreaDataSheetState extends State<StagingAreaDataSheet> {
   final ScrollController _controller = ScrollController();
   StagingBloc? _stagingBloc;

  @override
  void initState() {
    super.initState();
     _stagingBloc = context.read<StagingBloc>();
     _stagingBloc!.add( GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    _controller.addListener(_scrollListener);
  }



  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
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
                      child: ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.stagingList!.length
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
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.007),
                                              child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                            ),
                                            SizedBox(width: lsize.maxWidth*0.4, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.stagingList![index].orderNum!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold), maxLines: 1,))),
                                            Spacer(),
                                            Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                            SizedBox(width: lsize.maxWidth*0.25, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.stagingList![index].custName!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)))
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.007, right: size.width*0.009),
                                              child: Image.asset('assets/images/item.png', scale: size.height*0.0045,),
                                            ),
                                            Text(state.stagingList![index].item!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(right: size.width*0.008),
                                              child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                            ),
                                            SizedBox(width: lsize.maxWidth*0.2, child: Text(state.stagingList![index].qty!.toString(), style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                          ],)
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
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.007),
                                              child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('ORDER NUM', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold), maxLines: 1,),),
                                            Spacer(),
                                            Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('CUSTOMER ', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.007, right: size.width*0.009),
                                              child: Image.asset('assets/images/item.png', scale: size.height*0.0045,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: Text('ITEM', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(right: size.width*0.008),
                                              child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true,child: SizedBox(width: lsize.maxWidth*0.2, child: Text('QTY', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)))
                                          ],)
                                      ],
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

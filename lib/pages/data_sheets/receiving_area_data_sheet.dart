import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/receiving/receiving_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_event.dart';
import 'package:wmssimulator/bloc/receiving/receiving_state.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class ReceivingAreaDataSheet extends StatefulWidget {
  const ReceivingAreaDataSheet({super.key});

  @override
  State<ReceivingAreaDataSheet> createState() => _ReceivingAreaDataSheetState();
}

class _ReceivingAreaDataSheetState extends State<ReceivingAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  ReceivingBloc? _receivingBloc;
late  WarehouseInteractionBloc _warehouseInteractionBloc ;
  @override
  void initState() {
    super.initState();
    _receivingBloc = context.read<ReceivingBloc>();
    
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    print("inside receiving init state");
      _receivingBloc!.add( GetReceivingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));


    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _receivingBloc!.state.pageNum = _receivingBloc!.state.pageNum! + 1;
      _receivingBloc!.add(GetReceivingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
        context: context,
        size: size,
        title: 'Receiving Area',
        children: [
          BlocBuilder<ReceivingBloc, ReceivingState>(
            builder: (context, state) {
              bool isEnabled = state.receivingStatus != ReceivingAreaStatus.success;
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:(state.receivingStatus== ReceivingAreaStatus.success &&  state.receiveList!.length==0)?
                        Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.044),),Text("Data not found")],)
                       : ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.receiveList!.length
                                    ? 
                               Container(
                                  height: lsize.maxHeight*0.16,
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
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/asn.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.12,),
                                                ),
                                                Text(state.receiveList![index].asn!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                
                                              ],),
                                              // Gap(size.height*0.01),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/po.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.12,),
                                                ),
                                                Text(state.receiveList![index].poNum!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                Spacer(),
                                                Image.asset('assets/images/businessman.png', height: containerSize.maxHeight*0.14, width: containerSize.maxWidth*0.14,),
                                                SizedBox(width: lsize.maxWidth*0.2, child: Text(state.receiveList![index].vendor!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))
                                              ],),
                                              // Gap(size.height*0.01),
                                              Row(
                                                children: [
                                                 Padding(
                                                  padding: EdgeInsets.only( right:containerSize.maxWidth*0.046,left: containerSize.maxWidth*0.018),
                                                  child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.125, width: containerSize.maxWidth*0.095,),
                                                ),
                                                  Text(state.receiveList![index].item!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                  Spacer(),
                                                 Padding(
                                                  padding: EdgeInsets.only(right: containerSize.maxWidth*0.016),
                                                  child: Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.12,),
                                                ),
                                                  SizedBox(width: lsize.maxWidth*0.15,child: Text(state.receiveList![index].qty!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))
                                                ],
                                              )
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
                                    child:  LayoutBuilder(
                                        builder: (context,containerSize) {
                                        return Column(
                                          children: [
                                            Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/asn.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.12,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text('ASN NUM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                
                                              ],),
                                              Gap(size.height*0.01),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/po.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.12,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text('PO NUM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                                Image.asset('assets/images/businessman.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.12,),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text('VENDOR', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))
                                              ],),
                                              Gap(size.height*0.01),
                                              Row(
                                                children: [
                                                  Padding(
                                                  padding: EdgeInsets.only( right:containerSize.maxWidth*0.046,left: containerSize.maxWidth*0.018),
                                                  child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.125, width: containerSize.maxWidth*0.095,),
                                                ),
                                                  Skeletonizer(enableSwitchAnimation: true, child: Text('ITEM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                  Spacer(),
                                                  Padding(
                                                  padding: EdgeInsets.only(right: containerSize.maxWidth*0.016),
                                                  child: Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.12,),
                                                ),
                                                  Skeletonizer(enableSwitchAnimation: true, child: Text('QuanT', style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))
                                                ],
                                              )
                                          ],
                                        );
                                      }
                                    ),
                                  ),
                            itemCount: isEnabled ? 8 : state.receiveList!.length + 1 > (state.pageNum!+1)*100 ? state.receiveList!.length + 1 : state.receiveList!.length),
                    );
                  }
                ),
              );
            },
          )
        ]);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_bloc.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_event.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_state.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class ReceivingAreaDataSheet extends StatefulWidget {
  const ReceivingAreaDataSheet({super.key});

  @override
  State<ReceivingAreaDataSheet> createState() => _ReceivingAreaDataSheetState();
}

class _ReceivingAreaDataSheetState extends State<ReceivingAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  ReceivingBloc? _receivingBloc;

  @override
  void initState() {
    super.initState();
    _receivingBloc = context.read<ReceivingBloc>();
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
                      child: ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.receiveList!.length
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
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/asn.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.receiveList![index].asn!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.01),
                                              child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.receiveList![index].poNum!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                            SizedBox(width: lsize.maxWidth*0.2, child: Text(state.receiveList![index].vendor!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.013),
                                                child: Image.asset('assets/images/item.png', scale: size.height*0.0045,),
                                              ),
                                              Text(state.receiveList![index].item!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.009),
                                                child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                              ),
                                              SizedBox(width: lsize.maxWidth*0.15,child: Text(state.receiveList![index].qty!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
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
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/asn.png', scale: size.height*0.0018,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true, child: Text('ASN NUM', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                            
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.01),
                                              child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true, child: Text('PO NUM', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                            Spacer(),
                                            Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                            Skeletonizer(enableSwitchAnimation: true, child: Text('VENDOR', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.013),
                                                child: Image.asset('assets/images/item.png', scale: size.height*0.0045,),
                                              ),
                                              Skeletonizer(enableSwitchAnimation: true, child: Text('ITEM', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.009),
                                                child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                              ),
                                              Skeletonizer(enableSwitchAnimation: true, child: Text('QuanT', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                            ],
                                          )
                                      ],
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

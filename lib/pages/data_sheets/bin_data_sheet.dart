import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/storage/storage_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class BinDataSheet extends StatefulWidget {
   const BinDataSheet({super.key});

  @override
  State<BinDataSheet> createState() => _BinDataSheetState();
}

class _BinDataSheetState extends State<BinDataSheet> {
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  late StorageBloc _storageBloc;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _storageBloc = context.read<StorageBloc>();
    _storageBloc.state.storageBinItems = [];
      _storageBloc.add(GetBinData(selectedBin: "RC${_warehouseInteractionBloc.state.dataFromJS['bin']}"));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _storageBloc.state.pageNum = _storageBloc.state.pageNum! + 1;
      _storageBloc.add(GetBinData(selectedBin: "RC${_warehouseInteractionBloc.state.dataFromJS['bin']}"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size, 
      title: 'Storage Bin', children: [
        BlocBuilder<StorageBloc, StorageState>(
            builder: (context, state) {
              bool isEnabled = state.storageBinStatus != StorageBinStatus.success;
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.storageBinItems!.length
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
                                              child: Image.asset('assets/images/bin.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.storageBinItems![index].containerNbr!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/location.png', scale: size.height*0.0018,),
                                            ),
                                            SizedBox(width: lsize.maxWidth*0.3, child: Text(state.storageBinItems![index].currLocationId!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.01),
                                              child: Image.asset('assets/images/location.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.storageBinItems![index].currLocationId!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            // Padding(
                                            //   padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                            //   child: Image.asset('assets/images/batch_no.png', scale: size.height*0.0018,),
                                            // ),
                                            // Text(state.storageBinItems![index].batchNbrID!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/serial_no.png', scale: size.height*0.0018,),
                                            ),
                                             SizedBox(width: lsize.maxWidth*0.3, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.storageBinItems![index].serialNbrKey!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/shipment.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.storageBinItems![index].rcvdShipmentKey!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                            ),
                                             SizedBox(width: lsize.maxWidth*0.3, child: Text(state.storageBinItems![index].refPoNbr!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                          ],),
                                          Gap(size.height*0.015),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.storageBinItems![index].vendor!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/location.png', scale: size.height*0.0018,),
                                            ),
                                             SizedBox(width: lsize.maxWidth*0.3, child:  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.storageBinItems![index].putawaytypeKey!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold)),)),
                                          ],),
                                          Gap(size.height*0.015),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/item.png', scale: size.height*0.0045,),
                                            ),
                                             SizedBox(width: lsize.maxWidth*0.3, child:  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.storageBinItems![index].itemKey!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                            ),
                                             SizedBox(width: lsize.maxWidth*0.3, child: Text(state.storageBinItems![index].currQty!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
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
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/location.png', scale: size.height*0.0018,),
                                            ),
                                            Skeletonizer(enableSwitchAnimation: true, child: Text('ASN NUM', style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),)),
                                            
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/lpn.png', scale: size.height*0.0018,),
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
                            itemCount: isEnabled ? 8 : state.storageBinItems!.length + 1 > (state.pageNum!+1)*100 ? state.storageBinItems!.length + 1 : state.storageBinItems!.length),
                    );
                  }
                ),
              );
            },
          ),
      
    ]);
  }
}

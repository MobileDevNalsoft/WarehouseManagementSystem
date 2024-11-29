import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/storage/storage_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

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
    if(_warehouseInteractionBloc.state.dataFromJS['bin'].toString()==""){

    _storageBloc.add(GetBinData(searchText:context.read<WarehouseInteractionBloc>().state.searchText));

    }
else{
   _storageBloc.add(GetBinData(selectedBin:"RC${_warehouseInteractionBloc.state.dataFromJS['bin']}"));
}   
    _storageBloc.state.storageBinItems = [];
    // _storageBloc.add(GetBinData(selectedBin: "RC${}"));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent && _storageBloc.state.storageBinItems!.length + 1 > (_storageBloc.state.pageNum! + 1) * 100) {
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
      title: _warehouseInteractionBloc.state.dataFromJS['bin'].toString()==""?'Storage Area':'Storage Bin', children: [
        BlocBuilder<StorageBloc, StorageState>(
            builder: (context, state) {
              bool isEnabled = state.storageBinStatus != StorageBinStatus.success;
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:

                       (state.storageBinStatus== StorageBinStatus.success &&  state.storageBinItems!.length==0)?
                        Column(children: [Text(_warehouseInteractionBloc.state.dataFromJS['bin']!=""?_warehouseInteractionBloc.state.dataFromJS['bin']:_warehouseInteractionBloc.state.searchText,style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.044,color: Colors.white),),Text("Data not found",style: TextStyle(color: Colors.white),)],)
                       : ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.storageBinItems!.length
                                    ? 
                              
                               Container(
                                                          height: lsize.maxHeight * 0.32,
                                                           width: lsize.maxWidth * 0.96,
                                                           decoration: BoxDecoration(
                                                             color: Colors.white,
                                                             borderRadius: BorderRadius.circular(15),
                                                           ),
                                                           padding: EdgeInsets.all(lsize.maxHeight * 0.01),
                                                           margin: EdgeInsets.only(top: lsize.maxWidth * 0.01),
                                                           child: LayoutBuilder(builder: (context, containerSize) {
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/bin.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Text(state.storageBinItems![index].containerNbr??"cnbr", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold,),),
                                                Spacer(),
                                                if(_warehouseInteractionBloc.state.dataFromJS.containsKey('bin') && _warehouseInteractionBloc.state.searchText!="")
                                                Transform.rotate(
                                                  angle: 3.14159/2,
                                                  child: IconButton(onPressed: (){
                                                            // if(_warehouseInteractionBloc.state.dataFromJS.containsKey('bin')=="" ){
                                                                                              getIt<JsInteropService>().navigateToBin(state.storageBinItems![index].locationKey.toString().replaceAll('-','').substring(2));
                                                                                              _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.setItem(key: "rack_cam", value: "storageArea"); 
                                                                                            // }
                                                  }, icon: Icon(Icons.bookmark,size: containerSize.maxWidth*0.1,),),
                                                )
                                              
                                              ],),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/shipment.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Text(state.storageBinItems![index].rcvdShipmentKey??"asn1", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold,),),
                                                Spacer(),
                                               
                                              ],),
                                              Row(children: [  Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.016, right: containerSize.maxWidth*0.04),
                                                  child: Image.asset('assets/images/po.png',  height: containerSize.maxHeight*0.08, width: containerSize.maxWidth*0.08,),
                                                ),
                                                 Text(state.storageBinItems![index].refPoNbr??"po1", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                              ],),
                                               Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.008  , right: containerSize.maxWidth*0.06),
                                                  child: Image.asset('assets/images/location.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.08,),
                                                ),
                                                Text(state.storageBinItems![index].currLocationId??"loc1", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                // Padding(
                                                //   padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                //   child: Image.asset('assets/images/batch_no.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                // ),
                                                // Text(state.storageBinItems![index].batchNbrID!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/serial_no.png',  height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.1,),
                                                ),
                                                 SizedBox(width: containerSize.maxWidth*0.36,child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.storageBinItems![index].serialNbrKey!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.004, fontWeight: FontWeight.bold),))),
                                              ],),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/businessman.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Text(state.storageBinItems![index].vendor??"oracle", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold,),),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/location.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                 SizedBox(width: containerSize.maxWidth*0.36,child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.storageBinItems![index].putawaytypeKey??"001", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.004, fontWeight: FontWeight.bold)),)),
                                              ],),
                                              // Gap(size.height*0.015),
                                              Row(children: [
                                                Padding(
                                                    padding: EdgeInsets.only( right:containerSize.maxWidth*0.042),
                                                    child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.14, width: containerSize.maxWidth*0.1,),
                                                  ),
                                                 SizedBox(width: containerSize.maxWidth*0.36, child:  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.storageBinItems![index].itemKey??"item", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.004, fontWeight: FontWeight.bold),))),
                                                Spacer(),
                                                Padding(
                                                    padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right:containerSize.maxWidth*0.032),
                                                    child: 
                                                    Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.09, width: containerSize.maxWidth*0.09,),
                                                  ),
                                                 Text(state.storageBinItems![index].currQty??"1", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold,),),
                                              ],),
                                            ],
                                          );
                                        }
                                      ),
                                    )
                                : 
                                Container(
                                       height: lsize.maxHeight * 0.32,
                            width: lsize.maxWidth * 0.96,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(lsize.maxHeight * 0.01),
                            margin: EdgeInsets.only(top: lsize.maxWidth * 0.01),
                            child: LayoutBuilder(builder: (context, containerSize) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/bin.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                              ],),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/shipment.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                               Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                               
                                              ],),
                                              Row(children: [  Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.016, right: containerSize.maxWidth*0.04),
                                                  child: Image.asset('assets/images/po.png',  height: containerSize.maxHeight*0.08, width: containerSize.maxWidth*0.08,),
                                                ),
Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                              ],),
                                               Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.002, right: containerSize.maxWidth*0.01),
                                                  child: Image.asset('assets/images/location.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.08,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                // Padding(
                                                //   padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                //   child: Image.asset('assets/images/batch_no.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                // ),
                                                // Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/serial_no.png',  height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.1,),
                                                ),
                                                 SizedBox(width: containerSize.maxWidth*0.3, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)))),
                                              ],),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/businessman.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/location.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                 SizedBox(width: containerSize.maxWidth*0.3, child:  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold))),)),
                                              ],),
                                              // Gap(size.height*0.015),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                 SizedBox(width: containerSize.maxWidth*0.3, child:  SingleChildScrollView(scrollDirection: Axis.horizontal, child: Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),)))),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/qty.png',  height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                 SizedBox(width: containerSize.maxWidth*0.3, child: Skeletonizer(enableSwitchAnimation: true,child: Text("----------", style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),))),
                                              ],),
                                          ],
                                        );
                                      }
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

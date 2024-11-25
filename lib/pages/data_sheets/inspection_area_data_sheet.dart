import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class InspectionAreaDataSheet extends StatefulWidget {
  const InspectionAreaDataSheet({super.key});

  @override
  State<InspectionAreaDataSheet> createState() => _InspectionAreaDataSheetState();
}

class _InspectionAreaDataSheetState extends State<InspectionAreaDataSheet> {
  late InspectionAreaBloc _inspectionAreaBloc;
  final ScrollController _controller = ScrollController();
late  WarehouseInteractionBloc _warehouseInteractionBloc ;
  @override
  void initState() {
    super.initState();

    _inspectionAreaBloc = context.read<InspectionAreaBloc>();
   
      _inspectionAreaBloc.add(GetInspectionAreaData(
          searchText: context.read<WarehouseInteractionBloc>().state.searchText
              ));
    
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _inspectionAreaBloc.state.pageNum = _inspectionAreaBloc.state.pageNum! + 1;
      _inspectionAreaBloc.add( GetInspectionAreaData(   searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Inspection Area',
      children: [
        BlocBuilder<InspectionAreaBloc, InspectionAreaState>(
            builder: (context, state) {
              bool isEnabled = state.getDataState != GetDataState.success;
              return Expanded(
                child:   LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: (state.getDataState== GetDataState.success &&  state.inspectionAreaItems!.length==0)?
                        Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.044),),Text("Data not found")],)
                       :ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) {
                              return 
                              index < state.inspectionAreaItems!.length
                                    ? 
                                Container(
                                  
                                  height: lsize.maxHeight*0.18,
                                  width: lsize.maxWidth*0.96,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.all( lsize.maxHeight*0.01),
                                      margin: EdgeInsets.only(top: lsize.maxWidth*0.01),
                                      child: LayoutBuilder(
                                        builder: (context,containerSize) {
                                          double aspectRatio = containerSize.maxWidth/containerSize.maxHeight;
                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/asn.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Text(state.inspectionAreaItems![index].asn!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016,fontWeight: FontWeight.bold),),
                                              ],),
                                              Gap(containerSize.maxHeight*0.1),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right: containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/lpn.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Text(state.inspectionAreaItems![index].lpnNum!, style: TextStyle(fontSize: containerSize.maxWidth*0.044,  height: containerSize.maxHeight*0.0016,fontWeight: FontWeight.bold),),
                                              ],),
                                              Gap(containerSize.maxHeight*0.1),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right:containerSize.maxWidth*0.032),
                                                  child: Image.asset('assets/images/po.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Text(state.inspectionAreaItems![index].poNum!, style: TextStyle(fontSize: containerSize.maxWidth*0.044, height: containerSize.maxHeight*0.0016, fontWeight: FontWeight.bold),),
                                                Spacer(),
                                                Image.asset('assets/images/businessman.png', height: containerSize.maxHeight*0.16, width: containerSize.maxWidth*0.12,),
                                                SizedBox(width: containerSize.maxWidth*0.2, child: Text(state.inspectionAreaItems![index].vendor!, style: TextStyle(fontSize: containerSize.maxWidth*0.044,  height: containerSize.maxHeight*0.0016,fontWeight: FontWeight.bold),))
                                              ],),
                                              Gap(containerSize.maxHeight*0.1),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only( right:containerSize.maxWidth*0.042),
                                                    child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.09,),
                                                  ),
                                                  SizedBox(width: containerSize.maxWidth*0.45, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.inspectionAreaItems![index].item!, style: TextStyle(fontSize: containerSize.maxWidth*0.044,fontWeight: FontWeight.bold),))),
                                                  Spacer(),
                                                  Padding(
                                                    padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right:containerSize.maxWidth*0.032),
                                                    child: 
                                                    Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.14, width: containerSize.maxWidth*0.14,),
                                                  ),
                                                  SizedBox(width: containerSize.maxWidth*0.15,child: Text(state.inspectionAreaItems![index].qty!.toString(), style: TextStyle(fontSize: containerSize.maxWidth*0.044,  height: containerSize.maxHeight*0.0016,fontWeight: FontWeight.bold),))
                                                ],
                                              )
                                            ],
                                          );
                                        }
                                      ),
                                    )
                                : 
                                Container(
                                   height: lsize.maxHeight*0.2,
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
                                          children: [
                                            Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                                  child: Image.asset('assets/images/asn.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text('ASN NUM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, fontWeight: FontWeight.bold),)),
                                                
                                              ],),
                                              Gap(size.height*0.01),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                                  child: Image.asset('assets/images/lpn.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text('ASN NUM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, fontWeight: FontWeight.bold),)),
                                                
                                              ],),
                                              Gap(size.height*0.01),
                                              Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.01),
                                                  child: Image.asset('assets/images/po.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                ),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text('PO NUM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, fontWeight: FontWeight.bold),)),
                                                Spacer(),
                                                Image.asset('assets/images/businessman.png', height: containerSize.maxHeight*0.1, width: containerSize.maxWidth*0.1,),
                                                Skeletonizer(enableSwitchAnimation: true, child: Text('VENDOR', style: TextStyle(fontSize: containerSize.maxWidth*0.044, fontWeight: FontWeight.bold),))
                                              ],),
                                              Gap(size.height*0.01),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only( right:containerSize.maxWidth*0.042),
                                                    child: Image.asset('assets/images/item.png', height: containerSize.maxHeight*0.12, width: containerSize.maxWidth*0.09,),
                                                  ),
                                                  Skeletonizer(enableSwitchAnimation: true, child: Text('ITEM', style: TextStyle(fontSize: containerSize.maxWidth*0.044, fontWeight: FontWeight.bold),)),
                                                  Spacer(),
                                                  Padding(
                                                    padding: EdgeInsets.only(left:containerSize.maxWidth*0.006, right:containerSize.maxWidth*0.032),
                                                    child: 
                                                    Image.asset('assets/images/qty.png', height: containerSize.maxHeight*0.14, width: containerSize.maxWidth*0.14,),
                                                  ),
                                                  Skeletonizer(enableSwitchAnimation: true, child: Text('QuanT', style: TextStyle(fontSize: containerSize.maxWidth*0.044, fontWeight: FontWeight.bold),))
                                                ],
                                              )
                                          ],
                                        );
                                      }
                                    ),
                                  );},
                            itemCount: isEnabled ? 8 : state.inspectionAreaItems!.length + 1 > (state.pageNum!+1)*100 ? state.inspectionAreaItems!.length + 1 : state.inspectionAreaItems!.length),
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

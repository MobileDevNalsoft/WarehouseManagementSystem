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

  @override
  void initState() {
    super.initState();

    _inspectionAreaBloc = context.read<InspectionAreaBloc>();
   
      _inspectionAreaBloc.add(GetInspectionAreaData(
          searchText: context.read<WarehouseInteractionBloc>().state.searchText
              ));
    
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
                child: LayoutBuilder(
                  builder: (context, lsize) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView.builder(
                            controller: _controller,
                            itemBuilder: (context, index) => index < state.inspectionAreaItems!.length
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
                                            Text(state.inspectionAreaItems![index].asn!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.006),
                                              child: Image.asset('assets/images/lpn.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.inspectionAreaItems![index].lpnNum!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.01),
                                              child: Image.asset('assets/images/po.png', scale: size.height*0.0018,),
                                            ),
                                            Text(state.inspectionAreaItems![index].poNum!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            Image.asset('assets/images/businessman.png', scale: size.height*0.0018,),
                                            SizedBox(width: lsize.maxWidth*0.2, child: Text(state.inspectionAreaItems![index].vendor!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
                                          ],),
                                          Gap(size.height*0.01),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.013),
                                                child: Image.asset('assets/images/item.png', scale: size.height*0.0045,),
                                              ),
                                              SizedBox(width: lsize.maxWidth*0.45, child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Text(state.inspectionAreaItems![index].item!, style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(left:size.width*0.006, right: size.width*0.009),
                                                child: Image.asset('assets/images/qty.png', scale: size.height*0.0018,),
                                              ),
                                              SizedBox(width: lsize.maxWidth*0.15,child: Text(state.inspectionAreaItems![index].qty!.toString(), style: TextStyle(fontSize: size.height*0.018, fontWeight: FontWeight.bold),))
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

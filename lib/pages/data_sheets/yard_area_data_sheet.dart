
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/yard/yard_bloc.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class YardAreaDataSheet extends StatefulWidget {
  const YardAreaDataSheet({super.key});

  @override
  State<YardAreaDataSheet> createState() => _YardAreaDataSheetState();
}

class _YardAreaDataSheetState extends State<YardAreaDataSheet> {
    final jsIteropService = JsInteropService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Customs.DataSheet(
      context: context,
      size: size,
      title: 'Yard Area',
      children: [
        
          Gap(size.height * 0.02),
          Expanded(
            child: BlocBuilder<YardBloc, YardState>(
            buildWhen: (previous, current) => current.yardAreaStatus==YardAreaStatus.success,
            builder: (context, state) {
              bool isEnabled = state.yardAreaStatus != YardAreaStatus.success;
              // print("result count ${state.yardArea!.resultCount}");
               
              if(state.yardAreaStatus == YardAreaStatus.success){
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: 
              //     ExpansionPanelList(

              //       expansionCallback: (panelInde  x, isExpanded) {
              //         print("panelIndex $panelIndex");

              //       },
              //       children: 

              //         state.yardArea!.results!.map((e) {
              //           return ExpansionPanel(isExpanded: true, 
              //   canTapOnHeader: true,headerBuilder: (context, isExpanded) { 
              //   return Text("Header text"); 
              // },  body: Customs.MapInfo(size: size, keys: [
              //       'trailer_nbr',
              //       'to_location',
              //       'vendor_code',
              //       'po_nbr',
              //       'shipment_nbr'
              //     ], values: [
              //       isEnabled ? 'trailer_nbr' : e.trailerNbr!,
              //       isEnabled ? 'to_location' : e.toLocation!,
              //       isEnabled ? 'vendor_code' : e.vendorCode!,
              //       isEnabled ? 'po_nbr' : e.poNbr!,
              //       isEnabled ? 'shipment_nbr' : e.shipmentNbr!,
                    
                    
              //     ]));
              //         },).toList()

              //         ,)
                  
                  ListView.separated(
                      itemBuilder: (context, index) => Card(
                        child: Customs.MapInfo(size: size, keys: [
                              'Truck number',
                              'Vehicle location',
                              'Vendor code',
                              'PO number',
                              'Shipment number'
                            ], values: [
                              isEnabled ? 'Truck number' : state.yardArea!.results![index].truckNbr!,
                              isEnabled ? 'Vehicle location' : state.yardArea!.results![index].vehicleLocation!,
                              isEnabled ? 'Vendor code' : state.yardArea!.results![index].vendorCode!,
                              isEnabled ? 'PO number' : state.yardArea!.results![index].poNbr!,
                              isEnabled ? 'Shipment number' : state.yardArea!.results![index].shipmentNbr!,
                            ]),
                      ),
                      separatorBuilder: (context, index) => Gap(size.height * 0.025),
                       itemCount: isEnabled ? 8 : state.yardArea!.resultCount!
                      )
                      );
                      }
                  else{
                    return Center(child: SizedBox(
                      height: size.height*0.05,
                      width: size.width*0.02,
                      child: CircularProgressIndicator()));
                  }
            },
            ),
          )
      ]
    );
  
  }
}
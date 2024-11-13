
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
            builder: (context, state) {
              bool isEnabled = state.yardAreaStatus != YardAreaStatus.success;
             
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: 
                  ListView.separated(
                      itemBuilder: (context, index) => Card(
                        child: Customs.MapInfo(size: size, keys: [
                              'Truck number',
                              'Vehicle location',
                              'Vehicle entry time',
                              'Vendor code',
                              'PO number',
                              'Shipment number',
                              'Sequence number'
                            ], values: [
                              isEnabled ? 'Truck number' : state.yardArea!.data![index].truckNbr??"-",
                              isEnabled ? 'Vehicle location' : state.yardArea!.data![index].vehicleLocation??"-",
                              isEnabled ? 'Vehicle entry time' : state.yardArea!.data![index].vehicleEntryTime??"-",
                              isEnabled ? 'Vendor code' : state.yardArea!.data![index].vendorCode??"-",
                              isEnabled ? 'PO number' : state.yardArea!.data![index].poNbr??"-",
                              isEnabled ? 'Shipment number' : state.yardArea!.data![index].shipmentNbr??"-",
                              isEnabled ? 'Sequence number' : state.yardArea!.data![index].seqNbr??"-",
                            ]),
                      ),
                      separatorBuilder: (context, index) => Gap(size.height * 0.025),
                      itemCount: isEnabled? 8: state.yardArea!.data!.length
                      )
                      );
                 
            },
            ),
          )
      ]
    );
  
  }
}
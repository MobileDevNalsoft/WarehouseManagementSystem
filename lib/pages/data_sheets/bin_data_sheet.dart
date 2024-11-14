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
  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _storageBloc = context.read<StorageBloc>();
    _storageBloc.add(GetBinData(searchText:context.read<WarehouseInteractionBloc>().state.searchText ));
   
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
          return Skeletonizer(
            enabled: isEnabled,
            child: Column(
              children: [
               if(_warehouseInteractionBloc.state.searchText==null||_warehouseInteractionBloc.state.searchText=="") Text("RC${_warehouseInteractionBloc.state.dataFromJS!['bin'].toString().toUpperCase()}",style: const TextStyle(fontWeight: FontWeight.bold),),
                isEnabled?const Text("-"):
                state.storageBin!.data!.isEmpty?const Text("Empty bin"):
              SizedBox(
                height: size.height * 0.6,
                child: ListView.separated(
                  itemBuilder: (context,index) {
                    return Customs.MapInfo(size: size, 
                          keys: [
                            'LPN Number',
                            'Barcode',
                            'ASN',
                            'PO Number',
                            'Vendor',
                            'Item',
                            'Item Category',
                            'Quantity',
                            'Manufacturing Date',
                            'Expiry Date',
                            'Batch Number',
                            'Serial Number'
                          ], values: [
                             isEnabled ? 'LPN Number' : state.storageBin!.data![index].containerNbr??"NA",
                             isEnabled ? 'Barcode' : state.storageBin!.data![index].locationKey??"NA",
                             isEnabled ? 'ASN' : state.storageBin!.data![index].serialNbrKey??"NA",
                             isEnabled ? 'PO Number' : state.storageBin!.data![index].refPoNbr??"NA",
                             isEnabled ? 'Vendor' : state.storageBin!.data![index].vendor??"NA",
                             isEnabled ? 'Item' : state.storageBin!.data![index].itemKey??"NA",
                             isEnabled ? 'Item Category' : state.storageBin!.data![index].putawaytypeKey??"NA",
                             isEnabled ? 'Quantity' : state.storageBin!.data![index].currQty??"NA",
                             isEnabled ? 'Manufacturing Date' : state.storageBin!.data![index].manufactureDate??"NA",
                             isEnabled ? 'Expiry Date' : state.storageBin!.data![index].expiryDate??"NA",
                             isEnabled ? 'Batch Number' : state.storageBin!.data![index].batchNbrKey??"NA",
                             isEnabled ? 'Serial Number Key' : state.storageBin!.data![index].serialNbrKey??"NA",
                
                          ]);
                  },
                          separatorBuilder: (context, index) => Gap(size.height * 0.025),
                          itemCount: isEnabled ? 8 : state.storageBin!.data!.length,
                ),
              ),
                    Gap(size.height * 0.05),
                   
              ],
            ),
          );
        },
      ),
    ]);
  }
}

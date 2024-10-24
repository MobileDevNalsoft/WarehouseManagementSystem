import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/storage/storage_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class StorageAreaDataSheet extends StatefulWidget {
  const StorageAreaDataSheet({super.key});

  @override
  State<StorageAreaDataSheet> createState() => _StorageAreaDataSheetState();
}

class _StorageAreaDataSheetState extends State<StorageAreaDataSheet> {
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return  Customs.DataSheet(
      context: context,
      size: size,
      title: 'Storage Area',
      children: [
        
          Gap(size.height * 0.02),
          Expanded(
            child: BlocBuilder<StorageBloc, StorageState>(
            buildWhen: (previous, current) => current.storageAreaStatus==StorageAreaStatus.success,
            builder: (context, state) {
              bool isEnabled = state.storageAreaStatus != StorageAreaStatus.success;
              // print("result count ${state.StorageArea!.resultCount}");
               
              if(state.storageAreaStatus == StorageAreaStatus.success){
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: 
                 Customs.MapInfo(size: size, keys: [
                              'Asile',
                              'Type',
                              'Number of bins'
                              
                            ], values: [
                              isEnabled ? 'trailer_nbr' : state.storageArea!.results![0].aisle!,
                              isEnabled ? 'to_location' : state.storageArea!.results![0].locnSizeTypeId!.key!,
                              isEnabled ? 'to_location' : state.storageArea!.resultCount.toString(),
                              
                              
                              
                            ]),
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
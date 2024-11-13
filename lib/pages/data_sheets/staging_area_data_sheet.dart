import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/staging/staging_bloc.dart';
import 'package:warehouse_3d/bloc/staging/staging_event.dart';
import 'package:warehouse_3d/bloc/staging/staging_state.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class StagingAreaDataSheet extends StatefulWidget {
  const StagingAreaDataSheet({super.key});

  @override
  State<StagingAreaDataSheet> createState() => _StagingAreaDataSheetState();
}

class _StagingAreaDataSheetState extends State<StagingAreaDataSheet> {
   final ScrollController _controller = ScrollController();
   StagingBloc? _stagingBloc;

  @override
  void initState() {
    super.initState();
     _stagingBloc = context.read<StagingBloc>();

    if(_stagingBloc!.state.stagingStatus == StagingAreaStatus.initial){

       _stagingBloc!.add(const GetStagingData());
    }

    _controller.addListener(_scrollListener);

   
    // if (_warehouseInteractionBloc.state.getReceivingAreaDataState == GetReceivingAreaDataState.initial) {
    //   _warehouseInteractionBloc.add(GetReceivingAreaData(areaName: _warehouseInteractionBloc.state.dataFromJS!.values.first.toString()));
    // }
  }



  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      print("reached end of the screen");

        _stagingBloc!.state.pageNum = _stagingBloc!.state.pageNum! + 1;

        print("before api call in scroll");

       _stagingBloc!.add(const GetStagingData());


    
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Staging Area',
      children: [
        const Text(
            'Materials',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Gap(size.height * 0.02),
          BlocBuilder<StagingBloc, StagingState>(
            builder: (context, state) {
              bool isEnabled = state.stagingStatus != StagingAreaStatus.success;
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: SizedBox(
                    height: size.height * 0.6,
                    child: ListView.separated(
                      controller: _controller,
                        itemBuilder: (context, index) => Card(
                          child: Customs.MapInfo(size: size, keys: [
                                'Order Number',
                                'Customer Name',
                                'Item',
                                'Quantity'
                              ], values: [
                                isEnabled ? 'Order Number' : state.stagingList![index].orderNum!,
                                isEnabled ? 'Customer Name' : state.stagingList![index].custName!,
                                isEnabled ? 'Item' : state.stagingList![index].item!,
                                isEnabled ? 'Quantity' : state.stagingList![index].qty!.toString()
                              ]),
                        ),
                        separatorBuilder: (context, index) => Gap(size.height * 0.025),
                        itemCount: isEnabled ? 8 : state.stagingList!.length),
                  ));
            },
          )
      ]
    );
  }
}

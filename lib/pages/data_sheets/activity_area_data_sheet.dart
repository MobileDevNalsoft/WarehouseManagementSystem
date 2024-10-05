import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_inter.dart';
import 'package:warehouse_3d/pages/custom_widget.dart/customs.dart';

class ActivityAreaDataSheet extends StatefulWidget {
  const ActivityAreaDataSheet({super.key});

  @override
  State<ActivityAreaDataSheet> createState() => _ActivityAreaDataSheetState();
}

class _ActivityAreaDataSheetState extends State<ActivityAreaDataSheet> {
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    if (_warehouseInteractionBloc.state.getActivityAreaDataState ==
        GetActivityAreaDataState.initial) {
      _warehouseInteractionBloc.add(GetActivityAreaData(areaName: _warehouseInteractionBloc.state.dataFromJS!.values.first.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.SheetBody(
      size: size,
      child: Column(
        children: [
          Customs.SheetAppBar(size: size, title: 'Activity Area',
          ),
          Gap(size.height*0.02),
          const Text('Materials', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.center,),
          Gap(size.height*0.02),
          BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
            builder: (context, state) {
              bool isEnabled = state.getActivityAreaDataState != GetActivityAreaDataState.success;
              return Skeletonizer(
                enabled: isEnabled,
                enableSwitchAnimation: true,
                child: SizedBox(height: size.height*0.6, child: ListView.separated(itemBuilder: (context, index) => Customs.MapInfo(size: size, keys: ['Work Order Number', 'Work Order Type', 'Status', 'Quantity'], values: [isEnabled ? 'Work Order Number' : state.activityArea!.materials![index].workOrderNumber!,isEnabled ?  'Work Order Type'  : state.activityArea!.materials![index].workOrderType!,isEnabled ?  'Status' : state.activityArea!.materials![index].status!,isEnabled ?  'Quantity' : state.activityArea!.materials![index].quantity!.toString()]), separatorBuilder: (context, index) => Gap(size.height*0.025), itemCount: isEnabled ? 8 : state.activityArea!.materials!.length),)
                );
            },
          )
        ],
      ),
    );
  }
}

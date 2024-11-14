import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/activity_area/activity_area_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class ActivityAreaDataSheet extends StatefulWidget {
  const ActivityAreaDataSheet({super.key});

  @override
  State<ActivityAreaDataSheet> createState() => _ActivityAreaDataSheetState();
}

class _ActivityAreaDataSheetState extends State<ActivityAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late ActivityAreaBloc _activityBloc;

  @override
  void initState() {
    super.initState();

    _activityBloc = context.read<ActivityAreaBloc>();
     _activityBloc.add( GetActivityAreaData( searchText: context.read<WarehouseInteractionBloc>().state.searchText));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _activityBloc.state.pageNum = _activityBloc.state.pageNum! + 1;
      _activityBloc.add( GetActivityAreaData( searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Activity Area',
      children: [
        const Text(
            'Materials',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Gap(size.height * 0.02),
          BlocBuilder<ActivityAreaBloc, ActivityAreaState>(
            builder: (context, state) {
              bool isEnabled = state.getDataState != GetDataState.success;
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: SizedBox(
                    height: size.height * 0.6,
                    child: ListView.separated(
                        controller: _controller,
                        itemBuilder: (context, index) => index < state.activityAreaItems!.length
                                ? Customs.MapInfo(size: size, keys: [
                              'Work Order Number',
                              'Work Order Type',
                              'Status',
                              'Quantity'
                            ], values: [
                              isEnabled ? 'Work Order Number' : state.activityAreaItems![index].workOrderNum!,
                              isEnabled ? 'Work Order Type' : state.activityAreaItems![index].workOrderType!,
                              isEnabled ? 'Item' : state.activityAreaItems![index].item!,
                              isEnabled ? 'Quantity' : state.activityAreaItems![index].qty!.toString()
                            ]) : Skeletonizer(
                              child: Customs.MapInfo(size: size, keys: [
                                'Work Order Number',
                                'Work Order Type',
                                'Status',
                                'Quantity'
                              ], values: [
                                'Work Order Number',
                                'Work Order Type',
                                'Item',
                                'Quantity'
                              ]),
                            ),
                        separatorBuilder: (context, index) => Gap(size.height * 0.025),
                        itemCount: isEnabled ? 8 : state.activityAreaItems!.length + 1 > (state.pageNum!+1)*100 ? state.activityAreaItems!.length + 1 : state.activityAreaItems!.length),
                  ));
            },
          )
      ]
    );
  }
}

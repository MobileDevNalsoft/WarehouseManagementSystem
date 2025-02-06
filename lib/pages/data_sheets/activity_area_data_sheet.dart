import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/activity_area/activity_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/js_interop_service/js_inter.dart';
import 'package:wmssimulator/models/activity_area_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/two_level_dropdown.dart';

class ActivityAreaDataSheet extends StatefulWidget {
  const ActivityAreaDataSheet({super.key});

  @override
  State<ActivityAreaDataSheet> createState() => _ActivityAreaDataSheetState();
}

class _ActivityAreaDataSheetState extends State<ActivityAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late ActivityAreaBloc _activityBloc;
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  @override
  void initState() {
    super.initState();

    _activityBloc = context.read<ActivityAreaBloc>();
    _activityBloc.add(GetActivityAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        _activityBloc.state.activityAreaItems!.length + 1 > (_activityBloc.state.pageNum! + 1) * 100) {
      _activityBloc.state.pageNum = _activityBloc.state.pageNum! + 1;
      _activityBloc.add(GetActivityAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Activity Area', children: [
      BlocBuilder<ActivityAreaBloc, ActivityAreaState>(
        builder: (context, state) {
          bool isEnabled = state.getDataState != GetDataState.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (!isEnabled && state.activityAreaItems!.isEmpty)
                  ? Column(
                      children: [
                        Text(
                          _warehouseInteractionBloc.state.searchText != null && _warehouseInteractionBloc.state.searchText != ""
                              ? _warehouseInteractionBloc.state.searchText!
                              : "",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: lsize.maxWidth * 0.048),
                        ),
                        const Text("Data not found")
                      ],
                    )
                  : isEnabled
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            SizedBox(
                                height: size.height * 0.04,
                                child: Text(
                                  'Task Summary',
                                  style: TextStyle(color: Colors.white),
                                )),
                            Expanded(
                                flex: 1,
                                child: TwoLevelDropdown(
                                  l1StyleData: L1StyleData(
                                    height: 60,
                                    width: 400,
                                    color: Colors.white,
                                    dropDownColor: Colors.white,
                                    itemCount: state.activityTasks!.length,
                                    iconPath: 'assets/images/wo_type.png',
                                    title: (index) => state.activityTasks![index].taskType!.replaceAll('"', ''),
                                  ),
                                  l2StyleData: L2StyleData(
                                    height: lsize.maxHeight * 0.08,
                                    color: const Color.fromRGBO(43, 79, 122, 1),
                                    itemCount: (index) => state.activityTasks![index].taskIDs!.length,
                                    builder: (lsize, l1Index, l2Index) => Row(
                                      children: [
                                        Gap(lsize.maxWidth * 0.01),
                                        Text(
                                          state.activityTasks![l1Index].taskIDs![l2Index],
                                          style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            SizedBox(
                                height: size.height * 0.04,
                                child: Text(
                                  'Work Order',
                                  style: TextStyle(color: Colors.white),
                                )),
                            Expanded(
                              flex: 1,
                              child: TwoLevelDropdown(
                                l1StyleData: L1StyleData(
                                  height: 60,
                                  width: 400,
                                  color: Colors.white,
                                  dropDownColor: Colors.white,
                                  itemCount: state.activityAreaItems!.length,
                                  iconPath: 'assets/images/wo_type.png',
                                  title: (index) => state.activityAreaItems![index].workOrderType!,
                                ),
                                l2StyleData: L2StyleData(
                                  height: lsize.maxHeight * 0.13,
                                  color: const Color.fromRGBO(43, 79, 122, 1),
                                  itemCount: (index) => state.activityAreaItems![index].items!.length,
                                  builder: (lsize, l1Index, l2Index) => Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: lsize.maxWidth * 0.16,
                                              child: Text(
                                                'Item',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045, color: Colors.white),
                                              )),
                                          Gap(lsize.maxWidth * 0.01),
                                          Text(
                                            state.activityAreaItems![l1Index].items![l2Index].item!,
                                            style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: lsize.maxWidth * 0.16,
                                              child: Text(
                                                'OD',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045, color: Colors.white),
                                              )),
                                          Gap(lsize.maxWidth * 0.01),
                                          Text(
                                            state.activityAreaItems![l1Index].items![l2Index].od!,
                                            style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: lsize.maxWidth * 0.16,
                                              child: Text(
                                                'QTY',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045, color: Colors.white),
                                              )),
                                          Gap(lsize.maxWidth * 0.01),
                                          Text(
                                            state.activityAreaItems![l1Index].items![l2Index].qty!,
                                            style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
            }),
          );
        },
      )
    ]);
  }
}

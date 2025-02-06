import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/staging/staging_bloc.dart';
import 'package:wmssimulator/bloc/staging/staging_event.dart';
import 'package:wmssimulator/bloc/staging/staging_state.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/staging_area_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/two_level_dropdown.dart';

class StagingAreaDataSheet extends StatefulWidget {
  const StagingAreaDataSheet({super.key});

  @override
  State<StagingAreaDataSheet> createState() => _StagingAreaDataSheetState();
}

class _StagingAreaDataSheetState extends State<StagingAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  StagingBloc? _stagingBloc;
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();
    _stagingBloc = context.read<StagingBloc>();
    _stagingBloc!.add(GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    _controller.addListener(_scrollListener);
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        _stagingBloc!.state.stagingList!.length + 1 > (_stagingBloc!.state.pageNum! + 1) * 100) {
      _stagingBloc!.state.pageNum = _stagingBloc!.state.pageNum! + 1;
      _stagingBloc!.add(GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Staging Area', children: [
      BlocBuilder<StagingBloc, StagingState>(
        builder: (context, state) {
          bool isEnabled = state.stagingStatus != StagingAreaStatus.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (!isEnabled && state.stagingList!.isEmpty)
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
                      : TwoLevelDropdown(
                          l1StyleData: L1StyleData(
                            height: 60,
                            width: 400,
                            color: Colors.white,
                            dropDownColor: Colors.white,
                            itemCount: state.stagingList!.length,
                            iconPath: 'assets/images/businessman.png',
                            title: (index) => state.stagingList![index].customerName!,
                          ),
                          l2StyleData: L2StyleData(
                            height: lsize.maxHeight * 0.13,
                            color: const Color.fromRGBO(43, 79, 122, 1),
                            itemCount: (index) => state.stagingList![index].items!.length,
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
                                      state.stagingList![l1Index].items![l2Index].item!,
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
                                      state.stagingList![l1Index].items![l2Index].od!,
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
                                      state.stagingList![l1Index].items![l2Index].qty!,
                                      style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold, color: Colors.white),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
            }),
          );
        },
      )
    ]);
  }
}

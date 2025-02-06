import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/dock_area/dock_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/three_level_dropdown.dart';

class DockAreaDataSheet extends StatefulWidget {
  const DockAreaDataSheet({super.key});

  @override
  State<DockAreaDataSheet> createState() => _DockAreaDataSheetState();
}

class _DockAreaDataSheetState extends State<DockAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late DockAreaBloc _dockAreaBloc;

  late WarehouseInteractionBloc _warehouseInteractionBloc;
  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _dockAreaBloc = context.read<DockAreaBloc>();
    _dockAreaBloc.add(GetDockAreaData(
        searchText: context.read<WarehouseInteractionBloc>().state.searchText,
        searchArea: context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in') ? "DOCK_IN" : "DOCK_OUT"));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        _dockAreaBloc.state.dockAreaItems!.length + 1 > (_dockAreaBloc.state.pageNum! + 1) * 100) {
      _dockAreaBloc.state.pageNum = _dockAreaBloc.state.pageNum! + 1;
      _dockAreaBloc.add(GetDockAreaData(
          searchText: context.read<WarehouseInteractionBloc>().state.searchText,
          searchArea: context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in') ? "DOCK_IN" : "DOCK_OUT"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Dock IN', children: [
      BlocBuilder<DockAreaBloc, DockAreaState>(
        builder: (context, state) {
          bool isEnabled = state.getDataState != GetDataState.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (state.getDataState == GetDataState.success && state.dockAreaItems!.isEmpty)
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
                      : ThreeLevelDropdown(
                          l1StyleData: L1StyleData(
                            height: 60,
                            width: 400,
                            color: Colors.white,
                            dropDownColor: Colors.white,
                            itemCount: state.dockAreaItems!.length,
                            iconPath: 'assets/images/truck.png',
                            title: (index) => state.dockAreaItems![index].truckNum!,
                          ),
                          l2StyleData: L2StyleData(
                            height: 60,
                            color: const Color.fromRGBO(43, 79, 122, 1),
                            dropDownColor: const Color.fromRGBO(43, 79, 122, 1),
                            itemCount: (index) => state.dockAreaItems![index].vendors!.length,
                            iconPath: 'assets/images/businessman.png',
                            title: (l1Index, l2Index) => state.dockAreaItems![l1Index].vendors![l2Index].vendorName!,
                          ),
                          l3StyleData: L3StyleData(
                            height: lsize.maxHeight * 0.19,
                            color: const Color.fromRGBO(127, 161, 202, 1),
                            itemCount: (l1Index, l2Index) => state.dockAreaItems![l1Index].vendors![l2Index].items!.length,
                            builder: (lsize, l1Index, l2Index, l3Index) => Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width: lsize.maxWidth * 0.16,
                                        child: Text(
                                          'DNO',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                        )),
                                    Gap(lsize.maxWidth * 0.01),
                                    Text(
                                      state.dockAreaItems![l1Index].vendors![l2Index].items![l3Index].dockNbr!,
                                      style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: lsize.maxWidth * 0.16,
                                        child: Text(
                                          'ASN',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                        )),
                                    Gap(lsize.maxWidth * 0.01),
                                    Text(
                                      state.dockAreaItems![l1Index].vendors![l2Index].items![l3Index].asn!,
                                      style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: lsize.maxWidth * 0.16,
                                        child: Text(
                                          'PO',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                        )),
                                    Gap(lsize.maxWidth * 0.01),
                                    Text(
                                      state.dockAreaItems![l1Index].vendors![l2Index].items![l3Index].poNbr!,
                                      style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: lsize.maxWidth * 0.16,
                                            child: Text(
                                              'ITEM',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                            )),
                                        Gap(lsize.maxWidth * 0.01),
                                        Text(
                                          state.dockAreaItems![l1Index].vendors![l2Index].items![l3Index].itemKey!.toString(),
                                          style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: lsize.maxWidth * 0.16,
                                            child: Text(
                                              'QTY',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                            )),
                                        Gap(lsize.maxWidth * 0.01),
                                        Text(
                                          state.dockAreaItems![l1Index].vendors![l2Index].items![l3Index].qty!.toString(),
                                          style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      state.dockAreaItems![l1Index].vendors![l2Index].items![l3Index].checkinTS!,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.04),
                                    )
                                  ],
                                ),
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

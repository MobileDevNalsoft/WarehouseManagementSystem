import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wmssimulator/bloc/receiving/receiving_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_event.dart';
import 'package:wmssimulator/bloc/receiving/receiving_state.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/receiving_area_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/three_level_dropdown.dart';

class ReceivingAreaDataSheet extends StatefulWidget {
  const ReceivingAreaDataSheet({super.key});

  @override
  State<ReceivingAreaDataSheet> createState() => _ReceivingAreaDataSheetState();
}

class _ReceivingAreaDataSheetState extends State<ReceivingAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  ReceivingBloc? _receivingBloc;
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  @override
  void initState() {
    super.initState();
    _receivingBloc = context.read<ReceivingBloc>();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _receivingBloc!.add(GetReceivingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        _receivingBloc!.state.receiveList!.length + 1 > (_receivingBloc!.state.pageNum! + 1) * 100) {
      _receivingBloc!.state.pageNum = _receivingBloc!.state.pageNum! + 1;
      _receivingBloc!.add(GetReceivingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Receiving Area', children: [
      BlocBuilder<ReceivingBloc, ReceivingState>(
        builder: (context, state) {
          bool isEnabled = state.receivingStatus != ReceivingAreaStatus.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (!isEnabled && state.receiveList!.isEmpty)
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
                            itemCount: state.receiveList!.length,
                            iconPath: 'assets/images/businessman.png',
                            title: (index) => state.receiveList![index].vendorName!,
                          ),
                          l2StyleData: L2StyleData(
                            height: 60,
                            color: const Color.fromRGBO(43, 79, 122, 1),
                            dropDownColor: const Color.fromRGBO(43, 79, 122, 1),
                            itemCount: (index) => state.receiveList![index].shipments!.length,
                            iconPath: 'assets/images/shipment.png',
                            title: (l1Index, l2Index) => state.receiveList![l1Index].shipments![l2Index].shipmentNo!,
                          ),
                          l3StyleData: L3StyleData(
                            height: lsize.maxHeight * 0.125,
                            color: const Color.fromRGBO(127, 161, 202, 1),
                            itemCount: (l1Index, l2Index) => state.receiveList![l1Index].shipments![l2Index].items!.length,
                            builder: (lsize, l1Index, l2Index, l3Index) => Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                        width: lsize.maxWidth * 0.16,
                                        child: Text(
                                          'Item',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                        )),
                                    Gap(lsize.maxWidth * 0.01),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          state.receiveList![l1Index].shipments![l2Index].items![l3Index].item!,
                                          style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                        ),
                                      ),
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
                                      state.receiveList![l1Index].shipments![l2Index].items![l3Index].po!,
                                      style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
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
                                      state.receiveList![l1Index].shipments![l2Index].items![l3Index].qty!,
                                      style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
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

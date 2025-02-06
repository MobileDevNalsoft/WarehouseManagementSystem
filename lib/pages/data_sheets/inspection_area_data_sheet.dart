import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/receiving_area_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/three_level_dropdown.dart';

class InspectionAreaDataSheet extends StatefulWidget {
  const InspectionAreaDataSheet({super.key});

  @override
  State<InspectionAreaDataSheet> createState() => _InspectionAreaDataSheetState();
}

class _InspectionAreaDataSheetState extends State<InspectionAreaDataSheet> {
  late InspectionAreaBloc _inspectionAreaBloc;
  final ScrollController _controller = ScrollController();
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  @override
  void initState() {
    super.initState();

    _inspectionAreaBloc = context.read<InspectionAreaBloc>();

    _inspectionAreaBloc.add(GetInspectionAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent &&
        _inspectionAreaBloc.state.inspectionAreaItems!.length + 1 > (_inspectionAreaBloc.state.pageNum! + 1) * 100) {
      _inspectionAreaBloc.state.pageNum = _inspectionAreaBloc.state.pageNum! + 1;
      _inspectionAreaBloc.add(GetInspectionAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Inspection Area', children: [
      BlocBuilder<InspectionAreaBloc, InspectionAreaState>(
        builder: (context, state) {
          bool isEnabled = state.getDataState != GetDataState.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (!isEnabled && state.inspectionAreaItems!.isEmpty)
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
                            itemCount: state.inspectionAreaItems!.length,
                            iconPath: 'assets/images/businessman.png',
                            title: (index) => state.inspectionAreaItems![index].vendorName!,
                          ),
                          l2StyleData: L2StyleData(
                            height: 60,
                            color: const Color.fromRGBO(43, 79, 122, 1),
                            dropDownColor: const Color.fromRGBO(43, 79, 122, 1),
                            itemCount: (index) => state.inspectionAreaItems![index].shipments!.length,
                            iconPath: 'assets/images/shipment.png',
                            title: (l1Index, l2Index) => state.inspectionAreaItems![l1Index].shipments![l2Index].shipmentNo!,
                          ),
                          l3StyleData: L3StyleData(
                              height: lsize.maxHeight * 0.155,
                              color: const Color.fromRGBO(127, 161, 202, 1),
                              itemCount: (l1Index, l2Index) => state.inspectionAreaItems![l1Index].shipments![l2Index].items!.length,
                              builder: (lsize, l1Index, l2Index, l3Index) => Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: lsize.maxWidth * 0.18,
                                              child: Text(
                                                'Item',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                              )),
                                          Gap(lsize.maxWidth * 0.01),
                                          Text(
                                            state.inspectionAreaItems![l1Index].shipments![l2Index].items![l3Index].item!,
                                            style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: lsize.maxWidth * 0.18,
                                              child: Text(
                                                'PO',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                              )),
                                          Gap(lsize.maxWidth * 0.01),
                                          Expanded(
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    state.inspectionAreaItems![l1Index].shipments![l2Index].items![l3Index].po!,
                                                    style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                                  )))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: lsize.maxWidth * 0.18,
                                              child: Text(
                                                'IBLPN',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                              )),
                                          Gap(lsize.maxWidth * 0.01),
                                          Text(
                                            state.inspectionAreaItems![l1Index].shipments![l2Index].items![l3Index].containerNBR!,
                                            style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: lsize.maxWidth * 0.18,
                                              child: Text(
                                                'QTY',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: lsize.maxWidth * 0.045),
                                              )),
                                          Gap(lsize.maxWidth * 0.01),
                                          Text(
                                            state.inspectionAreaItems![l1Index].shipments![l2Index].items![l3Index].qty!,
                                            style: TextStyle(fontSize: lsize.maxWidth * 0.042, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                        );
            }),
          );
        },
      )
    ]);
  }
}

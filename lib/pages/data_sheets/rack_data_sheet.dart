import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/storage/storage_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class RackDataSheet extends StatefulWidget {
  RackDataSheet({super.key});

  @override
  State<RackDataSheet> createState() => _RackDataSheetState();
}

class _RackDataSheetState extends State<RackDataSheet> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  SuggestionsController suggestionsController = SuggestionsController();
  late TextEditingController typeAheadController;
  late FocusNode typeAheadFocusNode;

  String? selectedBin;

  final ScrollController _controller = ScrollController();
  late StorageBloc _storageBloc;
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();
    _storageBloc = context.read<StorageBloc>();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _storageBloc.add(AddStorageAreaData(selectedRack: _warehouseInteractionBloc.state.dataFromJS.values.first));
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _storageBloc.state.pageNum = _storageBloc.state.pageNum! + 1;
      _storageBloc.add(AddStorageAreaData(selectedRack: _warehouseInteractionBloc.state.dataFromJS.values.first));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Customs.DataSheet(context: context, size: size, title: 'Storage Area', children: [
      BlocBuilder<StorageBloc, StorageState>(
        builder: (context, state) {
          bool isEnabled = state.storageAreaStatus != StorageAreaStatus.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return Skeletonizer(
                enabled: isEnabled,
                enableSwitchAnimation: true,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: (state.storageAreaStatus == StorageAreaStatus.success && state.storageArea == null)
                        ? [
                            Text(
                              _warehouseInteractionBloc.state.searchText != null && _warehouseInteractionBloc.state.searchText != ""
                                  ? _warehouseInteractionBloc.state.searchText!
                                  : "",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: lsize.maxWidth * 0.048),
                            ),
                            const Text("Data not found")
                          ]
                        : [
                            Container(
                              height: lsize.maxHeight * 0.12,
                              width: lsize.maxWidth * 0.96,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(lsize.maxHeight * 0.01),
                              margin: EdgeInsets.only(top: lsize.maxWidth * 0.01),
                              child: LayoutBuilder(builder: (context, containerSize) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          isEnabled ? 'Rack XR' : 'Rack ${state.storageArea!.data!.first.aisle!}',
                                          style: TextStyle(
                                              fontSize: containerSize.maxWidth * 0.048, height: containerSize.maxHeight * 0.0016, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    // Gap(size.height * 0.01),
                                    Row(
                                      children: [
                                        Text(
                                          isEnabled ? 'TYPE FROZEN' : 'Type ${state.storageArea!.data!.first.locationCategory!}',
                                          style: TextStyle(
                                              fontSize: containerSize.maxWidth * 0.048, height: containerSize.maxHeight * 0.0016, fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Image.asset('assets/images/qty.png', height: containerSize.maxHeight * 0.2, width: containerSize.maxWidth * 0.2),
                                        Text(
                                          isEnabled ? '36' : state.storageArea!.data!.length.toString(),
                                          style: TextStyle(
                                              fontSize: containerSize.maxWidth * 0.048, height: containerSize.maxHeight * 0.0016, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                );
                              }),
                            )
                          ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    ]);
  }
}

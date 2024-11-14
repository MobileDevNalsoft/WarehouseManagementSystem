import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/storage/storage_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class RackDataSheet extends StatefulWidget {
  RackDataSheet({super.key, required this.objectNames});
  List objectNames;

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
    print('initState');
    _storageBloc = context.read<StorageBloc>();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    print('event triggered');
    _storageBloc.add(AddStorageAreaData(selectedRack: _warehouseInteractionBloc.state.dataFromJS.values.first));
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _storageBloc.state.pageNum = _storageBloc.state.pageNum! + 1;
      _storageBloc.add(AddStorageAreaData(selectedRack: _warehouseInteractionBloc.state.dataFromJS!.values.first));
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(112, 144, 185, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(size.height * 0.01),
                  margin: EdgeInsets.only(top: size.height * 0.01),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            isEnabled ? 'Rack XR' : 'Rack ${state.storageArea!.data!.first.aisle!}',
                            style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Gap(size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            isEnabled ? 'TYPE FROZEN' : 'Type ${state.storageArea!.data!.first.locationCategory!}',
                            style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: size.width * 0.008),
                            child: Image.asset(
                              'assets/images/qty.png',
                              scale: size.height * 0.0018,
                            ),
                          ),
                          Text(
                            isEnabled ? '36' : state.storageArea!.data!.length.toString(),
                            style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.bold),
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
      ),
      Gap(size.height * 0.02),
      SizedBox(
        height: size.height * 0.08,
        width: size.width * 0.1,
        child: TypeAheadField(
          suggestionsController: suggestionsController,
          builder: (context, textController, focusNode) {
            typeAheadController = textController;
            typeAheadFocusNode = focusNode;
            textController = textController;
            focusNode = focusNode;
            focusNode.addListener(() {
              if (!focusNode.hasFocus) {
                textController.clear();
              }
            });
            return LayoutBuilder(
              builder: (context, constraints) => Padding(
                  padding: EdgeInsets.only(left: constraints.maxWidth * 0.0138, top: constraints.maxHeight * (size.height > 700 ? 0.38 : 0.35)),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    onTap: () {},
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: focusNode.hasFocus ? 'Choose' : "Choose",
                        border: const OutlineInputBorder(),
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                        ),
                        suffixIcon: Transform(
                          transform: Matrix4.translationValues(0, -constraints.maxHeight * 0.25, 0),
                          child: const Icon(Icons.arrow_drop_down_rounded),
                        ),
                        suffixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 10)),
                    controller: textController,
                    focusNode: focusNode,
                  )),
            );
          },
          suggestionsCallback: (pattern) {
            return widget.objectNames;
          },
          itemBuilder: (context, suggestion) => Row(
            children: [
              SizedBox(
                height: size.height * (size.height > 700 ? 0.045 : 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: size.width * 0.4,
                      child: Text(
                        textAlign: TextAlign.justify,
                        suggestion.toString(),
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
              ),
            ],
          ),
          onSelected: (suggestion) {
            typeAheadController.clear();
            // provider.host = suggestion;
            typeAheadController.text = suggestion;
            suggestionsController.close();
            suggestionsController.refresh();
          },
          constraints: BoxConstraints(minWidth: size.width * 0.5, maxWidth: size.width * 0.6),
          hideOnSelect: false,
        ),
      ),
    ]);
  }
}

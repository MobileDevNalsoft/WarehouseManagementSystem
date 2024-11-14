import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/storage/storage_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StorageAreaDataSheet extends StatefulWidget {
  StorageAreaDataSheet({super.key});
  

  @override
  State<StorageAreaDataSheet> createState() => _StorageAreaDataSheetState();
}

class _StorageAreaDataSheetState extends State<StorageAreaDataSheet> {
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
    _storageBloc.add(AddStorageAislesData(searchText: _warehouseInteractionBloc.state.searchText??""));
     _warehouseInteractionBloc.state.selectedSearchArea = "Storage Area";
    // _controller.addListener(_scrollListener);
  }

  // void _scrollListener() async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     _storageBloc.state.pageNum = _storageBloc.state.pageNum! + 1;
  //     _storageBloc.add(AddStorageAislesData(searchText: _warehouseInteractionBloc.state.searchText??""));
  //   }
  // }

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
                child:
                 ListView.builder(
                    controller: _controller,
                    itemCount:state.storageAisles==null?4: state.storageAisles!.data!.length,
                   itemBuilder: (context,index) {
                     return Container(
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
                                isEnabled ? 'Rack XR' : 'Rack ${state.storageAisles!.data![index].aisle!}',
                                style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ],
                          ),
                          Gap(size.height * 0.01),
                          Row(
                            children: [
                              Text(
                                isEnabled ? 'Type Frozen' : '${state.storageAisles!.data![index].locationCategory!}',
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
                                isEnabled ? '36' : state.storageAisles!.data![index].barcode.toString(),
                                style: TextStyle(fontSize: size.height * 0.018, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                                     );
                   }
                 ),
              );
            }),
          );
        },
      ),
      Gap(size.height * 0.02),
   ]);
  }
}

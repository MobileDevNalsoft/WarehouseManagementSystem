import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/dock_area/dock_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';

class DockOutAreaDataSheet extends StatefulWidget {
  const DockOutAreaDataSheet({super.key});

  @override
  State<DockOutAreaDataSheet> createState() => _DockOutAreaDataSheetState();
}

class _DockOutAreaDataSheetState extends State<DockOutAreaDataSheet> {
  late DockAreaBloc _dockOutBloc;
  final ScrollController _controller = ScrollController();
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _dockOutBloc = context.read<DockAreaBloc>();
    _dockOutBloc.add(GetDockOutAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Customs.DataSheet(context: context, size: size, title: 'Dock Out', children: [
      BlocBuilder<DockAreaBloc, DockAreaState>(
        builder: (context, state) {
          bool isEnabled = state.getDataState != GetDataState.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: (state.getDataState == GetDataState.success && state.dockOutItems!.isEmpty)
                    ? Column(
                        children: [
                          Text(
                            _warehouseInteractionBloc.state.searchText != null && _warehouseInteractionBloc.state.searchText != ""
                                ? _warehouseInteractionBloc.state.searchText!
                                : "",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: lsize.maxWidth * 0.044),
                          ),
                          Text(
                            "Data not found",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    : ListView.builder(
                        controller: _controller,
                        itemBuilder: (context, index) => !isEnabled
                            ? Container(
                                height: lsize.maxHeight * 0.16,
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
                                          SizedBox(
                                            width: containerSize.maxWidth * 0.5,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.004),
                                                  child: Image.asset(
                                                    'assets/images/truck.png',
                                                    height: containerSize.maxHeight * 0.24,
                                                    width: containerSize.maxWidth * 0.14,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: containerSize.maxWidth * 0.24,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      state.dockOutItems![index].truckNbr!,
                                                      style: TextStyle(fontSize: containerSize.maxWidth * 0.038, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: containerSize.maxWidth * 0.5,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.004),
                                                  child: Image.asset('assets/images/businessman.png',
                                                      height: containerSize.maxHeight * 0.24, width: containerSize.maxWidth * 0.14),
                                                ),
                                                SizedBox(
                                                  width: containerSize.maxWidth * 0.32,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      state.dockOutItems![index].driver ?? "NA",
                                                      style: TextStyle(fontSize: containerSize.maxWidth * 0.038, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: containerSize.maxWidth * 0.64,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: containerSize.maxWidth * 0.05, right: containerSize.maxWidth * 0.032),
                                                  child: Text("LD", style: TextStyle(fontSize: containerSize.maxWidth * 0.05, fontWeight: FontWeight.w900)),
                                                ),
                                                Text(
                                                  state.dockOutItems![index].loadNbr!,
                                                  style: TextStyle(fontSize: containerSize.maxWidth * 0.038, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              )
                            : Container(
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
                                          Padding(
                                            padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                            child: Image.asset(
                                              'assets/images/truck.png',
                                              height: containerSize.maxHeight * 0.36,
                                              width: containerSize.maxWidth * 0.16,
                                            ),
                                          ),
                                          Skeletonizer(
                                              enableSwitchAnimation: true,
                                              child: Text(
                                                'TRUCK NUMBER',
                                                style: TextStyle(
                                                    fontSize: containerSize.maxWidth * 0.044,
                                                    height: containerSize.maxHeight * 0.0016,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: containerSize.maxWidth * 0.006, right: containerSize.maxWidth * 0.016),
                                            child: Image.asset(
                                              'assets/images/location.png',
                                              height: containerSize.maxHeight * 0.28,
                                              width: containerSize.maxWidth * 0.16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                              ),
                        itemCount: isEnabled ? 8 : state.dockOutItems!.length),
              );
            }),
          );
        },
      )
    ]);
  }
}

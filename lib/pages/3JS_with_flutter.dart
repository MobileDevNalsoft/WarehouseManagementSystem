import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/main.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../js_inter.dart';

class ThreeDTest extends StatefulWidget {
  const ThreeDTest({super.key});

  @override
  State<ThreeDTest> createState() => _ThreeDTestState();
}

class _ThreeDTestState extends State<ThreeDTest> {
  final jsIteropService = JsInteropService();
  late InAppWebViewController webViewController;
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  WebMessageChannel? webMessageChannel;
  WebMessagePort? port1;
  WebMessagePort? port2;

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          // color: Colors.black,
          child: Row(
        children: [
          SizedBox(
            width: context.watch<WarehouseInteractionBloc>().state.selectedBinID != 'null' ? size.width*0.8 : size.width,
            child: InAppWebView(
              initialFile: 'assets/web_code/model1.html',
              onConsoleMessage: (controller, consoleMessage) {
                try {
                  if(consoleMessage.messageLevel.toNativeValue() == 1){
                    _warehouseInteractionBloc.add(SelectedBinID(binID: consoleMessage.message));
                  }
                } catch (e) {
                  print("error $e   ");
                }
              },
              onWebViewCreated: (controller) {
                webViewController = controller;
  
                _warehouseInteractionBloc.add(GetRacksData());
              },
              onLoadStop: (controller, url) async {
                
              },
            ),
          ),
          if (context.watch<WarehouseInteractionBloc>().state.selectedBinID != 'null')
            BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
              builder: (context, state) {
                return Skeletonizer(
                  enabled: state.getWarehouseDataState == GetRacksDataState.loading,
                  child: Container(
                            width: size.width*0.2,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                // color: Colors.black45,
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 5,
                                      spreadRadius: 5)
                                ]),
                            child: Column(
                              children: [
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "boxId",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          context.read<WarehouseInteractionBloc>().add(SelectedObject(object: null));
                                        },
                                        icon: const Icon(
                                          Icons.cancel_rounded,
                                          // color: Colors.white,
                                        ))
                                  ],
                                ),
                                Container(
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Text("Category",style: TextStyle(fontSize: 18),),
                                      Text(
                                        "category",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                
                                const Gap(16),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Capacity",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54),
                                          ),
                                          Text("24",
                                              style: TextStyle(fontSize: 20))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        child: Column(
                                      children: [
                                        Text(
                                          "Quantity",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                        Text("24", style: TextStyle(fontSize: 20))
                                      ],
                                    ))
                                  ],
                                ),
                                const Gap(8),
                
                                // Gap(16),
                                // Align(alignment: Alignment.centerLeft,child: Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text("Capacity",style: TextStyle(fontSize: 18),),
                                // )),
                                const Gap(16),
                                Container(
                                  decoration: const BoxDecoration(
                                      // color: Colors.black12
                                      ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Items",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.4,
                                        child: ListView(
                                            scrollDirection: Axis.vertical,
                                            children: ([] as List)
                                                .map((element) => SizedBox(
                                                    height: size.height * 0.064,
                                                    child: Card(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16.0),
                                                          child: Text(
                                                              element["itemName"]
                                                                  .toString()),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      24.0),
                                                          child: Text(
                                                              element["quantity"]
                                                                  .toString()),
                                                        )
                                                      ],
                                                    ))))
                                                .toList()),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ));
              }
            )
        ],
      )),
    );
  }
}

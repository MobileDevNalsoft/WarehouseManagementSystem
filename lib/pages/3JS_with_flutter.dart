import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/main.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../js_inter.dart';
import '../models/rack_model.dart';

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
    _warehouseInteractionBloc.add(GetRacksData());
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
            width: context
                        .watch<WarehouseInteractionBloc>()
                        .state
                        .dataFromJS!
                        .keys
                        .first !=
                    'object'
                ? size.width * 0.8
                : size.width,
            child: InAppWebView(
              initialFile: 'assets/web_code/model1.html',
              onConsoleMessage: (controller, consoleMessage) {
                try {
                  if (consoleMessage.messageLevel.toNativeValue() == 1) {
                    print('console message ${consoleMessage.message}');
                    Map<String, dynamic> message =
                        jsonDecode(consoleMessage.message);
                    _warehouseInteractionBloc
                        .add(SelectedObject(dataFromJS: message));
                    if (message.keys.first == 'rack') {
                      _warehouseInteractionBloc
                          .add(SelectedRack(rackID: message['rack']));
                    } else if (message.keys.first == 'bin') {
                      
                      _warehouseInteractionBloc
                          .add(SelectedBin(binID: message['bin']));
                    } else if(message.keys.first == 'area') {
                      _warehouseInteractionBloc.add(SelectedArea(areaName: message['area']));
                    }
                  }
                } catch (e) {
                  print("error $e");
                }
              },
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) async {},
            ),
          ),
          if (context
                  .watch<WarehouseInteractionBloc>()
                  .state
                  .dataFromJS!
                  .keys
                  .first !=
              'object')
            BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
                buildWhen: (previous, current) =>
                    previous.getRacksDataState != current.getRacksDataState ||
                    previous.dataFromJS != current.dataFromJS,
                builder: (context, state) {
                  if (state.getRacksDataState == GetRacksDataState.success) {
                    print('selected bin in builder ${state.selectedBin}');
                    
                    print(
                        'json from js ${_warehouseInteractionBloc.state.dataFromJS}');
                  }
                  if (state.dataFromJS!.keys.first == 'rack') {
                    return Skeletonizer(
                        enabled: state.getRacksDataState ==
                            GetRacksDataState.loading,
                        child: Container(
                          width: size.width * 0.2,
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
                                  Text(
                                    'Storage Rack : ${state.dataFromJS!.values.first.toString().toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _warehouseInteractionBloc.add(
                                            SelectedObject(dataFromJS: const {
                                          "object": "null"
                                        }));
                                        jsIteropService.switchToMainCam();
                                      },
                                      icon: const Icon(
                                        Icons.cancel_rounded,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.selectedRack != null
                                        ? 'Category : ${state.selectedRack!.category!}'
                                        : 'Category : CHAMPAGNE',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  )
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
                  } else if (state.dataFromJS!.keys.first == 'bin') {
                    print(
                        'selected bin in builder ${state.selectedBin!.binID}');
                    return Skeletonizer(
                        enabled: state.getRacksDataState ==
                            GetRacksDataState.loading,
                        child: Container(
                          width: size.width * 0.2,
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
                                  Text(
                                    'Storage Bin : ${state.dataFromJS!.values.first.toString().toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _warehouseInteractionBloc.add(
                                            SelectedObject(dataFromJS: const {
                                          "object": "null"
                                        }));
                                        jsIteropService.switchToMainCam();
                                      },
                                      icon: const Icon(
                                        Icons.cancel_rounded,
                                      ))
                                ],
                              ),
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
                                          children: (state.selectedBin!.items!)
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
                                                        child: Text(element
                                                            .itemName
                                                            .toString()),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    24.0),
                                                        child: Text(element
                                                            .quantity
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
                  }else if(state.dataFromJS!['area'] == 'stagingArea'){
                    
                  }
                  return SizedBox();
                })
        ],
      )),
    );
  }
}

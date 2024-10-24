import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable/touchable.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/pages/data_sheets/activity_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/bin_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/inspection_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/rack_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/receiving_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/staging_area_data_sheet.dart';
import '../../js_interop_service/js_inter.dart';
import '../../navigations/navigator_service.dart';
import '../customs/hover_dropdown.dart';

class ThreeJsWebView extends StatefulWidget {
  const ThreeJsWebView({super.key});

  @override
  State<ThreeJsWebView> createState() => _ThreeJsWebViewState();
}

class _ThreeJsWebViewState extends State<ThreeJsWebView> with TickerProviderStateMixin {
  final jsIteropService = JsInteropService();
  late InAppWebViewController webViewController;
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  final SharedPreferences sharedPreferences = getIt();

  // for animation
  late AnimationController animationController;
  late Animation<double> widthAnimation;
  late Animation<double> positionAnimation;
  final StreamController<String?> _storageStreamController = StreamController<String?>();
  // late Stream<String> localStorageStream;
  late StreamSubscription<String> _subscription;

  // Service to handle navigation within the app
  final NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();

    animationController = AnimationController(duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 100), vsync: this);
    widthAnimation =
        Tween<double>(begin: 1, end: 0.82).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    positionAnimation =
        Tween<double>(begin: -350, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    // Listen for changes in the state
    _warehouseInteractionBloc.stream.listen((state) {
      if (state.dataFromJS!.keys.first != 'object') {
        animationController.forward(); // Start animation when data sheet is visible
      } else {
        animationController.reverse(); // Reverse when not visible
      }
    });
    _storageStreamController.onListen = () {
      print("messageFromJS");
    };
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Column(
                  children: [
            Container(
              height: size.height * 0.08,
              width: size.width,
              decoration: BoxDecoration(color: Colors.blue.shade900),
              child: Row(
                children: [
                  Gap(size.width * 0.006),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: false,
                      hint: const SizedBox(),
                      items: [
                        DropdownMenuItem<String>(
                            value: '0',
                            onTap: () {},
                            child: PointerInterceptor(
                              child: const Text(
                                'company 1',
                                style: TextStyle(color: Colors.black),
                              ),
                            )),
                        DropdownMenuItem<String>(
                            value: '1',
                            onTap: () {},
                            child: PointerInterceptor(
                              child: const Text(
                                'company 2',
                                style: TextStyle(color: Colors.black),
                              ),
                            ))
                      ],
                      value: '0',
                      onChanged: (String? value) {},
                      buttonStyleData: ButtonStyleData(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        height: size.height * (0.045),
                        width: size.width * 0.1,
                        padding: EdgeInsets.only(left: size.width * 0.008, right: size.width * 0.003),
                      ),
                      dropdownStyleData: DropdownStyleData(
                          width: size.width * (0.1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          offset: Offset(0, -size.height * 0.003)),
                      menuItemStyleData: MenuItemStyleData(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        selectedMenuItemBuilder: (context, child) {
                          return SizedBox(height: size.height * 0.03, child: child);
                        },
                      ),
                    ),
                  ),
                  Gap(size.width * 0.006),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: false,
                      hint: const SizedBox(),
                      items: [
                        DropdownMenuItem<String>(
                            value: '0',
                            onTap: () {},
                            child: PointerInterceptor(
                              child: const Text(
                                'warehouse 1',
                                style: TextStyle(color: Colors.black),
                              ),
                            )),
                        DropdownMenuItem<String>(
                            value: '1',
                            onTap: () {},
                            child: PointerInterceptor(
                              child: const Text(
                                'warehouse 2',
                                style: TextStyle(color: Colors.black),
                              ),
                            ))
                      ],
                      value: '0',
                      onChanged: (String? value) {},
                      buttonStyleData: ButtonStyleData(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        height: size.height * (0.045),
                        width: size.width * 0.1,
                        padding: EdgeInsets.only(left: size.width * 0.008, right: size.width * 0.003),
                      ),
                      dropdownStyleData: DropdownStyleData(
                          width: size.width * (0.1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          offset: Offset(0, -size.height * 0.003)),
                      menuItemStyleData: MenuItemStyleData(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        selectedMenuItemBuilder: (context, child) {
                          return SizedBox(height: size.height * 0.03, child: child);
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/nalsoft_logo.png',
                    scale: 5,
                    isAntiAlias: true,
                  ),
                  Gap(size.width * 0.05),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedBuilder(
                      animation: widthAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          height: size.height*0.92,
                          width: size.width * widthAnimation.value,
                          child: InAppWebView(
                            initialFile: 'assets/web_code/model.html',
                            onConsoleMessage: (controller, consoleMessage) {
                              try {
                                if (consoleMessage.messageLevel.toNativeValue() == 1) {
                                  print('console message ${consoleMessage.message}');
                                  Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                                  _warehouseInteractionBloc.add(SelectedObject(dataFromJS: message));
                                }
                              } catch (e) {
                                print("error $e");
                              }
                            },
                            onWebViewCreated: (controller) async {
                              _warehouseInteractionBloc.state.inAppWebViewController = controller;
                              // _warehouseInteractionBloc.add(ModelLoaded(isLoaded: true));// remove for loading indicator
            
                              Timer.periodic(
                                const Duration(milliseconds: 500),
                                (timer) async {
                                  _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItems().then((value) {
                                    value.forEach((e) {
                                      print(e);
                                    });
                                  });
                                  bool? isLoaded = await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItem(key: "isLoaded");
                                  if (isLoaded != null) {
                                    _warehouseInteractionBloc.add(ModelLoaded(isLoaded: true));
                                    _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.removeItem(key: "isLoaded");
                                  }
                                },
                              );
                            },
                            onLoadStop: (controller, url) async {},
                          ),
                        );
                      }),
                ),
                AnimatedBuilder(
                    animation: positionAnimation,
                    builder: (context, child) {
                      return Positioned(
                        right: positionAnimation.value,
                        child: getDataSheetFor(context.watch<WarehouseInteractionBloc>().state.dataFromJS!.keys.first,
                                context.watch<WarehouseInteractionBloc>().state.dataFromJS!.values.first.toString()) ??
                            const SizedBox(),
                      );
                    }),
                if (!context.watch<WarehouseInteractionBloc>().state.isModelLoaded)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                // Positioned(
                //   top: size.height*0.2,
                //   left: 0,
                // child: Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                //   ),
                //   height: size.height*0.4,
                //   width: size.width*0.1,
                //   child: Column(
                //     children: [
                //       TextButton(onPressed: (){}, child: Text("Inspection Area"))
                //     ],
                //   ),
                // ))
              ],
            ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: PointerInterceptor(child:                 HoverDropdown(),
                  ),
                )
          ],
        ));
  }

  Widget? getDataSheetFor(
    String objectName,
    String objectValue,
  ) {
    switch (objectName) {
      case 'rack':
        print('name $objectName value $objectValue');
        return const RackDataSheet();
      case 'bin':
        return const BinDataSheet();
      case 'area':
        switch (objectValue) {
          case 'stagingArea':
            return const StagingAreaDataSheet();
          case 'activityArea':
            return const ActivityAreaDataSheet();
          case 'receivingArea':
            return const ReceivingAreaDataSheet();
          case 'inspectionArea':
            return const InspectionAreaDataSheet();
        }
    }
  }
}

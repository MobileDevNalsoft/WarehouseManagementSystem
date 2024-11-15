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
import 'package:warehouse_3d/bloc/activity_area/activity_area_bloc.dart';
import 'package:warehouse_3d/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:warehouse_3d/bloc/storage/storage_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/pages/customs/searchbar_dropdown.dart';
import 'package:warehouse_3d/pages/data_sheets/activity_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/bin_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/inspection_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/rack_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/receiving_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/staging_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/storage_area_data_sheet.dart';
import 'package:warehouse_3d/pages/data_sheets/yard_area_data_sheet.dart';

import '../../bloc/warehouse/warehouse_interaction_bloc.dart';
import '../../js_interop_service/js_inter.dart';
import '../../navigations/navigator_service.dart';
import '../customs/hover_dropdown.dart';
import '../data_sheets/dock_area_data_sheet.dart';

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
  List objectNames = [];
  FocusNode focusNode = FocusNode();

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
    // just for debugging
    // animationController.forward();
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
              color:  Color.fromRGBO(68, 98, 136, 1),
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
                            alignment: Alignment.center,
                            child: PointerInterceptor(
                              child: Text(
                                'company 1',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontSize: size.height * 0.022),
                              ),
                            )),
                        DropdownMenuItem<String>(
                            value: '1',
                            onTap: () {},
                            alignment: Alignment.center,
                            child: PointerInterceptor(
                              child: Text(
                                'company 2',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontSize: size.height * 0.022),
                              ),
                            ))
                      ],
                      value: '1',
                      onChanged: (String? value) {},
                      buttonStyleData: ButtonStyleData(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        height: size.height * (0.045),
                        width: size.width * 0.1,
                        padding: EdgeInsets.only(left: size.width * 0.015, right: size.width * 0.003),
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
                          return Container(
                            height: size.height * 0.06,
                            decoration: BoxDecoration(color: Colors.grey.shade300),
                            child: child,
                          );
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
                            alignment: Alignment.center,
                            child: PointerInterceptor(
                              child: Text(
                                'warehouse 1',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontSize: size.height * 0.022),
                              ),
                            )),
                        DropdownMenuItem<String>(
                            value: '1',
                            onTap: () {},
                            alignment: Alignment.center,
                            child: PointerInterceptor(
                              child: Text(
                                'warehouse 2',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontSize: size.height * 0.022),
                              ),
                            ))
                      ],
                      value: '0',
                      onChanged: (String? value) {},
                      buttonStyleData: ButtonStyleData(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
                        height: size.height * (0.045),
                        width: size.width * 0.12,
                        padding: EdgeInsets.only(left: size.width * 0.015, right: size.width * 0.003),
                      ),
                      dropdownStyleData: DropdownStyleData(
                          width: size.width * (0.12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          offset: Offset(0, -size.height * 0.003)),
                      menuItemStyleData: MenuItemStyleData(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        selectedMenuItemBuilder: (context, child) {
                          return Container(
                            height: size.height * 0.06,
                            decoration: BoxDecoration(color: Colors.grey.shade300),
                            child: child,
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/nalsoft_logo.png',
                    scale: size.height * 0.004,
                    isAntiAlias: true,
                  ),
                  Gap(size.width * 0.06),
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
                          height: size.height * 0.92,
                          width: size.width * widthAnimation.value,
                          child: PointerInterceptor(
                            child: InkWell(
                              onTap: () {
                                focusNode.unfocus();
                                print("unfocused");
                              },
                              child:
                              InAppWebView(
                                initialFile: 'assets/web_code/model.html',
                                onConsoleMessage: (controller, consoleMessage) {
                                  try {
                                    if (consoleMessage.messageLevel.toNativeValue() == 1) {
                                      Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                                      _warehouseInteractionBloc.add(SelectedObject(dataFromJS: message));
                                    }
                                  } catch (e) {
                                    print("error $e");
                                  }
                                },
                                onWebViewCreated: (controller) async {
                                  _warehouseInteractionBloc.state.inAppWebViewController = controller;
                              
                                  Timer.periodic(
                                    const Duration(milliseconds: 500),
                                    (timer) async {
                                      // _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItems().then((value) {
                                      //   value.forEach((e) {
                                      //     print(e);
                                      //   });
                                      // });
                              
                                      // ignore: prefer_conditional_assignment
                                      if (objectNames.isEmpty) {
                                        objectNames =
                                            await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItem(key: "modelObjectNames") ?? [];
                                      }
                              
                                      bool? isLoaded =
                                          await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItem(key: "isLoaded");
                                      if (isLoaded != null) {
                                        _warehouseInteractionBloc.add(ModelLoaded(isLoaded: true));
                                        _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.removeItem(key: "isLoaded");
                                      }
                                    },
                                  );
                                },
                                onLoadStop: (controller, url) async {},
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                AnimatedBuilder(
                    animation: positionAnimation,
                    builder: (context, child) {
                      return Positioned(
                        right: positionAnimation.value,
                        child: 
                        getDataSheetFor(context.watch<WarehouseInteractionBloc>().state.dataFromJS!.keys.first,
                                context.watch<WarehouseInteractionBloc>().state.dataFromJS!.values.first.toString()) 
                                ??
                            const SizedBox(),
                      );
                    }),
                if (!context.watch<WarehouseInteractionBloc>().state.isModelLoaded)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ],
        ),
        Positioned(
          right: size.width*0.25,
          top: size.height*0.013,
          child: PointerInterceptor(child: SearchBarDropdown(size: size))),
        Positioned(
          right: 0,
          top: 0,
          child: PointerInterceptor(
            child: HoverDropdown(
              size: size,
            ),
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
        return RackDataSheet(objectNames: objectNames,);
      case 'bin':
        return   BinDataSheet();
      case 'area':
        switch (objectValue.toLowerCase()) {
          case 'stagingarea':
            
            return  StagingAreaDataSheet();
          case 'activityarea':
            return  ActivityAreaDataSheet();
          case 'receivingarea':
            return  ReceivingAreaDataSheet();
          case 'inspectionarea':
            return  InspectionAreaDataSheet();
          case 'dockarea-in':
            return  DockAreaDataSheet();
          case 'dockarea-out':
            return  DockAreaDataSheet();
          case 'yardarea':
            return YardAreaDataSheet();
          case 'storage':
            return StorageAreaDataSheet();
          default:
            return null;
        }
    }
    return null;
  }
}

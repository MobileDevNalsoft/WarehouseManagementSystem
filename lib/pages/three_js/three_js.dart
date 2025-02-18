import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/bloc/storage/storage_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/models/company_model.dart';
import 'package:wmssimulator/models/facility_model.dart';
import 'package:wmssimulator/pages/customs/alerts_slide.dart';
import 'package:wmssimulator/pages/customs/custom_progress_bar.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/facility_dropdown.dart';
import 'package:wmssimulator/pages/customs/searchbar_dropdown.dart';
import 'package:wmssimulator/pages/data_sheets/activity_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/bin_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/dock_area_out_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/inspection_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/lpn_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/rack_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/receiving_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/staging_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/yard_area_data_sheet.dart';

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
  // services
  final JsInteropService jsIteropService = JsInteropService();
  final NavigatorService navigator = getIt<NavigatorService>();
  final SharedPreferences sharedPreferences = getIt();

  // bloc declarations
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  // controllers
  late InAppWebViewController webViewController;
  TextEditingController textEditingController = TextEditingController();
  SuggestionsController suggestionsController = SuggestionsController();

  // focus nodes
  FocusNode focusNode = FocusNode();

  // variables
  List<String> accessTypes = getIt<SharedPreferences>().getStringList('access_types') ?? [];

  // side sheet animation utils
  late AnimationController animationController;
  late Animation<double> widthAnimation;
  late Animation<double> positionAnimation;

  // alerts slider animation utils
  late AnimationController sliderAnimationController;
  late Animation<double> sliderPositionAnimation;

  @override
  void initState() {
    super.initState();
    initControllers();
    initBloc();
    reRouteModel();

    window.onMessage.listen((event) {
      // Handle the message sent from JavaScript
      print('event data ${event.data}');
    });
  }

  void initControllers() {
    // data sheet animation controller
    animationController = AnimationController(duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 100), vsync: this);

    // width animation for three js webview
    widthAnimation =
        Tween<double>(begin: 1, end: 0.82).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));

    // position animation for data sheet
    positionAnimation =
        Tween<double>(begin: -350, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));

    // alerts slide animation controller
    sliderAnimationController =
        AnimationController(duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 100), vsync: this);

    // position animation for alerts slide
    sliderPositionAnimation = Tween<double>(begin: -450, end: 10)
        .animate(CurvedAnimation(parent: sliderAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
  }

  void initBloc() {
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();

    // always reset model loaded to false when we open app for first time or refresh page to get progress bar screen.
    _warehouseInteractionBloc.add(ModelLoaded(isLoaded: false));

    // preload all the areas overview data to send it to js code for model onhover dialog data.
    _warehouseInteractionBloc.add(GetAreasOverviewData(facilityID: 243));

    // gets user access details based on the logged username to restrict user from certain features in the application.
    _warehouseInteractionBloc.add(GetUsersData());

    // when we try to logout and relogin in same session we need to make intercepting false to get rid of invisible container user for closing hover dropdowns purpose
    // so that user can interact with model without interruption.
    _warehouseInteractionBloc.add(Intercepting(intercepting: false));

    // load the tasks at start of the application to get rid of delay between task selection and shortest path visibility.
    _warehouseInteractionBloc.add(GetTasks());

    // always dataFromJS should start with object : null so that it closes any opened sheets while we relogin in same session.
    _warehouseInteractionBloc.state.dataFromJS = {"object": "null"};

    // register for warehouse bloc stream of state changes to execute block of code base on state data.
    _warehouseInteractionBloc.stream.listen((state) {
      if (!state.dataFromJS.keys.contains('object') && state.dataFromJS.keys.first != 'percentComplete') {
        animationController.forward(); // Start animation when data sheet is visible
      } else {
        animationController.reverse(); // Reverse when not visible
      }
    });
    animationController.forward();
  }

  void reRouteModel() {
    // rerouting model based on user access types
    if (accessTypes.contains('Warehouse') && accessTypes.contains('Storage Area')) {
      getIt<JsInteropService>().changeFacility('{"companyID":1, "facilityID":1, "model":"storageArea"}');
    } else {
      getIt<JsInteropService>().changeFacility('{"companyID":1, "facilityID":1, "model":"warehouse"}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(builder: (context, state) {
          return Column(
            children: [
              Container(
                  height: size.height * 0.08,
                  width: size.width,
                  color: const Color.fromRGBO(68, 98, 136, 1),
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.only(left: constraints.maxWidth * 0.01),
                      child: Image.asset(
                        'assets/images/nalsoft_logo_white.png',
                        height: constraints.maxHeight * 0.8,
                        width: constraints.maxWidth * 0.12,
                        isAntiAlias: true,
                      ),
                    );
                  })),
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
                            child: accessTypes.contains('Warehous')
                                ? InAppWebView(
                                    initialFile: 'assets/web_code/model.html',
                                    onConsoleMessage: (controller, consoleMessage) {
                                      try {
                                        if (consoleMessage.messageLevel.toNativeValue() == 1) {
                                          Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                                          bool clearSearchText = true;
                                          if (message.containsKey("area")) {
                                            message["area"] = message["area"].toString().toLowerCase().replaceAll('-', '');
                                            clearSearchText =
                                                _warehouseInteractionBloc.state.selectedSearchArea.toLowerCase().replaceAll('-', '') != message["area"];
                                          } else if (message.containsKey("bin") && _warehouseInteractionBloc.state.dataFromJS.containsKey("bin")) {
                                            context.read<StorageBloc>().add(GetBinData(selectedBin: "RC${message['bin']}"));
                                          }
                                          _warehouseInteractionBloc.add(SelectedObject(dataFromJS: message, clearSearchText: clearSearchText));

                                          if (message.containsKey("percentComplete")) {
                                            if (message.containsKey("percentComplete")) {
                                              if (message['percentComplete'] == "100") {
                                                _warehouseInteractionBloc.add(ModelLoaded(isLoaded: true));
                                                _warehouseInteractionBloc.add(Rendering(isRendered: false));
                                                Timer.periodic(const Duration(milliseconds: 500), (timer) async {
                                                  bool? isLoaded = await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage
                                                      .getItem(key: "isLoaded");
                                                  if (isLoaded != null && isLoaded) {
                                                    _warehouseInteractionBloc.add(Rendering(isRendered: true));
                                                    _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.removeItem(key: "isLoaded");
                                                    _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage
                                                        .removeItem(key: "binsStatus");
                                                    context.read<StorageBloc>().add(GetBinsStatus());
                                                    timer.cancel();
                                                  }
                                                });
                                              }
                                            }
                                          }
                                          if (message.containsKey("openPathDialog") && message['openPathDialog'] == "true") {
                                            print("from openPathDialog");
                                            _warehouseInteractionBloc.add(GetTasks());

                                            Customs.AnimatedDialog(
                                              context: context,
                                              header: IconButton(
                                                  icon: const Icon(
                                                    Icons.local_activity_rounded,
                                                  ),
                                                  onPressed: () {}),
                                              onClose: () {
                                                controller.webStorage.localStorage.removeItem(key: "getShoretestPathForTask");
                                                getIt<JsInteropService>().getShoretestPathForTask([]);
                                              },
                                              content: [
                                                const Text("Please enter task Id"),
                                                StatefulBuilder(builder: (context, sts) {
                                                  return BlocConsumer<WarehouseInteractionBloc, WarehouseInteractionState>(listener: (context, state) {
                                                    print("from listener ${state.getBinsForTaskStatus}");
                                                  }, builder: (context, state) {
                                                    return TypeAheadField(
                                                      focusNode: focusNode,
                                                      controller: textEditingController,
                                                      suggestionsController: suggestionsController,
                                                      builder: (context, controller, focusNode) {
                                                        print("taks ${state.tasksForShoretestPath}");
                                                        // controller.clear();
                                                        return TextField(
                                                            controller: controller,
                                                            focusNode: focusNode,
                                                            // autofocus: true,
                                                            decoration: InputDecoration(contentPadding: EdgeInsets.only(left: size.width * 0.005)));
                                                      },
                                                      itemBuilder: (context, value) {
                                                        return ListTile(
                                                          title: Text(
                                                            value.toString(),
                                                            style: const TextStyle(fontSize: 14),
                                                          ),
                                                        );
                                                      },
                                                      suggestionsCallback: (pattern) {
                                                        return state.tasksForShoretestPath!.keys
                                                            .where((element) => element.toLowerCase().contains(pattern.toLowerCase()))
                                                            .toList();
                                                      },
                                                      onSelected: (value) {
                                                        state.selectedTaskId = value.toString();
                                                        textEditingController.text = value;
                                                        suggestionsController.refresh();
                                                        focusNode.unfocus();
                                                      },
                                                    );
                                                  });
                                                }),
                                                BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(builder: (context, state) {
                                                  return TextButton(
                                                      onPressed: () {
                                                        print(
                                                            "tasks ${state.tasksForShoretestPath}   ${state.tasksForShoretestPath![textEditingController.text.trim()]}");
                                                        if (textEditingController.text.trim().isNotEmpty &&
                                                            state.tasksForShoretestPath!.keys.contains(textEditingController.text.trim())) {
                                                          getIt<JsInteropService>().getShoretestPathForTask([]);
                                                          getIt<JsInteropService>()
                                                              .getShoretestPathForTask(state.tasksForShoretestPath![textEditingController.text.trim()]);
                                                          // _warehouseInteractionBloc.add(GetBinsForTask(taskNbr: textEditingController.text.trim()));
                                                        }
                                                        Navigator.pop(context);
                                                        // {
                                                        //   stfSetState(() {
                                                        //     _warehouseInteractionBloc.state.getBinsForTaskStatus = GetBinsForTaskStatus.loading;
                                                        //   });
                                                        // // _warehouseInteractionBloc.state.getBinsForTaskStatus = GetBinsForTaskStatus.loading;
                                                        // }
                                                      },
                                                      child: PointerInterceptor(child: const Text("Done")));
                                                })
                                              ],
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        print("error $e");
                                      }
                                    },
                                    onWebViewCreated: (controller) async {
                                      _warehouseInteractionBloc.state.inAppWebViewController = controller;
                                    },
                                  )
                                : Container(
                                    height: size.height * 0.92,
                                    width: size.width * widthAnimation.value,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(color: Color.fromRGBO(192, 208, 230, 1)),
                                    child: const Text(
                                      'Get Access for Digital Warehouse',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PointerInterceptor(
                      intercepting: state.intercepting!,
                      child: Container(
                        height: size.height * 0.92,
                        width: size.width,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                      animation: positionAnimation,
                      builder: (context, child) {
                        return Positioned(
                          right: positionAnimation.value,
                          child: PointerInterceptor(child: YardAreaDataSheet()
                              // getDataSheetFor(context.watch<WarehouseInteractionBloc>().state.dataFromJS.keys.first,
                              //         context.watch<WarehouseInteractionBloc>().state.dataFromJS.values.first.toString()) ??
                              //     const SizedBox(),
                              ),
                        );
                      }),
                  // if (!context.watch<WarehouseInteractionBloc>().state.isModelLoaded &&
                  //     accessTypes.contains('Warehouse') &&
                  //     !accessTypes.contains('Storage Area'))
                  //   Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: CustomProgressBar(
                  //           height: size.height * 0.92,
                  //           width: size.width,
                  //           progress: double.parse(context.watch<WarehouseInteractionBloc>().state.dataFromJS['percentComplete'] ?? '0') / 100)),
                  // if (!context.watch<WarehouseInteractionBloc>().state.isRendered && accessTypes.contains('Warehouse'))
                  //   Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: Container(
                  //       height: size.height * 0.92,
                  //       width: size.width * widthAnimation.value,
                  //       alignment: Alignment.center,
                  //       decoration: const BoxDecoration(color: Color.fromRGBO(192, 208, 230, 1)),
                  //       child: Lottie.asset('assets/lottie/rendering.json'),
                  //     ),
                  //   ),
                ],
              ),
            ],
          );
        }),
        if (accessTypes.contains('Warehouse') && !accessTypes.contains('Storage Area'))
          Positioned(
            left: size.width * 0.18,
            top: size.height * 0.015,
            child: BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
              builder: (context, state) {
                return PointerInterceptor(
                  child: FacilityDropdown<CompanyResults>(
                    dropDownType: 'Company',
                    buttonHeight: size.height * 0.052,
                    buttonWidth: size.width * 0.15,
                    dropDownItemHeight: size.height * 0.05,
                    dropDownWidth: size.width * 0.15,
                    dropDownItems: state.companyModel!.results!,
                    onChanged: (value) {
                      context.read<WarehouseInteractionBloc>().add(SelectedCompanyValue(comVal: (value as CompanyResults).name!.toString()));
                      // context.read<WarehouseInteractionBloc>().add(GetFaclityData(company_id: value.id!));
                    },
                    selectedValue: _warehouseInteractionBloc.state.selectedCompanyVal!,
                  ),
                );
              },
            ),
          ),
        if (accessTypes.contains('Warehouse') && !accessTypes.contains('Storage Area'))
          Positioned(
            left: size.width * 0.35,
            top: size.height * 0.015,
            child: BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
              builder: (context, state) {
                return PointerInterceptor(
                  child: FacilityDropdown<FacilityResults>(
                    dropDownType: 'Facility',
                    buttonHeight: size.height * 0.052,
                    buttonWidth: size.width * 0.15,
                    dropDownItemHeight: size.height * 0.05,
                    dropDownWidth: size.width * 0.15,
                    dropDownItems: state.facilityModel!.results!,
                    onChanged: (value) {
                      context.read<WarehouseInteractionBloc>().add(SelectedFacilityValue(facilityVal: (value as FacilityResults).name.toString()));
                      state.dataFromJS['percentComplete'] = "0";
                      _warehouseInteractionBloc.add(ModelLoaded(isLoaded: false));
                      getIt<JsInteropService>().changeFacility(
                          '{"companyID":${state.companyModel!.results!.where((e) => e.name == state.selectedCompanyVal).first.id}, "facilityID":${value.id}, "model":"warehouse"}');
                      _warehouseInteractionBloc.state.inAppWebViewController!.reload();
                    },
                    selectedValue: state.selectedFacilityVal,
                  ),
                );
              },
            ),
          ),
        Positioned(
          right: 0,
          top: 0,
          child: PointerInterceptor(
            child: HoverDropdown(
              size: size,
              accessTypes: accessTypes,
            ),
          ),
        ),
        Positioned(right: size.width * 0.08, top: size.height * 0.013, child: PointerInterceptor(child: SearchBarDropdown(size: size))),
        Positioned(
          right: size.width * 0.04,
          top: size.height * 0.023,
          child: StreamBuilder<int>(
              stream: _warehouseInteractionBloc.alertsCountStream,
              builder: (context, snapshot) {
                return InkWell(
                  onTap: () {
                    sliderAnimationController.forward();
                    _warehouseInteractionBloc.add(ResetAlertsCount());
                    // _warehouseInteractionBloc.state.inAppWebViewController!.evaluateJavascript(source: "testFromFlutter();");
                  },
                  child: SizedBox(
                    height: size.height * 0.08,
                    width: size.width * 0.02,
                    child: LayoutBuilder(builder: (context, lsize) {
                      return Stack(
                        children: [
                          Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: size.width * 0.015,
                          ),
                          if (snapshot.hasData && snapshot.data != 0)
                            Positioned(
                              right: lsize.maxWidth * 0.45,
                              child: Container(
                                height: size.height * 0.015,
                                width: size.width * 0.015,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                child: Text(
                                  '',
                                  // snapshot.data!.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 9),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                );
              }),
        ),
        AnimatedBuilder(
            animation: sliderPositionAnimation,
            builder: (context, child) {
              return Positioned(
                  top: size.height * 0.01,
                  right: sliderPositionAnimation.value,
                  child: PointerInterceptor(
                      child: AlertsSlide(
                    sliderAnimationController: sliderAnimationController,
                  )));
            }),
        // if(context.watch<WarehouseInteractionBloc>().state.getBinsForTaskStatus == GetBinsForTaskStatus.loading)
        //   Positioned(
        //     top: 0,
        //     left: 0,
        //     child: Center(
        //       child: Container(
        //           color: Colors.white10,
        //           width: size.width,
        //           height: size.height,
        //           child: Lottie.asset('assets/lottie/path.json', height: size.height * 0.2, width: size.width * 0.2)),
        //     ),
        //   ),
      ],
    ));
  }

  Widget? getDataSheetFor(
    String objectName,
    String objectValue,
  ) {
    print("getDataSheetFor $objectName $objectValue");
    switch (objectName.toLowerCase()) {
      case 'rack':
        return RackDataSheet();
      case 'bin':
        return const BinDataSheet();
      case 'lpn':
        return const LPNLifeCycleDataSheet();
      case 'area':
        switch (objectValue.toLowerCase().replaceAll("-", "")) {
          case 'stagingarea':
            return const StagingAreaDataSheet();
          case 'activityarea':
            return const ActivityAreaDataSheet();
          case 'receivingarea':
            return const ReceivingAreaDataSheet();
          case 'inspectionarea':
            return const InspectionAreaDataSheet();
          case 'dockareain':
            return const DockAreaDataSheet();
          case 'dockareaout':
            return const DockOutAreaDataSheet();
          case 'yardarea':
            return const YardAreaDataSheet();
          // case 'storagearea':
          //   return BinD();
          default:
            return null;
        }
      default:
        return null;
    }
  }
}

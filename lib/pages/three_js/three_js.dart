import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/bloc/storage/storage_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/models/company_model.dart';
import 'package:wmssimulator/models/facility_model.dart';
import 'package:wmssimulator/pages/customs/alerts_slide.dart';
import 'package:wmssimulator/pages/customs/custom_progress_bar.dart';
import 'package:wmssimulator/pages/customs/facility_dropdown.dart';
import 'package:wmssimulator/pages/customs/searchbar_dropdown.dart';
import 'package:wmssimulator/pages/data_sheets/activity_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/bin_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/inspection_area_data_sheet.dart';
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
  final jsIteropService = JsInteropService();
  late InAppWebViewController webViewController;
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  final SharedPreferences sharedPreferences = getIt();
  List objectNames = [];
  FocusNode focusNode = FocusNode();

  // for animation
  late AnimationController animationController;
  late AnimationController sliderAnimationController;
  late Animation<double> widthAnimation;
  late Animation<double> positionAnimation;
  late Animation<double> sliderPositionAnimation;
  final StreamController<String?> _storageStreamController = StreamController<String?>();
  // late Stream<String> localStorageStream;
  late StreamSubscription<String> _subscription;

  // Service to handle navigation within the app
  final NavigatorService navigator = getIt<NavigatorService>();

  List<String> accessTypes = getIt<SharedPreferences>().getStringList('access_types') ?? [];

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();

    _warehouseInteractionBloc.add(GetUsersData());

    animationController = AnimationController(duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 100), vsync: this);
    sliderAnimationController =
        AnimationController(duration: const Duration(milliseconds: 300), reverseDuration: const Duration(milliseconds: 100), vsync: this);
    widthAnimation =
        Tween<double>(begin: 1, end: 0.82).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    positionAnimation =
        Tween<double>(begin: -350, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    sliderPositionAnimation = Tween<double>(begin: -450, end: 10)
        .animate(CurvedAnimation(parent: sliderAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    // Listen for changes in the state
    _warehouseInteractionBloc.stream.listen((state) {
      if (state.dataFromJS.keys.first != 'object' && state.dataFromJS.keys.first != 'percentComplete') {
        animationController.forward(); // Start animation when data sheet is visible
      } else {
        animationController.reverse(); // Reverse when not visible
      }
    });
    _storageStreamController.onListen = () {
      print("messageFromJS");
    };
    _warehouseInteractionBloc.add(GetAreasOverviewData(facilityID: 243));
    getIt<JsInteropService>().changeFacility('{"companyID":1, "facilityID":1}');
    // _warehouseInteractionBloc.add(GetCompanyData());
    // just for debugging
    // animationController.forward();
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
                color: Color.fromRGBO(68, 98, 136, 1),
                child: Row(
                  children: [
                    const Spacer(),
                    Image.asset(
                      'assets/images/nalsoft_logo_white.png',
                      scale: size.height * 0.004,
                      isAntiAlias: true,
                    ),
                    Gap(size.width * 0.06),
                    InkWell(
                      onTap: () {
                        _warehouseInteractionBloc.add(GetAlerts());
                        sliderAnimationController.forward();
                      },
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                    ),
                    Gap(size.width * 0.007),
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
                            child: accessTypes.contains('3D Model')
                                ? InAppWebView(
                                    initialFile: 'assets/web_code/model.html',
                                    onConsoleMessage: (controller, consoleMessage) {
                                      try {
                                        if (consoleMessage.messageLevel.toNativeValue() == 1) {
                                          Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                                          bool clearSearchText = true;
                                          if (message.containsKey("area")) {
                                            print("console ${message["area"]}");
                                            message["area"] = message["area"].toString().toLowerCase().replaceAll('-', '');
                                            clearSearchText =
                                                _warehouseInteractionBloc.state.selectedSearchArea.toLowerCase().replaceAll('-', '') != message["area"];
                                          } else if (message.containsKey("bin") && _warehouseInteractionBloc.state.dataFromJS.containsKey("bin")) {
                                            context.read<StorageBloc>().add(GetBinData(selectedBin: "RC${message['bin']}"));
                                          }
                                          _warehouseInteractionBloc.add(SelectedObject(dataFromJS: message, clearSearchText: clearSearchText));

                                          if (message.containsKey("percentComplete")) {
                                            print(message['percentComplete']);
                                          }
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
                                          // ignore: prefer_conditional_assignment
                                          if (objectNames.isEmpty) {
                                            objectNames = await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage
                                                    .getItem(key: "modelObjectNames") ??
                                                [];
                                          }

                                          bool? isLoaded =
                                              await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItem(key: "isLoaded");
                                          print('loaded ${await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItem(key: "isLoaded")}');
                                          if ((isLoaded != false && isLoaded != null) && !state.isModelLoaded) {
                                            _warehouseInteractionBloc.add(ModelLoaded(isLoaded: true));
                                            print(state.isModelLoaded);
                                            timer.cancel();
                                          }
                                        },
                                      );
                                    },
                                    onLoadStop: (controller, url) async {},
                                  )
                                : Container(
                                    height: size.height * 0.92,
                                    width: size.width * widthAnimation.value,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: Color.fromRGBO(192, 208, 230, 1)),
                                    child: Text(
                                      'Get Access for Digital Warehouse',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          child: PointerInterceptor(
                            child: getDataSheetFor(context.watch<WarehouseInteractionBloc>().state.dataFromJS.keys.first,
                                    context.watch<WarehouseInteractionBloc>().state.dataFromJS.values.first.toString()) ??
                                const SizedBox(),
                          ),
                        );
                      }),
                  if (!context.watch<WarehouseInteractionBloc>().state.isModelLoaded && accessTypes.contains('3D Model'))
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomProgressBar(
                            height: size.height * 0.92,
                            width: size.width,
                            progress: double.parse(context.watch<WarehouseInteractionBloc>().state.dataFromJS['percentComplete'] ?? '0') / 100)),
                ],
              ),
            ],
          );
        }),
        Positioned(
          left: size.width * 0.01,
          top: size.height * 0.013,
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
                    context.read<WarehouseInteractionBloc>().add(GetFaclityData(company_id: value.id!));
                  },
                  selectedValue: _warehouseInteractionBloc.state.selectedCompanyVal!,
                ),
              );
            },
          ),
        ),
        Positioned(
          left: size.width * 0.18,
          top: size.height * 0.013,
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
                    getIt<JsInteropService>().changeFacility('{"companyID":${state.companyModel!.results!.where((e) => e.name == state.selectedCompanyVal).first.id}, "facilityID":${value.id}}');
                    _warehouseInteractionBloc.state.inAppWebViewController!.reload();
                  },
                  selectedValue: state.selectedFacilityVal,
                ),
              );
            },
          ),
        ),
        Positioned(right: size.width * 0.25, top: size.height * 0.013, child: PointerInterceptor(child: SearchBarDropdown(size: size))),
        Positioned(
          right: size.width * 0.02,
          top: 0,
          child: PointerInterceptor(
            child: HoverDropdown(
              size: size,
              accessTypes: accessTypes,
            ),
          ),
        ),
        AnimatedBuilder(
            animation: sliderPositionAnimation,
            builder: (context, child) {
              return Positioned(top: size.height * 0.01, right: sliderPositionAnimation.value, child: PointerInterceptor(child: AlertsSlide(sliderAnimationController: sliderAnimationController,)));
            }),
      ],
    ));
  }

  Widget? getDataSheetFor(
    String objectName,
    String objectValue,
  ) {
    print("getDataSheetFor ${objectName} ${objectValue}");
    switch (objectName.toLowerCase()) {
      case 'rack':
        return RackDataSheet(
          objectNames: objectNames,
        );
      case 'bin':
        return BinDataSheet();
      case 'area':
        switch (objectValue.toLowerCase().replaceAll("-", "")) {
          case 'stagingarea':
            return StagingAreaDataSheet();
          case 'activityarea':
            return ActivityAreaDataSheet();
          case 'receivingarea':
            return ReceivingAreaDataSheet();
          case 'inspectionarea':
            return InspectionAreaDataSheet();
          case 'dockareain':
            return DockAreaDataSheet();
          case 'dockareaout':
            return DockAreaDataSheet();
          case 'yardarea':
            return YardAreaDataSheet();
          // case 'storagearea':
          //   return BinD();
          default:
            return null;
        }
    }
    return null;
  }
}

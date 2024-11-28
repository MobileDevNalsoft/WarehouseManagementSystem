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
import 'package:wmssimulator/bloc/activity_area/activity_area_bloc.dart';
import 'package:wmssimulator/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:wmssimulator/bloc/storage/storage_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/models/company_model.dart';
import 'package:wmssimulator/models/facility_model.dart';
import 'package:wmssimulator/pages/customs/custom_progress_bar.dart';
import 'package:wmssimulator/pages/customs/searchbar_dropdown.dart';
import 'package:wmssimulator/pages/customs/company_dropdown.dart';
import 'package:wmssimulator/pages/customs/facility_dropdown.dart';
import 'package:wmssimulator/pages/data_sheets/activity_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/bin_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/dock_out_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/inspection_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/rack_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/receiving_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/staging_area_data_sheet.dart';
import 'package:wmssimulator/pages/data_sheets/storage_area_data_sheet.dart';
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
      if (state.dataFromJS.keys.first != 'object' && state.dataFromJS.keys.first != 'percentComplete') {
        animationController.forward(); // Start animation when data sheet is visible
      } else {
        animationController.reverse(); // Reverse when not visible
      }
    });
    _storageStreamController.onListen = () {
      print("messageFromJS");
    };
 
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
                                },
                                child:
                                 InAppWebView(
                                  initialFile: 'assets/web_code/model.html',
                                  onConsoleMessage: (controller, consoleMessage) {
                                    try {
                                      if (consoleMessage.messageLevel.toNativeValue() == 1) {
                                        Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                                        if (message.containsKey("area")) {
                                          print("console ${message["area"]}");
                                          message["area"] = message["area"].toString().toLowerCase().replaceAll('-', '');
                                        } else if (message.containsKey("bin") && _warehouseInteractionBloc.state.dataFromJS.containsKey("bin")) {
                                          context.read<StorageBloc>().add(GetBinData(selectedBin: "RC${message['bin']}"));
                                        }
                                        _warehouseInteractionBloc.add(SelectedObject(dataFromJS: message, clearSearchText: true));
                                        print(_warehouseInteractionBloc.state.dataFromJS);
                                        if(message.containsKey("percentComplete")){
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
                                        if (isLoaded != null ) {
                                          _warehouseInteractionBloc.add(ModelLoaded(isLoaded: true));
                                          _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.removeItem(key: "isLoaded");
                                                timer.cancel();
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
                                  context.watch<WarehouseInteractionBloc>().state.dataFromJS!.values.first.toString()) ??
                              const SizedBox(),
                        );
                      }),
                  if (!context.watch<WarehouseInteractionBloc>().state.isModelLoaded)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomProgressBar(
                        height: size.height*0.92,
                        width: size.width,
                        progress: double.parse(context.watch<WarehouseInteractionBloc>().state.dataFromJS['percentComplete']??'0')/100)),
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
              return 
              // state.getState != GetCompanyDataState.success
              //     ? SizedBox()
              //     :
                   PointerInterceptor(
                      child: CompanyDropdown(
                        buttonHeight: size.height * 0.052,
                        buttonWidth: size.width * 0.15,
                        dropDownHeight: size.height * 0.4,
                        dropDownWidth: size.width * 0.15,
                        dropDownItems: state.companyModel!.results!,
                        onChanged: (CompanyResults? value) {
                          context.read<WarehouseInteractionBloc>().add(SelectedCompanyValue(comVal: value!.name!.toString()));
                          // context.read<WarehouseInteractionBloc>().add(GetFaclityData(company_id: value.id!));
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
              return 
              // state.getState == GetCompanyDataState.success
              //     ? state.facilityDataState != GetFacilityDataState.success
              //         ? SizedBox()
              //         : 
                      PointerInterceptor(
                          child: FacilityDropdown(
                            buttonHeight: size.height * 0.052,
                            buttonWidth: size.width * 0.15,
                            dropDownHeight: size.height * 0.2,
                            dropDownWidth: size.width * 0.15,
                            dropDownItems: state.facilityModel!.results!,
                            onChanged: (FacilityResults? value) {
                              context.read<WarehouseInteractionBloc>().add(SelectedFacilityValue(facilityVal: value!.name.toString()));
                            },
                            selectedValue: state.selectedFacilityVal,
                          ),
                        );
                  // : SizedBox();
            },
          ),
        ),
       
        Positioned(right: size.width * 0.25, top: size.height * 0.013, child: PointerInterceptor(child: SearchBarDropdown(size: size))),
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
    switch (objectName.toLowerCase()) {
      case 'rack':
        return RackDataSheet(
          objectNames: objectNames,
        );
      case 'bin' || 'storagearea':
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
 
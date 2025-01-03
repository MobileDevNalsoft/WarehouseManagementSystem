import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
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
  SuggestionsController suggestionsController = SuggestionsController();

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
  late TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
   
    _warehouseInteractionBloc.add(GetUsersData());
 textEditingController = TextEditingController(text: _warehouseInteractionBloc.state.selectedTaskId??"");
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
      if (!state.dataFromJS.keys.contains('object') && state.dataFromJS.keys.first != 'percentComplete') {
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
                color: const Color.fromRGBO(68, 98, 136, 1),
                alignment: Alignment.centerLeft,
                child:LayoutBuilder(builder: (context,constraints){
                  return  Padding(
                  padding: EdgeInsets.only(left: constraints.maxWidth * 0.01),
                  child: Image.asset(
                    'assets/images/nalsoft_logo_white.png',
                    height: constraints.maxHeight*0.8,
                    width: constraints.maxWidth*0.12,
                    isAntiAlias: true,
                  ),
                );
                })
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
                            child: 
                            accessTypes.contains('3D Model')
                                ? 
                                InAppWebView(
                                    initialFile: 'assets/web_code/model.html',
                                    onConsoleMessage: (controller, consoleMessage) {
                                      try {
                                        if (consoleMessage.messageLevel.toNativeValue() == 1) {
                                          Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                                          bool clearSearchText = true;
                                          if (message.containsKey("area")) {
                                            print("console ${message["area"]}");
                                            message["area"] = message["area"].toString().toLowerCase().replaceAll('-', '');
                                            clearSearchText =_warehouseInteractionBloc.state.selectedSearchArea.toLowerCase().replaceAll('-', '') != message["area"];
                                             
                                          } else if (message.containsKey("bin") && _warehouseInteractionBloc.state.dataFromJS.containsKey("bin")) {
                                            context.read<StorageBloc>().add(GetBinData(selectedBin: "RC${message['bin']}"));
                                            
                                          }
                                         _warehouseInteractionBloc.add(SelectedObject(dataFromJS: message, clearSearchText: clearSearchText));

                                          if (message.containsKey("percentComplete")) {
                                           if (message.containsKey("percentComplete")) {
                                            if(message['percentComplete'] == "100"){
                                              _warehouseInteractionBloc.add(ModelLoaded(isLoaded: true));
                                              _warehouseInteractionBloc.add(Rendering(isRendered: false));
                                              Timer.periodic(const Duration(milliseconds: 500), (timer) async {
                                                bool? isLoaded = await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.getItem(key: "isLoaded");
                                                if (isLoaded != null && isLoaded) {
                                                  _warehouseInteractionBloc.add(Rendering(isRendered: true));
                                                  _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage.removeItem(key: "isLoaded");
                                                  timer.cancel();
                                                }
                                              });
                                            }
                                          }
 
                                          }
                                          if(message.containsKey("openPathDialog") && message['openPathDialog'] == "true"){
                                           
                                            Customs.AnimatedDialog(context: context, header:   IconButton(icon:Icon(Icons.local_activity_rounded,),onPressed: (){
                                                
                                            }),
                                            onClose: (){
                                              controller.webStorage.localStorage.removeItem(key: "getShoretestPathForTask");
                                                getIt<JsInteropService>().getShoretestPathForTask("");
                                            },
                                             content: [
                                              const Text("Please enter task Id"),
                                              TypeAheadField(
                                                
                                                controller: textEditingController,
                                                suggestionsController:  suggestionsController,
                                                itemBuilder: (context, value) {
                                                return ListTile(title: Text(value.toString()),);
                                              }, 
                                              
                                              suggestionsCallback: (pattern) {
                                                return  ["TSDEMODEMOWH100000001","TSDEMODEMOWH100000021","TSDEMODEMOWH100000041","TSDEMODEMOWH100000061","TSDEMODEMOWH100000081","TSDEMODEMOWH100000101","TSDEMODEMOWH100000121","TSDEMODEMOWH100000141","TSDEMODEMOWH100000161","TSDEMODUTY-PAID00000181","TSDEMODUTY-PAID00000182","TSPAID00000201","TSPAID00000221","TSPAID00000241","TSPAID00000261","TSPAID00000281","TSPAID00000301","TSPAID00000341","TSPAID00000342","TSPAID00000343","TSPAID00000345","TSPAID00000346","TSPAID00000347","TSPAID00000348","TSPAID00000350","TSPAID00000351","TSPAID00000352","TSPAID00000354","TSPAID00000355","TSPAID00000356","TSPAID00000357","TSPAID00000359","TSPAID00001377","TSPAID00001378","TSPAID00001379","TSPAID00001380","TSPAID00001381","TSPAID00001394","TSPAID00001414","TSPAID00001434","TSPAID00001454","TSPAID00001455","TSPAID00001456","TSPAID00001457","TSPAID00001477","TSPAID00001494","TSPAID00001514","TSPAID00001534","TSPAID00001554","TSPAID00001574","TSPAID00001594","TSPAID00001595","TSPAID00001614","TSPAID00001634","TSPAID00001655","TSPAID00001656","TSPAID00001676","TSPAID00001696","TSPAID00001716","TSPAID00001736","TSPAID00001756","TSPAID00000360","TSPAID00000361","TSPAID00000362","TSPAID00000363","TSPAID00000364","TSPAID00000365","TSPAID00000366","TSPAID00000367","TSPAID00000368","TSPAID00000369","TSPAID00000370","TSPAID00000371","TSPAID00000372","TSPAID00000373","TSPAID00000374","TSPAID00000375","TSPAID00000377","TSPAID00000378","TSPAID00000379","TSPAID00000514","TSPAID00000515","TSPAID00000536","TSPAID00000556","TSPAID00000557","TSPAID00000574","TSPAID00000614","TSPAID00000634","TSPAID00000654","TSPAID00000674","TSPAID00000714","TSPAID00000734","TSPAID00000754","TSPAID00000794","TSPAID00000814","TSPAID00000834","TSPAID00000854","TSPAID00000874","TSPAID00000875","TSPAID00000895","TSPAID00000896","TSPAID00000897","TSPAID00000898","TSPAID00000899","TSPAID00000919","TSPAID00000939","TSPAID00000959","TSPAID00000979","TSPAID00000999","TSPAID00001019","TSPAID00001039","TSPAID00001059","TSPAID00001079","TSPAID00001080","TSPAID00001099","TSPAID00001119","TSPAID00001139","TSPAID00001776","TSPAID00001159","TSPAID00001179","TSPAID00001796","TSPAID00001816","TSPAID00001836","TSPAID00001654","TSPAID00001959","TSPAID00001963","TSPAID00002047","TSPAID00002228","TSPAID00000321","TSPAID00000344","TSPAID00000349","TSPAID00000353","TSPAID00000358","TSPAID00000376","TSPAID00000516","TSPAID00000594","TSPAID00000694","TSPAID00000774","TSPAID00001199","TSPAID00001219","TSPAID00001239","TSPAID00001240","TSPAID00001241","TSPAID00001261","TSPAID00001281","TSPAID00001301","TSPAID00001321","TSPAID00001341","TSPAID00001374","TSPAID00001375","TSPAID00001376","TSPAID00002006","TSPAID00002008","TSPAID00002046","TSPAID00002209","TSPAID00002216","TSPAID00002221","TSPAID00002222","TSPAID00002223","TSPAID00002227","TSPAID00002248","TSPAID00002249","TSPAID00002269","TSPAID00002289","TSPAID00002309","TSPAID00002310","TSPAID00002330","TSPAID00002331","TSPAID00002351","TSPAID00002371","TSPAID00002391","TSPAID00002411","TSPAID00002431","TSPAID00002468","TSPAID00002488","TSPAID00001856","TSPAID00001857","TSPAID00001877","TSPAID00001897","TSPAID00001917","TSPAID00001937","TSPAID00001958","TSPAID00001971","TSPAID00001972","TSPAID00001974","TSPAID00001975","TSPAID00001980","TSPAID00001981","TSPAID00001984","TSPAID00001985","TSPAID00001987","TSPAID00001988","TSPAID00001989","TSPAID00001990","TSPAID00001991","TSPAID00001994","TSPAID00001995","TSPAID00001997","TSPAID00001999","TSPAID00002001","TSPAID00002003","TSPAID00002004","TSPAID00002005"].where((element) => element.contains(pattern)).toList();
                                              },
                                              onSelected: (value) {
                                                _warehouseInteractionBloc.add(UpdateTaskId(taskId: value.toString()));
                                                textEditingController.text=value;
                                                suggestionsController.refresh();
                                              },
                                              ),
                                              TextButton(onPressed: (){
                                                controller.webStorage.localStorage.removeItem(key: "getShoretestPathForTask");
                                                getIt<JsInteropService>().getShoretestPathForTask(_warehouseInteractionBloc.state.selectedTaskId??"");
                                                Navigator.pop(context);
                                              }, child: PointerInterceptor(child: const Text("Done")))
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
                                      Timer.periodic(
                                        const Duration(milliseconds: 500),
                                        (timer) async {
                                          // ignore: prefer_conditional_assignment
                                          if (objectNames.isEmpty) {
                                            objectNames = await _warehouseInteractionBloc.state.inAppWebViewController!.webStorage.localStorage
                                                    .getItem(key: "modelObjectNames") ??
                                                [];
                                          }
                                            timer.cancel();
                                        },
                                      );
                                    },
                                    onLoadStop: (controller, url) async {},
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
                        ),),
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
                  if (!context.watch<WarehouseInteractionBloc>().state.isRendered && accessTypes.contains('3D Model'))
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                                    height: size.height * 0.92,
                                    width: size.width * widthAnimation.value,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(color: Color.fromRGBO(192, 208, 230, 1)),
                                    child: Lottie.asset('assets/lottie/rendering.json'),
                                  ),),
                ],
              ),
           
            ],
          );
        }),
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
                    print("facility ${value.id}");
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
        Positioned(right: size.width * 0.08, top: size.height * 0.013, child: PointerInterceptor(child: SearchBarDropdown(size: size))),
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
        Positioned(
          right: size.width * 0.04,
          top: size.height * 0.023,
          child: InkWell(
                      onTap: () {
                        _warehouseInteractionBloc.add(GetAlerts());
                        sliderAnimationController.forward();
                      },
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: size.width * 0.015,
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
        return const BinDataSheet();
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
            return const DockAreaDataSheet();
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

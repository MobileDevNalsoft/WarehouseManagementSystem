import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/activity_area/activity_area_bloc.dart';
import 'package:warehouse_3d/bloc/dock_area/dock_area_bloc.dart';
import 'package:warehouse_3d/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_bloc.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_event.dart';
import 'package:warehouse_3d/bloc/staging/staging_bloc.dart';
import 'package:warehouse_3d/bloc/staging/staging_event.dart';
import 'package:warehouse_3d/bloc/storage/storage_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/yard/yard_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/pages/test_code/warehouse.dart';

class SearchBarDropdown extends StatefulWidget {
  SearchBarDropdown({super.key, required this.size});
  Size size;
  @override
  _SearchBarDropdownState createState() => _SearchBarDropdownState();
}

class _SearchBarDropdownState extends State<SearchBarDropdown> {
  bool isDropdownOpen = false;

  final List<String> dropdownItems = [
    'Storage Area',
    'Storage Bin',
    'Inspection Area',
    'Staging Area',
    'Activity Area',
    'Receiving Area',
    'Dock Area In',
    'Dock Area Out',
    'Yard Area'
  ];

  String? placeholderText;
  String? dropdownValue;
  
  double? height;
  double? bottomHeight;
  double turns = 1;
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  @override
  void initState() {
    super.initState();
    height = widget.size.height * 0.08;
    bottomHeight = widget.size.height * 0.06;
    placeholderText = 'Search';
    dropdownValue = "Area";
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      width: size.width * 0.26,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: bottomHeight,
            width: size.width * 0.1,
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.06),
              padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView(
                  shrinkWrap: true,
                  children: dropdownItems.map((item) {
                    return GestureDetector(
                      onTap: () {
                        print("item selected $item");
                      switch(item.replaceAll(" ","").toLowerCase()){
                          case "storagearea":
                                  getIt<JsInteropService>().switchToMainCam("storageArea");
                                   _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                          case "storagebin":
                                  getIt<JsInteropService>().switchToMainCam("storageArea");
                                  _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                          case "inspectionarea":
                                    getIt<JsInteropService>().switchToMainCam("inspectionArea");
                                     _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                            case "stagingarea":
                                  getIt<JsInteropService>().switchToMainCam("stagingArea");
                                   _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                            case "activityarea":
                                  getIt<JsInteropService>().switchToMainCam("activityArea");
                                   _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                            case "receivingarea":
                                  getIt<JsInteropService>().switchToMainCam("receivingArea");
                                   _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                            case "yardarea":
                                  getIt<JsInteropService>().switchToMainCam("yardArea");
                                   _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                            case "dockareain":
                                  getIt<JsInteropService>().switchToMainCam("dockArea-IN");
                                   _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                            case "dockareaout":
                                  getIt<JsInteropService>().switchToMainCam("dockArea-OUT");
                                   _warehouseInteractionBloc.state.searchText="";
                                  _warehouseInteractionBloc.state.searchController.text="";
                                  break;
                            default:
                              null;
                        }
                        // getIt<JsInteropService>().switchToMainCam(item.replaceAll(" ", ""));
                        if (item.toLowerCase().contains("bin")) {
                          _warehouseInteractionBloc.state.selectedSearchArea = "Bin";
                           _warehouseInteractionBloc.add(SelectedObject(dataFromJS: {"object": "bin"}));
                        } else {
                          // _warehouseInteractionBloc.state.selectedSearchArea = ;
                          _warehouseInteractionBloc.add(SelectedObject(dataFromJS: {"area": "${item.toLowerCase().replaceAll(" ", '')}"}));
                        }
                         
                         
                            
                          
                        setState(() {
                          // dropdownValue = item;
                          placeholderText = 'Search...';
                          height = height == size.height * 0.3
                              ? size.height * 0.08
                              : size.height * 0.3; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                          bottomHeight = bottomHeight == size.height * 0.3 ? size.height * 0.06 : size.height * 0.3;
                          turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: item == dropdownValue ? Color.fromRGBO(68, 98, 136, 1) : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: size.height * 0.022,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.055,
            width: size.width * 0.26,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.only(left: size.width * 0.002, right: size.width * 0.006, top: size.width * 0.002, bottom: size.width * 0.002),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print("dropdown");
                    // _warehouseInteractionBloc.state.selectedSearchArea = _warehouseInteractionBloc.state.selectedSearchArea.split("Area")[0].trim();
                    
                    setState(() {
                      height = height == size.height * 0.08
                          ? size.height * 0.3
                          : size.height * 0.08; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                      bottomHeight = bottomHeight == size.height * 0.06 ? size.height * 0.3 : size.height * 0.06;
                      turns = turns == 0.5 ? 1 : 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.01),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(68, 98, 136, 1), // Purple background
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.watch<WarehouseInteractionBloc>().state.selectedSearchArea.split("area").join(" "),
                          // context.watch<WarehouseInteractionBloc>().state.selectedSearchArea,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: size.height * 0.022),
                        ),
                        Gap(size.width * 0.005),
                        AnimatedRotation(
                          turns: turns,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: size.height * 0.025,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Search Box
                Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, -size.height * 0.005),
                          child: TextField(
                            controller: _warehouseInteractionBloc.state.searchController,
                            onSubmitted: (value) {
                              print("selected area ${_warehouseInteractionBloc.state.selectedSearchArea}");
                              print("dataFromJS ${_warehouseInteractionBloc.state.dataFromJS} ");
                              if (!_warehouseInteractionBloc.state.dataFromJS.containsKey("area") &&
                                  !_warehouseInteractionBloc.state.dataFromJS.containsKey("bin")) {
                                if (_warehouseInteractionBloc.state.selectedSearchArea.toLowerCase() == "bin") {
                                  _warehouseInteractionBloc.add(SelectedObject(dataFromJS: {"bin": ""}));
                                } else {
                                  _warehouseInteractionBloc.add(SelectedObject(dataFromJS: {"area": _warehouseInteractionBloc.state.selectedSearchArea.toLowerCase().replaceAll(' ', '').replaceAll('-', '')}));
                                }
                              } else {
                                print("else part ${_warehouseInteractionBloc.state.selectedSearchArea}");
                                switch (_warehouseInteractionBloc.state.selectedSearchArea.toLowerCase().replaceAll(' ', '').replaceAll('-', '')) {
                                  case 'stagingarea':
                                    context.read<StagingBloc>().state.pageNum = 0;
                                    context.read<StagingBloc>().add(GetStagingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
                                    break;
                                  case 'activityarea':
                                    context.read<ActivityAreaBloc>().state.pageNum = 0;
                                    context
                                        .read<ActivityAreaBloc>()
                                        .add(GetActivityAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
                                    break;
                                  case 'receivingarea':
                                    context.read<ReceivingBloc>().state.pageNum = 0;
                                    context.read<ReceivingBloc>().add(GetReceivingData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
                                    break;
                                  case 'inspectionarea':
                                    context.read<InspectionAreaBloc>().state.pageNum = 0;
                                    context
                                        .read<InspectionAreaBloc>()
                                        .add(GetInspectionAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
                                    break;
                                  case 'dockareain':
                                    context.read<DockAreaBloc>().state.pageNum = 0;

                                    context
                                        .read<DockAreaBloc>()
                                        .add(GetDockAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText, searchArea: "DOCK_IN"));
                                    break;
                                  case 'dockareaout':
                                    context.read<DockAreaBloc>().state.pageNum = 0;

                                    context
                                        .read<DockAreaBloc>()
                                        .add(GetDockAreaData(searchText: context.read<WarehouseInteractionBloc>().state.searchText, searchArea: "DOCK_OUT"));
                                    break;
                                  case 'yardarea':
                                    context.read<YardBloc>().state.pageNum = 0;
                                    context.read<YardBloc>().add(GetYardData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
                                  case 'storagearea':
                                    if (context.read<WarehouseInteractionBloc>().state.searchText != null &&
                                        context.read<WarehouseInteractionBloc>().state.searchText != "") {
                                      context.read<StorageBloc>().state.pageNum = 0;
                                      context
                                          .read<StorageBloc>()
                                          .add(AddStorageAislesData(searchText: context.read<WarehouseInteractionBloc>().state.searchText ?? ""));
                                    }
                                    break;
                                  case 'bin':
                                    context.read<StorageBloc>().state.pageNum = 0;
                                    context.read<StorageBloc>().add(GetBinData(searchText: context.read<WarehouseInteractionBloc>().state.searchText ?? ""));

                                  default:
                                    return null;
                                }
                              }
                            },
                            onChanged: (value) {
                              if (value.trim() == "") {
                                _warehouseInteractionBloc.state.searchText = null;
                                switch (_warehouseInteractionBloc.state.selectedSearchArea.toLowerCase()) {
                                  case 'stagingarea':
                                    context.read<StagingBloc>().state.pageNum = 0;
                                    context.read<StagingBloc>().add(GetStagingData());
                                    break;
                                  case 'activityarea':
                                    context.read<ActivityAreaBloc>().state.pageNum = 0;
                                    context.read<ActivityAreaBloc>().add(GetActivityAreaData());
                                    break;
                                  case 'receivingarea':
                                    context.read<ReceivingBloc>().state.pageNum = 0;
                                    context.read<ReceivingBloc>().add(GetReceivingData());
                                    break;
                                  case 'inspectionarea':
                                    context.read<InspectionAreaBloc>().add(GetInspectionAreaData());
                                    context.read<InspectionAreaBloc>().add(GetInspectionAreaData());
                                    break;
                                  case 'dockarea-in':
                                    context.read<DockAreaBloc>().state.pageNum = 0;

                                    context.read<DockAreaBloc>().add(GetDockAreaData());

                                  case 'dockarea-out':
                                    context.read<DockAreaBloc>().state.pageNum = 0;

                                    context.read<DockAreaBloc>().add(GetDockAreaData());
                                  case 'yardarea':
                                    context.read<YardBloc>().state.pageNum = 0;
                                    context.read<YardBloc>().add(GetYardData(searchText: context.read<WarehouseInteractionBloc>().state.searchText));
                                    break;
                                  default:
                                    return null;
                                }
                              } else {
                                _warehouseInteractionBloc.state.searchText = value.trim();
                              }
                            },
                            textAlignVertical: TextAlignVertical.center,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: placeholderText,
                              contentPadding: EdgeInsets.only(left: size.width * 0.008, top: size.height * 0.012),
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                color: Colors.black54, // Purple
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                            ),
                            cursorHeight: size.height * 0.03,
                            style: TextStyle(
                              color: Color.fromRGBO(68, 98, 136, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Color.fromRGBO(68, 98, 136, 1),
                        size: size.height * 0.035,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

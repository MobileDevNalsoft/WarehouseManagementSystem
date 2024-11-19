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
import 'package:warehouse_3d/models/facility_model.dart';
import 'package:warehouse_3d/pages/test_code/warehouse.dart';

class FacilityDropdown extends StatefulWidget {
  FacilityDropdown({super.key, required this.size, required this.dropDownItems, required this.onChanged, this.selectedValue});
  Size size;
  List<Results> dropDownItems;
  String? selectedValue;
  void Function(Results?)? onChanged;
  
  @override
  _FacilityDropdownState createState() => _FacilityDropdownState();
}

class _FacilityDropdownState extends State<FacilityDropdown> {
  bool isDropdownOpen = false;


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
      width: size.width * 0.12,
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
                  children: widget.dropDownItems.map((item) {
                    return GestureDetector(
                      onTap: () {
                            
                        widget.onChanged!(item);
                        setState(() {
                          // dropdownValue = item;
                          print('set state');
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
                          item.name!,
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
            child: GestureDetector(
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
                    SizedBox(
                      width: size.width*0.05,
                      child: Text(
                        widget.selectedValue!,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: size.height * 0.022, overflow: TextOverflow.ellipsis),
                      ),
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
          )
        ],
      ),
    );
  }
}

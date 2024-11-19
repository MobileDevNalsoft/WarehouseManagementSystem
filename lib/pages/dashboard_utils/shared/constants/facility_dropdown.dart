import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/models/company_model.dart';
import 'package:warehouse_3d/models/facility_model.dart';

class FacilityDropdown extends StatefulWidget {
  FacilityDropdown({super.key, required this.buttonHeight, required this.buttonWidth, required this.dropDownHeight, required this.dropDownWidth, required this.dropDownItems, required this.onChanged, this.selectedValue, this.listItemTextColor});
  double buttonHeight;
  double buttonWidth;
  double dropDownHeight;
  double dropDownWidth;
  Color? listItemTextColor;
  List<FacilityResults> dropDownItems;
  String? selectedValue;
  void Function(FacilityResults?)? onChanged;
  
  @override
  _FacilityDropdownState createState() => _FacilityDropdownState();
}

class _FacilityDropdownState extends State<FacilityDropdown> {
  double? height;
  double? bottomHeight;
  double turns = 1;
  @override
  void initState() {
    super.initState();
    height = widget.buttonHeight;
    bottomHeight = widget.buttonHeight*0.08;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      width: widget.dropDownWidth,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: bottomHeight,
            width: widget.dropDownWidth,
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
                          height = height == widget.dropDownHeight
                              ? widget.buttonHeight
                              : widget.dropDownHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                          bottomHeight = bottomHeight == widget.dropDownHeight ? widget.buttonHeight*0.08 : widget.dropDownHeight;
                          turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.name!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: widget.listItemTextColor ?? Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: widget.buttonHeight * 0.5,
                            overflow: TextOverflow.ellipsis
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
            height: widget.buttonHeight,
            width: widget.buttonWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(size.height*0.003),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  height = height == widget.buttonHeight
                      ? widget.dropDownHeight
                      : widget.buttonHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                  bottomHeight = bottomHeight == widget.buttonHeight*0.08 ? widget.dropDownHeight : widget.buttonHeight*0.08;
                  turns = turns == 0.5 ? 1 : 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.01),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(68, 98, 136, 1), // Purple background
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: widget.buttonWidth*0.72,
                      child: Text(
                        widget.selectedValue!,
                        overflow: TextOverflow.ellipsis,
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
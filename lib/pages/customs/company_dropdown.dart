import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/company_model.dart';

class CompanyDropdown extends StatefulWidget {
  CompanyDropdown({super.key, required this.buttonHeight, required this.buttonWidth, required this.dropDownHeight, required this.dropDownWidth, required this.dropDownItems, required this.onChanged, this.selectedValue, this.listItemTextColor});
  double buttonHeight;
  double buttonWidth;
  double dropDownHeight;
  double dropDownWidth;
  Color? listItemTextColor;
  List<CompanyResults> dropDownItems;
  String? selectedValue;
  void Function(CompanyResults?)? onChanged;
  
  @override
  _CompanyDropdownState createState() => _CompanyDropdownState();
}

class _CompanyDropdownState extends State<CompanyDropdown> {
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
                            fontSize: widget.buttonHeight * 0.4,
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
              child: Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                     padding: EdgeInsets.symmetric(horizontal: size.width * 0.008, vertical: size.height * 0.01),
                    decoration:  BoxDecoration(
                      color: Color.fromRGBO(68, 98, 136, 1), // Purple background
                      borderRadius: BorderRadius.circular(50),
                    ),
                    //  padding:  EdgeInsets.only(left:widget.buttonWidth*0.02,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Company",style: TextStyle(fontSize:widget.buttonWidth*0.064,color: Colors.white,),),
                          AnimatedRotation(
                          turns: turns,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: size.height * 0.025 ,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(widget.buttonWidth*0.04),
                      
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: size.width * 0.006, vertical: size.height * 0.01),
                    // decoration: BoxDecoration(
                    //   color: Colors.transparent, // Purple background
                    //   borderRadius: BorderRadius.circular(50),
                    // ),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: widget.buttonWidth*0.4,
                      child: Text(
                        widget.selectedValue!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: size.height * 0.018, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class FacilityDropdown<T> extends StatefulWidget {
    FacilityDropdown({super.key,this.dropDownType = 'Type', required this.buttonHeight, required this.buttonWidth, required this.dropDownItemHeight, required this.dropDownWidth, required this.dropDownItems, required this.onChanged, this.selectedValue, this.listItemTextColor});
  String dropDownType;
  double buttonHeight;
  double buttonWidth;
  double dropDownItemHeight;
  double dropDownWidth;
  Color? listItemTextColor;
  List<T> dropDownItems;
  String? selectedValue;
  void Function(dynamic)? onChanged;
  
  @override
  // ignore: library_private_types_in_public_api
  _FacilityDropdownState createState() => _FacilityDropdownState();
}

class _FacilityDropdownState extends State<FacilityDropdown> {
  double? height;
  double? dropDownHeight;
  double turns = 1;
  @override
  void initState() {
    super.initState();
    height = widget.buttonHeight;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    dropDownHeight = widget.dropDownItems.length*(widget.dropDownItemHeight + size.height*0.01) + size.height * 0.01;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      width: widget.dropDownWidth,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: height,
            width: widget.dropDownWidth,
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: widget.buttonHeight+5),
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width*0.005),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: ListView(
                    shrinkWrap: true,
                    children: widget.dropDownItems.map((item) {
                      return GestureDetector(
                        onTap: () {
                          widget.onChanged!(item);
                          setState(() {
                            height = height == dropDownHeight! + (widget.buttonHeight + 5)
                                ? widget.buttonHeight
                                : dropDownHeight! + (widget.buttonHeight + 5);
                            turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                          });
                        },
                        child: Container(
                          height: widget.dropDownItemHeight,
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.01),
                          margin: EdgeInsets.only(bottom: size.height*0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 203, 214, 229),
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
          ),
          Container(
            alignment: Alignment.center,
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
                      ? dropDownHeight! + (widget.buttonHeight + 5)
                      : widget.buttonHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                  turns = turns == 0.5 ? 1 : 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                });
              },
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Container(
                   padding: EdgeInsets.symmetric(horizontal: size.width * 0.008, vertical: size.height * 0.01),
                  decoration:  BoxDecoration(
                    color: const Color.fromRGBO(68, 98, 136, 1), // Purple background
                    borderRadius: BorderRadius.circular(50),
                  ),
                  //  padding:  EdgeInsets.only(left:widget.buttonWidth*0.02,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.dropDownType,style: TextStyle(fontSize:widget.buttonWidth*0.064,color: Colors.white,),),
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
                  Expanded(
                    child: Text(
                      widget.selectedValue!,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: size.height * 0.018, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Gap(widget.buttonWidth*0.04),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

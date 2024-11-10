import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchBarDropdown extends StatefulWidget {
  SearchBarDropdown({required this.size});
  Size size;
  @override
  _SearchBarDropdownState createState() => _SearchBarDropdownState();
}

class _SearchBarDropdownState extends State<SearchBarDropdown> {
  bool isDropdownOpen = false;

  final List<String> dropdownItems = ['Storage Area', 'Inspection Area', 'Staging Area', 'Activity Area', 'Receiving Area', 'Dock Area IN', 'Dock Area OUT'];

  String? placeholderText;
  String? dropdownValue;

  double? height;
  double? bottomHeight;
  double turns = 1;

  @override
  void initState() {
    super.initState();
    height = widget.size.height * 0.08;
    bottomHeight = widget.size.height * 0.06;
    placeholderText = 'Search in ${dropdownItems[0]}...';
    dropdownValue = dropdownItems[0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: height,
      width: size.width * 0.26,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: bottomHeight,
            width: size.width * 0.1,
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.06),
              padding: EdgeInsets.symmetric(vertical: size.height*0.015),
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
                        setState(() {
                          dropdownValue = item;
                          placeholderText = 'Search in $item...';
                          height = height == size.height * 0.3
                              ? size.height * 0.08
                              : size.height * 0.3; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                          bottomHeight = bottomHeight == size.height * 0.3 ? size.height * 0.06 : size.height * 0.3;
                          turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: size.height*0.01, horizontal: size.width*0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: item == dropdownValue ? Colors.blue.shade900 : Colors.black,
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
                      color: Colors.blue.shade900, // Purple background
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dropdownValue!,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: size.height * 0.022),
                        ),
                        Gap(size.width*0.005),
                        AnimatedRotation(
                          turns: turns,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: size.height*0.025,
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
                          offset: Offset(0, -size.height*0.005),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: placeholderText,
                              contentPadding: EdgeInsets.only(left: size.width*0.008),
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                color: Colors.blue.shade900.withOpacity(0.8), // Purple
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                            ),
                            cursorHeight: size.height*0.03,
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.blue.shade900,
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

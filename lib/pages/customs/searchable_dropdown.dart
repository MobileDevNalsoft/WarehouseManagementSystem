import 'package:flutter/material.dart';

class SearchBarDropdown extends StatefulWidget {
  SearchBarDropdown({required this.size, required this.focusNode});
  Size size;
  FocusNode focusNode;
  @override
  _SearchBarDropdownState createState() => _SearchBarDropdownState();
}

class _SearchBarDropdownState extends State<SearchBarDropdown> {
  bool isDropdownOpen = false;

  final List<String> dropdownItems = [
    'Storage Area',
    'Inspection Area',
    'Staging Area',
    'Activity Area',
    'Receiving Area',
  ];

  String? placeholderText;
  String? dropdownValue;

  double? height;
  double? bottomHeight;
  double turns = 1;

  @override
  void initState() {
    super.initState();
    height = widget.size.height*0.08;
    bottomHeight = widget.size.height*0.06;
    placeholderText = 'Search in ${dropdownItems[0]}...';
    dropdownValue = dropdownItems[0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(duration: Duration(milliseconds: 200),
    height: height,
      width: size.width * 0.22,
    child: Stack(
      children: [
        AnimatedContainer(duration: Duration(milliseconds: 200),
        height: bottomHeight,
        width: size.width*0.08,
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.only(top: size.height*0.06),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
                              placeholderText =
                                  'Search in $item...';
                              height = height == size.height*0.2 ? size.height*0.08 : size.height*0.2; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                        bottomHeight = bottomHeight == size.height*0.2 ? size.height*0.06 : size.height*0.2;
                        turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: item == dropdownValue
                                    ? Colors.blue.shade900
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
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
          height: size.height*0.055,
          width: size.width*0.22,
          decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.only(left: size.width*0.002, right: size.width*0.006),
           child: Row(
             children: [
               GestureDetector(
                    onTap: () {
                      setState(() {
                        height = height == size.height*0.08 ? size.height*0.2 : size.height*0.08; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                        bottomHeight = bottomHeight == size.height*0.06 ? size.height*0.2 : size.height*0.06;
                        turns = turns == 0.5 ? 1 : 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900, // Purple background
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dropdownValue!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            isDropdownOpen
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Search Box
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: widget.focusNode,
                        decoration: InputDecoration(
                          hintText: placeholderText,
                          
                          hintStyle: TextStyle(
                            color: Colors.blue.shade900, // Purple
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.blue.shade900,
                      size: 24,
                    ),
                  ],
                ),
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
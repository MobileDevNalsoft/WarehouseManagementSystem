import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ExpandableListView extends StatefulWidget {
  ExpandableListView({super.key, this.height = 100, this.width = 300, required this.data, this.controller});
  
  final double height;
  final double width;
  final List<Map<String, dynamic>> data;
  final ScrollController? controller;

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  final List<String> dropdownItems = [
    'Storage Area',
    'Inspection Area',
    'Staging Area',
    'Activity Area',
    'Receiving Area',
    'Dock Area IN',
    'Dock Area OUT'
  ];

  List<double> heights = [];
  List<double> bottomHeights = [];
  List<double> turns = []; // List to track rotation state for each item
  String? placeholderText;
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    // Initialize heights and turns for each item
    heights = List<double>.filled(widget.data[0].length, widget.height);
    bottomHeights = List<double>.filled(widget.data[0].length, widget.height * 0.06);
    turns = List<double>.filled(widget.data[0].length, 1); // Initialize rotation states
    placeholderText = 'Search in ${dropdownItems[0]}...';
    dropdownValue = dropdownItems[0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ListView.builder(
        controller: widget.controller,
        itemCount: widget.data[0].length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: heights[index],
            width: size.width * 0.26,
            child: LayoutBuilder(
              builder: (context, layout) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: bottomHeights[index],
                      width: size.width * 0.26,
                      color: Colors.transparent,
                      child: Container(
                        margin: EdgeInsets.only(top: layout.maxHeight*0.4),
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(191, 209, 231, 1),
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
                                    // // Toggle height for the specific index
                                    // heights[index] = heights[index] == size.height * 0.3
                                    //     ? widget.height
                                    //     : size.height * 0.3;
                                    // bottomHeights[index] = bottomHeights[index] == size.height * 0.3
                                    //     ? widget.height*0.06
                                    //     : size.height * 0.3;
                                    // turns[index] = turns[index] == 0.5 ? 1 : 0.5; // Adjust rotation if needed
                                  });
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.01),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    widget.data.where((e) => e.entries.first.key == widget.data[index].keys.toList()[index]).first.values.first,
                                    style: TextStyle(
                                      color:
                                          item == dropdownValue ? Color.fromRGBO(68, 98, 136, 1) : Colors.black,
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle height for the specific index when header is tapped
                          heights[index] = heights[index] == widget.height ? size.height * 0.3 : widget.height;
                          bottomHeights[index] = bottomHeights[index] == (widget.height * 0.06)
                              ? size.height * 0.3
                              : widget.height * 0.06;
                    
                          // Toggle rotation for the specific index
                          turns[index] = turns[index] == 1 ? 0.5 : 1; // Adjust rotation if needed
                        });
                      },
                      child: Container(
                        height: widget.height,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01, vertical: size.height * 0.01),
                            margin: EdgeInsets.only(top: size.height*0.01),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(68, 98, 136, 1), // Background color
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/truck.png', scale: size.height * 0.0015, color: Colors.black,),
                            Text(
                              widget.data[0].keys.toList()[index],
                              style:
                                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: size.height * 0.022),
                            ),
                            MaxGap(size.width),
                            AnimatedRotation(
                              turns: turns[index], // Use individual turn values for each index
                              duration: const Duration(milliseconds: 200),
                              child:
                                  Icon(Icons.keyboard_arrow_down_rounded, size: size.height * 0.025, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/entry_point.dart';

class HoverDropdown extends StatefulWidget {
  HoverDropdown({super.key, required this.size});
  Size size;

  @override
  State<HoverDropdown> createState() => _HoverDropdownState();
}

class _HoverDropdownState extends State<HoverDropdown> {

  double? height;
  double? bottomHeight;
  double turns = 1;
  
  @override
  void initState() {
    super.initState();
    height = widget.size.height*0.08;
    bottomHeight = widget.size.height*0.07;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: height,
      width: size.width * 0.12,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: bottomHeight,
            width: size.width * 0.12,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Gap(size.height * 0.08),
                  PointerInterceptor(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              height = height == size.height*0.2 ? size.height*0.08 : size.height*0.2; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == size.height*0.2 ? size.height*0.07 : size.height*0.2;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EntryPoint(),));
                          },
                          child: ForHover(text: "Dashboard"))),
                  PointerInterceptor(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              height = height == size.height*0.2 ? size.height*0.08 : size.height*0.2; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == size.height*0.2 ? size.height*0.07 : size.height*0.2;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                            launch('https://tg1.wms.ocs.oraclecloud.com/emg_test/index/',isNewTab: true);
                          },
                          child: ForHover(text: "WMS Cloud"))),
                ],
              ),
            ),
          ),
          // Container that holds the main profiles section
          Padding(
            padding: EdgeInsets.all(size.width * 0.008),
            child: InkWell(
              onTap: () {
                setState(() {
                  height = height == size.height*0.08 ? size.height*0.2 : size.height*0.08; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                  bottomHeight = bottomHeight == size.height*0.07 ? size.height*0.2 : size.height*0.07;
                  turns = turns == 0.5 ? 1 : 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/profile.png',
                    scale: widget.size.height*0.012,
                  ),
                  Gap(size.width * 0.003),
                  AnimatedRotation(
                    turns: turns,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Colors.white,
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
  Future<void> launch(String url, {bool isNewTab = true}) async {
    // await launchUrl(
    //   Uri.parse(url),
    //   webOnlyWindowName: isNewTab ? '_blank' : '_self',
    // );
  }
}

// Widget that holds hover animation for the text and its background
class ForHover extends StatefulWidget {
  final String text;
  const ForHover({super.key, required this.text});

  @override
  State<ForHover> createState() => _ForHoverState();
}

class _ForHoverState extends State<ForHover> {
  Color? hoverColor = Colors.white;
  Color? textColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (event) {
        // change color on hover
        setState(() {
          hoverColor = Colors.blue.shade900;
          textColor = Colors.white;
        });
      },
      // Revert color when not hovering
      onExit: (event) {
        setState(() {
          hoverColor = Colors.white;
          textColor = Colors.black;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: size.height*0.06,
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: size.width*0.01),
        color: hoverColor,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

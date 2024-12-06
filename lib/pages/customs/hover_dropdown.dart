import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/entry_point.dart';
 import 'dart:html' as html;

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
  final UrlNavigator urlNavigator = UrlNavigator();

  @override
  void initState() {
    super.initState();
    height = widget.size.height*0.08;
    bottomHeight = widget.size.height*0.08;
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
                              height = height == size.height*0.27 ? size.height*0.08 : size.height*0.27; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == size.height*0.27 ? size.height*0.08 : size.height*0.27;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                            
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EntryPoint(),));
                          },
                          child: ForHover(text: "Dashboard"))),
                  PointerInterceptor(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              height = height == size.height*0.27 ? size.height*0.08 : size.height*0.27; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == size.height*0.27 ? size.height*0.08 : size.height*0.27;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                             urlNavigator.launchOrFocusUrl('https://tg1.wms.ocs.oraclecloud.com/emg_test/index/');
                          },
                          child: ForHover(text: "WMS Cloud"))),
                  PointerInterceptor(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              height = height == size.height*0.27 ? size.height*0.08 : size.height*0.27; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == size.height*0.27 ? size.height*0.08 : size.height*0.27;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                            Customs.UsersDialog(context: context);
                          },
                          child: ForHover(text: "Manage Users"))),
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
                  height = height == size.height*0.08 ? size.height*0.27 : size.height*0.08; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                  bottomHeight = bottomHeight == size.height*0.08 ? size.height*0.27 : size.height*0.08;
                  turns = turns == 0.5 ? 1 : 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: widget.size.height*0.05,
                    child: Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.fitHeight
                    ),
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
          hoverColor = Color.fromRGBO(68, 98, 136, 1);
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

class UrlNavigator {
   void launchOrFocusUrl(String url) {
    // Check if the URL is already stored in local storage
    String? openedUrl = html.window.localStorage['openedUrl'];

    if (openedUrl == url) {
      // If it's already opened, just focus it (this will not work due to browser limitations)
      // There is no direct way to focus an already opened tab.
      // Instead, we can just inform the user or handle it gracefully.
      
        html.window.open(url, '_blank'); // Opens in 
    } else {
      // Open the new URL in a new tab and store it
      html.window.localStorage['openedUrl'] = url;
      html.window.open(url, '_blank'); // Opens in a new tab
    }
  }
}

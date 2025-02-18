import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/navigations/navigator_service.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'dart:html' as html;

class HoverDropdown extends StatefulWidget {
  HoverDropdown({super.key, required this.size, required this.accessTypes});
  Size size;
  List<String> accessTypes;

  @override
  State<HoverDropdown> createState() => _HoverDropdownState();
}

class _HoverDropdownState extends State<HoverDropdown> {
  double? height;
  double? bottomHeight;
  double? maxHeight;
  final UrlNavigator urlNavigator = UrlNavigator();
  SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  List<String> localAccessTypes = ["Dashboard", "WMS Cloud", "Manage Users"];

  late final WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    height = widget.size.height * 0.08;
    bottomHeight = widget.size.height * 0.08;
    maxHeight = widget.size.height * 0.08 +
        widget.size.height * (Set.from(localAccessTypes).intersection(Set.from(widget.accessTypes)).length * 0.061) +
        widget.size.height * 0.061 * 5;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MouseRegion(
      onExit: (value) {
        setState(() {
          height = size.height * 0.08; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
          bottomHeight = size.height * 0.08;
        });
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (height == size.height * 0.08) {
            // because intercepting becoming false if i again open dropdown before 1200ms
            if (mounted) {
              context.read<WarehouseInteractionBloc>().add(Intercepting(intercepting: false));
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        width: size.width * 0.12,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: bottomHeight,
              width: size.width * 0.12,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: PointerInterceptor(
                    child: Column(
                      children: [
                        Gap(size.height * 0.08),
                        if (widget.accessTypes.contains('Dashboard'))
                          InkWell(
                              onTap: () {
                                setState(() {
                                  height = height == maxHeight
                                      ? size.height * 0.08
                                      : maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                                  bottomHeight = bottomHeight == maxHeight ? size.height * 0.08 : maxHeight;
                                });

                                Navigator.pushNamed(context, '/dashboards');
                                // GoRouterService.router.go('/dashboards');
                              },
                              child: const ForHover(text: "Dashboards")),
                        if (widget.accessTypes.contains('Workflow'))
                          InkWell(
                              onTap: () {
                                setState(() {
                                  height = height == maxHeight
                                      ? size.height * 0.08
                                      : maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                                  bottomHeight = bottomHeight == maxHeight ? size.height * 0.08 : maxHeight;
                                });

                                Navigator.pushNamed(context, '/workflow');
                              },
                              child: const ForHover(text: "Workflow")),
                        if (widget.accessTypes.contains('Containers'))
                          InkWell(
                              onTap: () {
                                setState(() {
                                  height = height == maxHeight
                                      ? size.height * 0.08
                                      : maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                                  bottomHeight = bottomHeight == maxHeight ? size.height * 0.08 : maxHeight;
                                });

                                urlNavigator.launchOrFocusUrl('https://cmsweb-4c66c.web.app');
                              },
                              child: const ForHover(text: "Containers")),
                        if (widget.accessTypes.contains('LPN LifeCycle'))
                          InkWell(
                              onTap: () {
                                setState(() {
                                  height = height == maxHeight
                                      ? size.height * 0.08
                                      : maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                                  bottomHeight = bottomHeight == maxHeight ? size.height * 0.08 : maxHeight;
                                });

                                Customs.LPNSelection(context: context);
                              },
                              child: const ForHover(text: "LPN LifeCycle")),
                        if (widget.accessTypes.contains('WMS Cloud'))
                          InkWell(
                              onTap: () {
                                setState(() {
                                  height = height == maxHeight
                                      ? size.height * 0.08
                                      : maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                                  bottomHeight = bottomHeight == maxHeight ? size.height * 0.08 : maxHeight;
                                });
                                urlNavigator.launchOrFocusUrl('https://tg1.wms.ocs.oraclecloud.com/emg_test/index/');
                              },
                              child: const ForHover(text: "WMS Cloud")),
                        if (widget.accessTypes.contains('Manage Users'))
                          InkWell(
                              onTap: () {
                                setState(() {
                                  height = height == maxHeight
                                      ? size.height * 0.08
                                      : maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                                  bottomHeight = bottomHeight == maxHeight ? size.height * 0.08 : maxHeight;
                                });
                                Customs.UsersDialog(context: context);
                              },
                              child: const ForHover(text: "Manage Users")),
                       InkWell(
                            onTap: () {
                              setState(() {
                                height = height == maxHeight
                                    ? size.height * 0.08
                                    : maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                                bottomHeight = bottomHeight == maxHeight ? size.height * 0.08 : maxHeight;
                              });
                              getIt<SharedPreferences>().remove("username");
                              getIt<NavigatorService>().pushAndRemoveUntil('/login', '/');
                              // context.go('/login');
                            },
                            child: const ForHover(text: "Log Out")),
                     
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Container that holds the main profiles section
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.008),
                child: InkWell(
                  onTap: () {},
                  onHover: (data) {
                    context.read<WarehouseInteractionBloc>().add(Intercepting(intercepting: true));
                    setState(() {
                      height = maxHeight; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                      bottomHeight = maxHeight;
                    });
                  },
                  child: SizedBox(
                    height: widget.size.height * 0.045,
                    child: Image.asset('assets/images/menu.png', fit: BoxFit.fitHeight),
                  ),
                ),
              ),
            )
          ],
        ),
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
          hoverColor = const Color.fromRGBO(68, 98, 136, 1);
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
        height: size.height * 0.06,
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: size.width * 0.01),
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

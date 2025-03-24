import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';

import 'sidebar.dart';

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class EntryPoint extends StatelessWidget {
  EntryPoint({super.key, this.titleIcon, required this.title, required this.titles, required this.tabs});
  Widget? titleIcon;
  String title;
  List<String> titles;
  List<Widget> tabs;
 
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _drawerKey,
      body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, lsize) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Sidebar(
                lsize: lsize,
                title: title,
                items: titles,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
                  return Container(
                      height: size.height,
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(192, 208, 230, 1),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
                          boxShadow: [BoxShadow(color: Colors.grey.shade900, offset: const Offset(-1, 0), blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.025),
                      child: tabs[state.index!]);
                }),
              )
            ],
          );
        }),
      ),
    );
  }
}

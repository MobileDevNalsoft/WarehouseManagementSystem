import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/responsive/responsive.dart';

class Sidebar extends StatefulWidget {
  Sidebar({super.key, required this.lsize, this.title, required this.items});
  BoxConstraints lsize;
  String? title;
  List<String> items;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late final DashboardsBloc _dashboardsBloc;

  @override
  void initState() {
    super.initState();
    _dashboardsBloc = context.read<DashboardsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize;
    double scale;
    Device device = getDevice(context);
    switch (device) {
      case Device.mobile:
        fontSize = 12;
        scale = 2.2;
        break;
      case Device.tab:
        fontSize = 14;
        scale = 2.5;
        break;
      case Device.desktop:
        fontSize = 16;
        scale = 1.8;
        break;
    }

    return Container(
      height: size.height,
      decoration: const BoxDecoration(color: Color.fromRGBO(68, 98, 136, 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(size.height * 0.05),
          Row(
            children: [
              Gap(size.width * 0.02),
              if (widget.title == 'Dashboards')
                Image.asset(
                  'assets/images/dashboard.png',
                  scale: scale,
                  color: Colors.white,
                ),
              Gap(size.width * 0.002),
              Text(
                widget.title ?? '',
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Gap(size.height * 0.1),
          Expanded(
            child: BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
              return Column(
                  children: List.generate(
                widget.items.length,
                (index) => InkWell(
                  onTap: () => _dashboardsBloc.add(DashboardChanged(index: index)),
                  child: Container(
                    width: size.width * 0.1,
                    height: size.height * 0.05,
                    margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    padding: EdgeInsets.only(left: size.width * 0.02),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: index == state.index ? Colors.white : const Color.fromRGBO(12, 46, 87, 1),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child: Text(
                      widget.items[index],
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500, color: index == state.index ? Colors.black : Colors.white),
                    ),
                  ),
                ),
              ));
            }),
          ),
        ],
      ),
    );
  }
}

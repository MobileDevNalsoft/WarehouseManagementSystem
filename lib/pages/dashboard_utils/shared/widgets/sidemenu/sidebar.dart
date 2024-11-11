
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/ghaps.dart';

import '../../constants/config.dart';
import '../../constants/defaults.dart';
import 'menu_tile.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {

  late final DashboardsBloc _dashboardsBloc;
  List<String> dashboardTitles = ['Yard', 'Storage', 'Staging', 'Activity', 'Receiving', 'Inspection', 'Dock'];

  @override
  void initState() {
    super.initState();
    _dashboardsBloc = context.read<DashboardsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            gapH16,
            Text("Dashboard's",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.center,),
            gapH16,
            Divider(
              thickness: 2,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: BlocBuilder<DashboardsBloc, DashboardsState>(
                  builder: (context, state) {
                    return ListView(
                      children: List.generate(dashboardTitles.length, (index) => MenuTile(
                          isActive: index == state.index,
                          title: dashboardTitles[index],
                          onPressed: () {
                            _dashboardsBloc.add(DashboardChanged(index: index));
                          },
                        ),)
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
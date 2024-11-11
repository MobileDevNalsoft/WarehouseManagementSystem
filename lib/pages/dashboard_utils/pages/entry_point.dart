import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/dashboards/activity_area_dashboard.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/dashboards/dock_area_dashboard.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/dashboards/inspection_area_dashboard.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/dashboards/receiving_area_dashboard.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/dashboards/staging_area_dashboard.dart';
import 'package:warehouse_3d/pages/dashboard_utils/pages/dashboards/storage_area_dashboard.dart';

import '../responsive.dart';
import '../shared/constants/defaults.dart';
import '../shared/widgets/header.dart';
import '../shared/widgets/sidemenu/sidebar.dart';
import '../shared/widgets/sidemenu/tab_sidebar.dart';
import 'dashboards/yard_area_dashboard.dart';

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class EntryPoint extends StatelessWidget {
  EntryPoint({super.key});

  List<Widget> dashboards = [
    YardAreaDashboard(),
    StorageAreaDashboard(),
    StagingAreaDashboard(),
    ActivityAreaDashboard(),
    ReceivingAreaDashboard(),
    InspectionAreaDashboard(),
    DockAreaDashboard()
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _drawerKey,
      body: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Sidebar(),
          Align(
            alignment: Alignment.centerRight,
            child: BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
              return Container(
                height: size.height,
                  width: size.width * 0.85,
                  decoration:
                      BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50))),
                  padding: EdgeInsets.all(size.height * 0.025),
                  child: dashboards[state.index!]);
            }),
          )
        ],
      ),
    );
  }
}

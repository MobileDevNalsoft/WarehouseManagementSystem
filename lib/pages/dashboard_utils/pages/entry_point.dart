
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

  List<Widget> dashboards = [YardAreaDashboard(), StorageAreaDashboard(), StagingAreaDashboard(), ActivityAreaDashboard(), ReceivingAreaDashboard(), InspectionAreaDashboard(), DockAreaDashboard()];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _drawerKey,
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: BlocBuilder<DashboardsBloc, DashboardsState>(
              builder: (context, state) {
                return dashboards[state.index!];
              }
            ),
          )
        ],
      ),
    );
  }
}

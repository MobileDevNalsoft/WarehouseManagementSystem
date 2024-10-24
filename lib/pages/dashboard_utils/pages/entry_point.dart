
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../responsive.dart';
import '../shared/constants/defaults.dart';
import '../shared/widgets/header.dart';
import '../shared/widgets/sidemenu/sidebar.dart';
import '../shared/widgets/sidemenu/tab_sidebar.dart';
import 'dashboard/dashboard_page.dart';

final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _drawerKey,
      drawer: Responsive.isMobile(context) ? const Sidebar() : null,
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) const Sidebar(),
          if (Responsive.isTablet(context)) const TabSidebar(),
          Expanded(
            child: Column(
              children: [
                // Header(drawerKey: _drawerKey),
                Gap(size.height*0.03),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('DashBoard', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)],),
                Gap(size.height*0.03),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1360),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding *
                                (Responsive.isMobile(context) ? 1 : 1.5),
                          ),
                          child: SafeArea(child: Overview()),
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

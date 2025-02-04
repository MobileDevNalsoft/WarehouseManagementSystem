import 'package:flutter/material.dart';
import 'package:wmssimulator/pages/container_management/layout.dart';
import 'package:wmssimulator/pages/container_management/statistics.dart';
import 'package:wmssimulator/pages/customs/hover_dialog.dart';
import 'package:wmssimulator/pages/lpn_lifecycle/lpn_lifecycle.dart';
import 'package:wmssimulator/pages/workflow/cyclecount.dart';
import 'package:wmssimulator/pages/workflow/qualitycheck.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/activity_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/dock_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/inspection_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/receiving_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/staging_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/storage_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/yard_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/entry_point.dart';
import 'package:wmssimulator/pages/three_js/three_js.dart';

import '../pages/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
        );
      case '/warehouse':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const ThreeJsWebView(),
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOut));
            final fadeAnimation = animation.drive(tween);
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      case '/dashboards':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => EntryPoint(
            title: 'Dashboards',
            titles: const ['Dock', 'Storage', 'Yard', 'Staging', 'Activity', 'Receiving', 'Inspection'],
            tabs: const [
              DockAreaDashboard(),
              StorageAreaDashboard(),
              YardAreaDashboard(),
              StagingAreaDashboard(),
              ActivityAreaDashboard(),
              ReceivingAreaDashboard(),
              InspectionAreaDashboard(),
            ],
          ),
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOut));
            final fadeAnimation = animation.drive(tween);
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      case '/workflow':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => HoverOverlay(
            child: EntryPoint(
              title: 'Workflow',
              titles: const ['Quality Check', 'Cycle Count'],
              tabs: const [QualityCheck(), Cyclecount()],
            ),
          ),
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOut));
            final fadeAnimation = animation.drive(tween);
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      case '/containerManagement':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => HoverOverlay(
            child: EntryPoint(
              title: 'Container Management',
              titles: const ['Layout'],
              tabs: const [ContainerLayout()],
            ),
          ),
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOut));
            final fadeAnimation = animation.drive(tween);
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

class Transitions {
  static PageRouteBuilder<dynamic> slideUpTransition(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder<dynamic> slideLeftTransition(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeIn));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

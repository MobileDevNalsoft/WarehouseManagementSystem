import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/pages/container_management/layout.dart';
import 'package:wmssimulator/pages/container_management/statistics.dart';
import 'package:wmssimulator/pages/customs/hover_dialog.dart';
import 'package:wmssimulator/pages/maps.dart';
import 'package:wmssimulator/pages/trips/trips.dart';
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
      case '/':
        return PageRouteBuilder(
          barrierDismissible: false,
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              getIt<SharedPreferences>().containsKey('username') ? const ThreeJsWebView() : const LoginPage(),
        );
      case '/login':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              getIt<SharedPreferences>().containsKey('username') ? const ThreeJsWebView() : const LoginPage(),
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
      case '/tripstrack':
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => EntryPoint(
            title: 'Trips',
            titles: const ['Trips Track'],
            tabs: const [TripsTrack()],
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
        case '/map':
        return PageRouteBuilder(
          settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) {
            return Maps();
            },
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
          builder: (_) => getIt<SharedPreferences>().containsKey('username') ? const ThreeJsWebView() : const LoginPage(),
        );
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


/*
/// The route configuration.
final GoRouter router = GoRouter(
  observers: [MyNavigationObserver()],
  navigatorKey: getIt<NavigatorService>().navigatorkey,
  redirect: (context, state) => !getIt<SharedPreferences>().containsKey('username') ? '/login' : '/warehouse',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const LoginPage()),
    ),
    GoRoute(
      path: '/warehouse',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(context: context, state: state, child: const ThreeJsWebView()),
    ),
    GoRoute(
      path: '/dashboards',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: EntryPoint(
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
          )),
    ),
    GoRoute(
      path: '/workflow',
      pageBuilder: (context, state) => buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: EntryPoint(
            title: 'Workflow',
            titles: const ['Quality Check', 'Cycle Count'],
            tabs: const [QualityCheck(), Cyclecount()],
          )),
    ),
    GoRoute(
        path: 'containerMangement',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: HoverOverlay(
                child: EntryPoint(
                  title: 'Container Management',
                  titles: const ['Layout', 'Statistics'],
                  tabs: const [ContainerLayout(), ContainerStatistics()],
                ),
              ),
            ))
  ],
);

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeInOut));
        final fadeAnimation = animation.drive(tween);
        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      });
}

class MyNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('Pushed Route: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('Popped Route: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    print('Removed Route: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print("newRoute:  ${newRoute!.settings.name} oldRoute: ${oldRoute!.settings.name}");
  }
}

*/
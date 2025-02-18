import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/bloc/activity_area/activity_area_bloc.dart';
import 'package:wmssimulator/bloc/authentication/authentication_bloc.dart';
import 'package:wmssimulator/bloc/container_management/container_bloc.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/dock_area/dock_area_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_bloc.dart';
import 'package:wmssimulator/bloc/staging/staging_bloc.dart';
import 'package:wmssimulator/bloc/storage/storage_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/bloc/work_queue/work_queue_bloc.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';
import 'package:wmssimulator/bloc/yard/yard_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/inits/my_theme.dart';
import 'package:wmssimulator/models/work_queue_model.dart';
import 'package:wmssimulator/navigations/go_router_service.dart';
import 'package:wmssimulator/pages/three_js/three_js.dart';

import 'bloc/inspection_area/inspection_area_bloc.dart';
import 'navigations/navigator_service.dart';
import 'navigations/route_generator.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');
main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // Function to return the light theme based on your MyTheme class
  MyTheme _lightTheme() {
    return  MyTheme(
      background: Color(0xFFFAFAFA), // Light background
      primaryColor: Color(0xFF6200EE), // Primary color
      secondaryColor: Color(0xFF03DAC6), // Secondary color
      textColor: Color(0xFF000000), // Text color
      buttonColor: Color(0xFF6200EE), // Button color
      dividerColor: Color(0xFFBDBDBD), // Divider color
      inputBorderColor: Color(0xFFBDBDBD), // Input border color
      inputFocusBorderColor: Color(0xFF6200EE), // Input focus color
      inputTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      inputLabelStyle: TextStyle(fontSize: 14, color: Colors.grey),
      globalBorderRadius: BorderRadius.circular(8),
      mobileBreakpoint: 600.0,
      tabletBreakpoint: 768.0,
      desktopBreakpoint: 1024.0,
      buttonHeight: 48.0,
      buttonRadius: BorderRadius.circular(12.0),
      buttonTextSize: 16.0,
      heading: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      bodyText: TextStyle(fontSize: 16.0),
    );
  }

  // Function to return the dark theme based on your MyTheme class
  MyTheme _darkTheme() {
    return MyTheme(
      background: const Color(0xFF121212), // Dark background
      primaryColor: const Color(0xFFBB86FC), // Primary color
      secondaryColor: const Color(0xFF03DAC6), // Secondary color
      textColor: const Color(0xFFFFFFFF), // Text color
      buttonColor: const Color(0xFFBB86FC), // Button color
      dividerColor: const Color(0xFF333333), // Divider color
      inputBorderColor: const Color(0xFFBB86FC), // Input border color
      inputFocusBorderColor: const Color(0xFFBB86FC), // Input focus color
      inputTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
      inputLabelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
      globalBorderRadius: BorderRadius.circular(8),
      mobileBreakpoint: 600.0,
      tabletBreakpoint: 768.0,
      desktopBreakpoint: 1024.0,
      buttonHeight: 48.0,
      buttonRadius:  BorderRadius.circular(12.0),
      buttonTextSize: 16.0,
      heading: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      bodyText: const TextStyle(fontSize: 16.0),
    );
  }

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => WarehouseInteractionBloc(jsInteropService: getIt(), customApi: getIt())),
      BlocProvider(create: (_) => ActivityAreaBloc(customApi: getIt())),
      BlocProvider(create: (_) => InspectionAreaBloc(customApi: getIt())),
      BlocProvider(create: (_) => DockAreaBloc(customApi: getIt())),
      BlocProvider(create: (_) => AuthenticationBloc(navigator: getIt(), customApi: getIt())),
      BlocProvider(create: (_) => YardBloc(customApi: getIt())),
      BlocProvider(create: (_) => DashboardsBloc(customApi: getIt())),
      BlocProvider(create: (_) => ReceivingBloc(customApi: getIt())),
      BlocProvider(create: (_) => StagingBloc(customApi: getIt())),
      BlocProvider(create: (_) => StorageBloc(customApi: getIt())),
      BlocProvider(create: (_) => WorkflowBloc(customApi: getIt())),
      BlocProvider(create: (_) => ContainerBloc(customApi: getIt())),
      BlocProvider(create: (_) => WorkQueueBloc(customApi: getIt()))
    ],
    child: MaterialApp(
      navigatorKey: getIt<NavigatorService>().navigatorkey,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      theme: ThemeData(fontFamily: 'Gilroy', colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
      // theme: ThemeData(
      //   extensions:const  [
      //      MyTheme(background: Colors.blue), // Set your custom theme
      //   ],
      // ),
      // theme: _darkTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: !sharedPreferences.containsKey('username') ? '/login' : '/warehouse',
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorObservers: [MyNavigationObserver()],
      // routerConfig: GoRouterService.router,
      
    ),
  ));
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

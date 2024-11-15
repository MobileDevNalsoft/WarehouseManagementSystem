import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_3d/bloc/activity_area/activity_area_bloc.dart';
import 'package:warehouse_3d/bloc/authentication/authentication_bloc.dart';
import 'package:warehouse_3d/bloc/dashboards/dashboard_bloc.dart';
import 'package:warehouse_3d/bloc/dock_area/dock_area_bloc.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_bloc.dart';
import 'package:warehouse_3d/bloc/staging/staging_bloc.dart';
import 'package:warehouse_3d/bloc/storage/storage_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/yard/yard_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';

import 'bloc/inspection_area/inspection_area_bloc.dart';
import 'navigations/navigator_service.dart';
import 'navigations/route_generator.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');                           
main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => WarehouseInteractionBloc(jsInteropService: getIt())),
      BlocProvider(create: (_) => ActivityAreaBloc(customApi: getIt())),
      BlocProvider(create: (_) => InspectionAreaBloc(customApi: getIt())),
      BlocProvider(create: (_) => DockAreaBloc(customApi: getIt())),
      BlocProvider(create: (_) => AuthenticationBloc(navigator: getIt())),
      BlocProvider(create: (_) => YardBloc(customApi: getIt())),
      BlocProvider(create: (_) => DashboardsBloc(customApi: getIt())),
      BlocProvider(create: (_) => ReceivingBloc(customApi: getIt())),
      BlocProvider(create: (_) => StagingBloc(customApi: getIt())),
      BlocProvider(create: (_) => StorageBloc(customApi: getIt()))
       
    ],
    child: MaterialApp(
        navigatorKey: getIt<NavigatorService>().navigatorkey,
        scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
        theme: ThemeData(fontFamily: 'Gilroy', colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
        debugShowCheckedModeBanner: false,
        initialRoute: '/dashboards',
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [MyNavigationObserver()],
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

import 'dart:html' as html;
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as gt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wmssimulator/bloc/activity_area/activity_area_bloc.dart';

import 'package:wmssimulator/bloc/authentication/authentication_bloc.dart';
import 'package:wmssimulator/bloc/container_management/container_bloc.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/dock_area/dock_area_bloc.dart';
import 'package:wmssimulator/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_bloc.dart';
import 'package:wmssimulator/bloc/staging/staging_bloc.dart';
import 'package:wmssimulator/bloc/storage/storage_bloc.dart';
import 'package:wmssimulator/bloc/trips/trips_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/bloc/work_queue/work_queue_bloc.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';
import 'package:wmssimulator/bloc/yard/yard_bloc.dart';
import 'package:wmssimulator/inits/init.dart';
import 'package:wmssimulator/pages/container_management/layout.dart';
import 'package:wmssimulator/pages/login.dart';
import 'package:wmssimulator/pages/maps.dart';
import 'package:wmssimulator/pages/three_js/three_js.dart';
import 'package:wmssimulator/pages/trips/cc_camera.dart';
import 'package:wmssimulator/pages/trips/trips.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/entry_point.dart';

import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/activity_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/dock_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/inspection_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/receiving_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/staging_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/storage_area_dashboard.dart';
import 'package:wmssimulator/pages/dashboard_utils/pages/dashboards/yard_area_dashboard.dart';
import 'package:wmssimulator/pages/workflow/cyclecount.dart';
import 'package:wmssimulator/pages/workflow/qualitycheck.dart';

// Initialize the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  html.document.body?.focus();
  await init();

//  MediaKit.ensureInitialized();
  SharedPreferences sharedPreferences = getIt<SharedPreferences>();
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
      BlocProvider(create: (_) => WorkQueueBloc(customApi: getIt())),
      BlocProvider(create: (_) => TripsBloc(customApi: getIt())),
    ],
    child: gt.GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black),
      ),
      routerDelegate: gt.Get.rootDelegate,
    ),
  ));
}

abstract class AppPages {
  static final pages = [
    gt.GetPage(
      name: getIt<SharedPreferences>().getString('username')==null?'/login':'/warehouse',
      page: () => getIt<SharedPreferences>().getString('username') == null ? LoginPage() : ThreeJsWebView(),
      transition: gt.Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 1000),
    ),
    gt.GetPage(
      name: Routes.warehouse,
      page: () => ThreeJsWebView(),
      transition: gt.Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 1000),
    ),
    gt.GetPage(
      name: Routes.tripstrack,
      page: () => EntryPoint(title: '', titles: ['Shipment'], tabs: [TripsTrack()]),
      transition: gt.Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 1000),
    ),
    gt.GetPage(
      name: Routes.maps,
      page: () => Maps(),
      transition: gt.Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 1000),
    ),
    gt.GetPage(
      name: Routes.dashboards,
      page: () => EntryPoint(
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
      transition: gt.Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 1000),
    ),
    gt.GetPage(
      name: Routes.workflow,
      page: () => EntryPoint(
        title: 'Workflow',
        titles: const ['Quality Check', 'Cycle Count'],
        tabs: const [QualityCheck(), Cyclecount()],
      ),
      transition: gt.Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 1000),
    ),
    // gt.GetPage(
    //   name: Routes.containerManagement,
    //   page: () => EntryPoint(
    //     title: 'Container Management',
    //     titles: const ['Layout'],
    //     tabs: const [ContainerLayout()],
    //   ),
    //   transition: gt.Transition.fadeIn,
    //   transitionDuration: Duration(milliseconds: 1000),
    // ),
    //  gt.GetPage(
    //   name: Routes.camera,
    //   page: () => CCTVScreen(),
    //   transition: gt.Transition.fadeIn,
    //   transitionDuration: Duration(milliseconds: 1000),
    // ),
  ];
}

abstract class Routes {
  static String login = getIt<SharedPreferences>().getString('username')!=null?'/warehouse':'/login';
  static const warehouse = '/warehouse';
  static const tripstrack = '/tripstrack';
  static const maps = '/maps';
  static const containerManagement = '/containerManagement';
  static const workflow = '/workflow';
  static const dashboards = '/dashboards';
  // static const camera = '/camera';
}

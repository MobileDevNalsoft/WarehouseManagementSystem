import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/pages/warehouse.dart';
import 'package:warehouse_3d/pages/warehouse3d.dart';
import 'package:warehouse_3d/pages/warehouse_test.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'pages/3JS_with_flutter.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');
main() {
init();
WidgetsFlutterBinding.ensureInitialized();

  print('started');
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => WarehouseInteractionBloc(jsInteropService: getIt())),
    ],
    child: MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: ThreeDTest()
    ),
  ));
}

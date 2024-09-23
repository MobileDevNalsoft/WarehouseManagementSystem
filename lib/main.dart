import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'pages/3JS_with_flutter.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');
Future main() async {

WidgetsFlutterBinding.ensureInitialized();

  print('started');
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => WarehouseInteractionBloc()),
    ],
    child: MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: ThreeDTest()
    ),
  ));
}

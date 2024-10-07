import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';

import 'pages/three_js/three_js.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');
main() {
  init();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => WarehouseInteractionBloc(jsInteropService: getIt())),
    ],
    child: MaterialApp(
        theme: ThemeData(fontFamily: 'Gilroy', colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
        debugShowCheckedModeBanner: false,
        home: const ThreeJsWebView()),
  ));
}

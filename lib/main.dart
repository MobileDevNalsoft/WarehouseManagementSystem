import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/pages/3d_rack.dart';
import 'package:warehouse_3d/pages/warehouse_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => WarehouseInteractionBloc()),
    ],
    child: MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, primary: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: const ThreeDRack(),
    ),
  ));
}

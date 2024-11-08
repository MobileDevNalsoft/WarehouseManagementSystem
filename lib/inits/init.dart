import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';

import '../constants/app_constants.dart';
import '../local_network_calls.dart';
import '../navigations/navigator_service.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.allowReassignment = true;

  // Api
  getIt.registerLazySingleton<NetworkCalls>(() => NetworkCalls(AppConstants.APEX_URL, getIt<Dio>(), connectTimeout: 30, receiveTimeout: 30,username: AppConstants.APIUSERNAME,password: AppConstants.APIPASSWORD));

  // Navigator Service
  getIt.registerLazySingleton<NavigatorService>(() => NavigatorService());

  //js interop service
  getIt.registerFactory(() => JsInteropService());

  //Initializations
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerFactory(() => Dio());
}

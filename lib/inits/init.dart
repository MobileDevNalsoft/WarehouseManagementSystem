
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:warehouse_3d/js_inter.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.allowReassignment = true;

  //Api
  // getIt.registerLazySingleton<NetworkCalls>(() => NetworkCalls(AppConstants.BaseURL, getIt(), connectTimeout: 30, receiveTimeout: 30));

  //Repo
  // getIt.registerLazySingleton<Repository>(
  //   () => Repository(api: getIt()),
  // );

  //Navigator Service
  // getIt.registerLazySingleton<NavigatorService>(() => NavigatorService());

  //js interop service
  getIt.registerFactory(() => JsInteropService());

  //Initializations
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerFactory(() => Dio());
}


import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

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

  //Initializations
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerFactory(() => Dio());
}

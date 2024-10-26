import 'dart:convert';
import 'dart:io';
import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:warehouse_3d/network_util.dart';


class NetworkCalls extends HttpOverrides {
  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;
  final int maxRedirects;
  final String? username;
  final String? password;
  final Map<String, dynamic>? headers;

  Dio dio;
  LoggingInterceptor loggingInterceptor = LoggingInterceptor();

  NetworkCalls(
    this.baseUrl,
    this.dio, {
    this.username,
    this.password,
    this.connectTimeout = 5,
    this.receiveTimeout = 5,
    this.maxRedirects = 5,
    this.headers,
  }) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = Duration(seconds: connectTimeout)
      ..options.receiveTimeout = Duration(seconds: receiveTimeout)
      ..options.maxRedirects = maxRedirects
      ..httpClientAdapter
      ..options.headers = headers ?? {};
    dio.interceptors.add(loggingInterceptor);

    
    
      (dio.httpClientAdapter as BrowserHttpClientAdapter);
    
    
  }

  Future<ApiResponse> get(String uri,
      {Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? methodHeaders}) async {
    try {
      Response response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ??
                methodHeaders ??
                {
                  'Accept': 'application/json',
                  'Content-type': 'application/json',
                 'X-Requested-With': 'XMLHttpRequest',
                  'Authorization':
                      'Basic ${base64.encode(utf8.encode('$username:$password'))}'
                }),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.withSuccess(response);
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      return ApiResponse.withError(e);
    }
  }

  Future<ApiResponse> post(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? methodHeaders}) async {
    try {
      Response response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ??
                methodHeaders ??
                {
                  'Authorization':
                      'Basic ${base64.encode(utf8.encode('$username:$password'))}'
                }),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.withSuccess(response);
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      return ApiResponse.withError(e);
    }
  }

  Future<ApiResponse> put(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? methodHeaders}) async {
    try {
      Response response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ??
                methodHeaders ??
                {
                  'Authorization':
                      'Basic ${base64.encode(utf8.encode('$username:$password'))}'
                }),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponse.withSuccess(response);
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      return ApiResponse.withError(e);
    }
  }

  Future<ApiResponse> delete(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Map<String, dynamic>? methodHeaders}) async {
    try {
      Response response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(
            headers: headers ??
                methodHeaders ??
                {
                  'Authorization':
                      'Basic ${base64.encode(utf8.encode('$username:$password'))}'
                }),
        cancelToken: cancelToken,
      );
      return ApiResponse.withSuccess(response);
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      return ApiResponse.withError(e);
    }
  }
}
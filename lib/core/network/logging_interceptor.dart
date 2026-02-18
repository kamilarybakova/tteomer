import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️ REQUEST');
    debugPrint('URL: ${options.method} ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ RESPONSE');
    debugPrint('URL: ${response.requestOptions.uri}');
    debugPrint('Status: ${response.statusCode}');
    debugPrint('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ ERROR');
    debugPrint('URL: ${err.requestOptions.uri}');
    debugPrint('Message: ${err.message}');
    debugPrint('Response: ${err.response?.data}');
    super.onError(err, handler);
  }
}

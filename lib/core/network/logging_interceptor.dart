import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  static const _chunkSize = 800;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logBlock('➡️ REQUEST');
    _logBlock('URL: ${options.method} ${options.uri}');
    _logBlock('Headers: ${_formatPayload(options.headers)}');
    _logBlock('Data: ${_formatPayload(options.data)}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logBlock('✅ RESPONSE');
    _logBlock('URL: ${response.requestOptions.uri}');
    _logBlock('Status: ${response.statusCode}');
    _logBlock('Data: ${_formatPayload(response.data)}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logBlock('❌ ERROR');
    _logBlock('URL: ${err.requestOptions.uri}');
    _logBlock('Message: ${err.message}');
    _logBlock('Response: ${_formatPayload(err.response?.data)}');
    super.onError(err, handler);
  }

  void _logBlock(String message) {
    if (message.length <= _chunkSize) {
      debugPrint(message);
      return;
    }

    for (var start = 0; start < message.length; start += _chunkSize) {
      final end = (start + _chunkSize < message.length)
          ? start + _chunkSize
          : message.length;
      debugPrint(message.substring(start, end));
    }
  }

  String _formatPayload(Object? payload) {
    if (payload == null) {
      return 'null';
    }

    if (payload is Map || payload is List) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(payload);
    }

    return payload.toString();
  }
}

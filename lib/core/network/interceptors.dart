import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_config.dart';
import '../storage/secure_storage_provider.dart';
import '../utils/locale_state.dart';
import 'logging_interceptor.dart';

class RetryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // retry logic
    super.onError(err, handler);
  }
}

class AuthInterceptor extends Interceptor {
  final Ref ref;
  Future<String?>? _refreshTokenFuture;

  AuthInterceptor(this.ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: 'access_token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept-Language'] = LocaleState.current.languageCode;

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final requestOptions = err.requestOptions;
    final isUnauthorized = statusCode == 401;
    final isRefreshRequest = requestOptions.path.contains(
      '/api/v1/auth/refresh/',
    );
    final alreadyRetried = requestOptions.extra['auth_retry'] == true;

    if (isUnauthorized && !isRefreshRequest && !alreadyRetried) {
      debugPrint('🔐 401 received → attempting token refresh');

      final newAccessToken = await _getFreshAccessToken();

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        try {
          final response = await _retryRequest(requestOptions, newAccessToken);
          debugPrint('✅ Original request retried successfully after refresh');
          handler.resolve(response);
          return;
        } catch (retryError) {
          debugPrint('🔴 Retried request failed after refresh: $retryError');
        }
      }

      debugPrint('🔐 Refresh failed → clearing auth tokens');
      await _clearTokens();
    }

    handler.next(err);
  }

  Future<String?> _getFreshAccessToken() async {
    if (_refreshTokenFuture != null) {
      return _refreshTokenFuture;
    }

    _refreshTokenFuture = _refreshAccessToken();
    try {
      return await _refreshTokenFuture;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  Future<String?> _refreshAccessToken() async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: 'refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint('🔐 No refresh token found');
      return null;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept-Language': LocaleState.current.languageCode},
      ),
    )..interceptors.add(LoggingInterceptor());

    try {
      debugPrint('🔄 Requesting new access token via refresh endpoint');
      final response = await dio.post(
        '/api/v1/auth/refresh/',
        data: {'refresh': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final payload = data['data'] as Map<String, dynamic>?;
      final accessToken =
          data['access'] as String? ?? payload?['access'] as String?;

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('🔴 Refresh response did not contain access token');
        return null;
      }

      await storage.write(key: 'access_token', value: accessToken);
      debugPrint('✅ Access token refreshed and stored');
      return accessToken;
    } on DioException catch (error) {
      debugPrint(
        '🔴 Refresh token request failed: ${error.response?.data ?? error.message}',
      );
      return null;
    } catch (error) {
      debugPrint('🔴 Unexpected refresh error: $error');
      return null;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )..interceptors.add(LoggingInterceptor());

    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $accessToken';
    headers['Accept-Language'] = LocaleState.current.languageCode;

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: {...requestOptions.extra, 'auth_retry': true},
      ),
      cancelToken: requestOptions.cancelToken,
      onSendProgress: requestOptions.onSendProgress,
      onReceiveProgress: requestOptions.onReceiveProgress,
    );
  }

  Future<void> _clearTokens() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    await storage.delete(key: 'user_role');
    await storage.delete(key: 'user_level');
  }
}

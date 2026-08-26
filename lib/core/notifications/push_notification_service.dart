import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PushNotificationService {
  final Dio dio;
  final FlutterSecureStorage storage;

  PushNotificationService({required this.dio, required this.storage});

  static const _deviceIdKey = 'push_device_id';
  static const _currentTokenKey = 'push_current_token';

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  bool _initialized = false;
  bool _isSyncing = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      debugPrint('🔔 [FCM] Initializing push notifications');
      final messaging = FirebaseMessaging.instance;
      await messaging.setAutoInitEnabled(true);

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint(
        '🔔 [FCM] Permission status: ${settings.authorizationStatus.name}',
      );

      _tokenRefreshSubscription = messaging.onTokenRefresh.listen((
        token,
      ) async {
        debugPrint('🔄 [FCM] Token refreshed');
        await _persistCurrentToken(token);
        await syncCurrentTokenIfAuthenticated(tokenOverride: token);
      });

      _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen((
        message,
      ) {
        debugPrint(
          '📩 [FCM] Foreground message received: ${message.messageId ?? 'no-id'}',
        );
      });

      await syncCurrentTokenIfAuthenticated();
    } catch (error, stackTrace) {
      debugPrint('🔴 [FCM] Initialization failed: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> syncCurrentTokenIfAuthenticated({String? tokenOverride}) async {
    if (_isSyncing) {
      debugPrint('🔔 [FCM] Token sync already in progress');
      return;
    }

    _isSyncing = true;
    try {
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('🔔 [FCM] Skipping sync: user is not authenticated');
        return;
      }

      final token = tokenOverride ?? await _resolveFcmToken();
      if (token == null || token.isEmpty) {
        debugPrint('🔔 [FCM] No FCM token available to sync');
        return;
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final deviceId = await _getOrCreateDeviceId();

      await dio.post(
        '/api/v1/notifications/device-tokens/',
        data: {
          'token': token,
          'platform': _platformValue,
          'device_id': deviceId,
          'app_version': packageInfo.version,
        },
      );

      await _persistCurrentToken(token);
      debugPrint('✅ [FCM] Device token synced with backend');
    } catch (error, stackTrace) {
      debugPrint('🔴 [FCM] Failed to sync token: $error');
      debugPrint('$stackTrace');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> deactivateCurrentToken() async {
    try {
      final token = await storage.read(key: _currentTokenKey);
      if (token == null || token.isEmpty) {
        debugPrint('🔔 [FCM] No stored token to deactivate');
        return;
      }

      await dio.post(
        '/api/v1/notifications/device-tokens/deactivate/',
        data: {'token': token},
      );
      debugPrint('✅ [FCM] Device token deactivated');
    } catch (error, stackTrace) {
      debugPrint('🔴 [FCM] Failed to deactivate token: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundMessageSubscription?.cancel();
  }

  Future<String?> _resolveFcmToken() async {
    if (Platform.isIOS) {
      final apnsToken = await _waitForApnsToken();
      if (apnsToken == null || apnsToken.isEmpty) {
        debugPrint(
          '🔔 [FCM] APNs token is not available yet, skipping FCM token fetch for now',
        );
        return null;
      }
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null && token.isNotEmpty) {
      await _persistCurrentToken(token);
    }
    return token;
  }

  Future<String?> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 8; attempt++) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null && apnsToken.isNotEmpty) {
        debugPrint('✅ [FCM] APNs token received');
        return apnsToken;
      }

      debugPrint('⏳ [FCM] Waiting for APNs token (${attempt + 1}/8)');
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    return null;
  }

  Future<void> _persistCurrentToken(String token) async {
    await storage.write(key: _currentTokenKey, value: token);
  }

  Future<String> _getOrCreateDeviceId() async {
    final stored = await storage.read(key: _deviceIdKey);
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final random = Random.secure();
    final generated =
        'device-${DateTime.now().microsecondsSinceEpoch}-${random.nextInt(1 << 32)}';
    await storage.write(key: _deviceIdKey, value: generated);
    return generated;
  }

  String get _platformValue {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return defaultTargetPlatform.name;
  }
}

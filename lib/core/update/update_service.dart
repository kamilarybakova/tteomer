import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/app_config.dart';
import 'update_info.dart';

class UpdateService {
  Future<UpdateInfo> getUpdateInfo() async {
    try {
      debugPrint('🔄 [RemoteConfig] Starting update check');
      await _ensureFirebaseInitialized();

      final remoteConfig = FirebaseRemoteConfig.instance;
      debugPrint('🔄 [RemoteConfig] Configuring fetch settings');
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      debugPrint('🔄 [RemoteConfig] Setting defaults');
      await remoteConfig.setDefaults(const {
        'force_update': false,
        'latest_version_android': '1.0.0',
        'latest_version_ios': '1.0.0',
      });
      debugPrint('🔄 [RemoteConfig] Fetching and activating');
      final updated = await remoteConfig.fetchAndActivate();
      debugPrint('✅ [RemoteConfig] Fetch complete | updated: $updated');

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      debugPrint('📦 [RemoteConfig] Current app version: $currentVersion');
      final latestVersion = Platform.isIOS
          ? remoteConfig.getString('latest_version_ios')
          : remoteConfig.getString('latest_version_android');
      final forceUpdate = remoteConfig.getBool('force_update');
      final shouldUpdate = _compareVersions(currentVersion, latestVersion) < 0;
      debugPrint(
        '📥 [RemoteConfig] Values | platform: ${Platform.isIOS ? 'iOS' : 'Android'} | latestVersion: $latestVersion | forceUpdate: $forceUpdate',
      );
      debugPrint(
        '🧮 [RemoteConfig] Decision | shouldUpdate: $shouldUpdate | forceUpdateEffective: ${shouldUpdate && forceUpdate}',
      );

      return UpdateInfo(
        shouldUpdate: shouldUpdate,
        forceUpdate: shouldUpdate && forceUpdate,
        latestVersion: latestVersion,
        currentVersion: currentVersion,
      );
    } catch (error, stackTrace) {
      debugPrint('🔴 [RemoteConfig] Update check failed: $error');
      debugPrint('🔴 [RemoteConfig] Stack trace: $stackTrace');
      return UpdateInfo.disabled;
    }
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isNotEmpty) {
      debugPrint('✅ [RemoteConfig] Firebase already initialized');
      return;
    }
    debugPrint('🔄 [RemoteConfig] Initializing Firebase');
    await Firebase.initializeApp();
    debugPrint('✅ [RemoteConfig] Firebase initialized');
  }

  int _compareVersions(String current, String latest) {
    final currentParts = current.split('.').map(int.tryParse).toList();
    final latestParts = latest.split('.').map(int.tryParse).toList();
    final maxLength = currentParts.length > latestParts.length
        ? currentParts.length
        : latestParts.length;

    for (var i = 0; i < maxLength; i++) {
      final currentPart = i < currentParts.length ? (currentParts[i] ?? 0) : 0;
      final latestPart = i < latestParts.length ? (latestParts[i] ?? 0) : 0;
      if (currentPart < latestPart) return -1;
      if (currentPart > latestPart) return 1;
    }

    return 0;
  }

  Uri getStoreUri() {
    if (Platform.isAndroid) {
      return Uri.parse(AppConfig.androidPlayStoreUrl);
    }
    return Uri.parse(AppConfig.iosAppStoreUrl);
  }

  Uri getStoreFallbackUri() {
    if (Platform.isAndroid) {
      return Uri.parse(AppConfig.androidPlayStoreUrl);
    }
    return Uri.parse(AppConfig.iosAppStoreUrl);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../storage/secure_storage_provider.dart';
import 'push_notification_service.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((
  ref,
) {
  return PushNotificationService(
    dio: ref.read(dioProvider),
    storage: ref.read(secureStorageProvider),
  );
});

class PushNotificationInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const PushNotificationInitializer({super.key, required this.child});

  @override
  ConsumerState<PushNotificationInitializer> createState() =>
      _PushNotificationInitializerState();
}

class _PushNotificationInitializerState
    extends ConsumerState<PushNotificationInitializer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pushNotificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

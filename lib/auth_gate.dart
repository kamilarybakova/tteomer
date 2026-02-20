import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage_provider.dart';
import '../../../main_navigation_screen.dart';
import 'features/auth/presentation/pages/auth_screen.dart';

final authCheckProvider = FutureProvider<bool>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.read(key: 'access_token');
  return token != null && token.isNotEmpty;
});

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authCheckProvider);

    return auth.when(
      loading: () => const _Splash(),
      error: (_, __) => const AuthScreen(),
      data: (isLoggedIn) {
        return isLoggedIn
            ? const MainNavigationScreen()
            : const AuthScreen();
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

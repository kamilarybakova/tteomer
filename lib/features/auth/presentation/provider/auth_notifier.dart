import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tteomer/core/notifications/push_notification_service.dart';
import 'package:tteomer/features/auth/domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_confirm_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ResetPasswordConfirmUseCase resetPasswordConfirmUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final FlutterSecureStorage storage;
  final PushNotificationService pushNotifications;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.resetPasswordUseCase,
    required this.resetPasswordConfirmUseCase,
    required this.changePasswordUseCase,
    required this.storage,
    required this.pushNotifications,
  }) : super(AuthInitial());

  String _extractError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      final errors = data?['errors'];
      if (errors is Map) {
        if (errors['detail'] != null) {
          return errors['detail'].toString();
        }

        final messages = <String>[];
        errors.forEach((key, value) {
          if (value is List) {
            for (final item in value) {
              messages.add(item.toString());
            }
          } else if (value != null) {
            messages.add(value.toString());
          }
        });
        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }

      final detail = data?['detail'];
      if (detail != null) return detail.toString();
    }
    return e.toString();
  }

  Future<void> login(String email, String password) async {
    try {
      state = AuthLoading();
      final tokens = await loginUseCase(email: email, password: password);
      await storage.write(key: 'access_token', value: tokens.accessToken);
      await storage.write(key: 'refresh_token', value: tokens.refreshToken);
      await storage.write(key: 'user_role', value: tokens.role);
      await storage.write(key: 'user_level', value: tokens.level);
      await pushNotifications.syncCurrentTokenIfAuthenticated();
      state = AuthSuccess(tokens);
    } catch (e) {
      state = AuthError(_extractError(e));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String groupCode,
  }) async {
    try {
      state = AuthLoading();
      final tokens = await registerUseCase(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        groupCode: groupCode,
      );
      await storage.write(key: 'access_token', value: tokens.accessToken);
      await storage.write(key: 'refresh_token', value: tokens.refreshToken);
      await storage.write(key: 'user_role', value: tokens.role);
      await storage.write(key: 'user_level', value: tokens.level);
      await pushNotifications.syncCurrentTokenIfAuthenticated();
      state = AuthRegistered();
    } catch (e) {
      state = AuthError(_extractError(e));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = AuthLoading();
      await resetPasswordUseCase(email: email);
      state = ResetPasswordEmailSent();
    } catch (e) {
      state = AuthError(_extractError(e));
    }
  }

  Future<void> resetPasswordConfirm({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      state = AuthLoading();
      await resetPasswordConfirmUseCase(
        email: email,
        code: code,
        password: password,
      );
      state = ResetPasswordSuccess();
    } catch (e) {
      state = AuthError(_extractError(e));
    }
  }

  Future<void> changePassword({required String newPassword}) async {
    try {
      state = AuthLoading();
      await changePasswordUseCase(newPassword: newPassword);
      state = PasswordChangeSuccess();
    } catch (e) {
      state = AuthError(_extractError(e));
    }
  }

  Future<void> logout() async {
    await pushNotifications.deactivateCurrentToken();
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    await storage.delete(key: 'user_role');
    await storage.delete(key: 'user_level');
    state = AuthInitial();
  }
}

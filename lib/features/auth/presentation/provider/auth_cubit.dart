import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tteomer/features/auth/domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_confirm_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ResetPasswordConfirmUseCase resetPasswordConfirmUseCase;
  final FlutterSecureStorage storage;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.resetPasswordUseCase,
    required this.resetPasswordConfirmUseCase,
    required this.storage,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    try {
      state = AuthLoading();

      final tokens = await loginUseCase(
        email: email,
        password: password,
      );

      await storage.write(key: 'access_token', value: tokens.accessToken);
      await storage.write(key: 'refresh_token', value: tokens.refreshToken);

      state = AuthSuccess(tokens);
    } catch (e) {
      state = AuthError(e.toString());
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
      await registerUseCase(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        groupCode: groupCode,
      );
      state = AuthRegistered();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = AuthLoading();
      await resetPasswordUseCase(email: email);
      state = ResetPasswordEmailSent();
    } catch (e) {
      state = AuthError(e.toString());
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
      state = AuthError(e.toString());
    }
  }
}
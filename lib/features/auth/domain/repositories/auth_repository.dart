import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<AuthTokens> login({
    required String email,
    required String password,
  });

  Future<AuthTokens> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String groupCode,
  });

  Future<void> resetPassword({
    required String email
  });

  Future<void> resetPasswordConfirm({
    required String email,
    required String code,
    required String password
  });

  Future<void> changePassword({
    required String newPassword,
  });
}

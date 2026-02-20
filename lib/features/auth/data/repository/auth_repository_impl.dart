import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) {
    return remote.login(email: email, password: password);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String groupCode,
  }) {
    return remote.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      groupCode: groupCode,
    );
  }

  @override
  Future<void> resetPassword({
    required String email
  }) {
    return remote.resetPassword(email: email);
  }

  @override
  Future<void> resetPasswordConfirm({
    required String email,
    required String code,
    required String password
  }) {
    return remote.resetPasswordConfirm(
      email: email,
      code: code,
      password: password
    );
  }
}
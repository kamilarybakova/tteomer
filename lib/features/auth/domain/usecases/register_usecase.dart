import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthTokens> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String groupCode,
  }) {
    return repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      groupCode: groupCode,
    );
  }
}
import '../repositories/auth_repository.dart';

class ResetPasswordConfirmUseCase {
  final AuthRepository repository;

  ResetPasswordConfirmUseCase(this.repository);

  Future<void> call({
    required String email,
    required String code,
    required String password,
  }) {
    return repository.resetPasswordConfirm(
      email: email,
      code: code,
      password: password,
    );
  }
}

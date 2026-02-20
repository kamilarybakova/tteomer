import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_confirm_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';

// DataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

// UseCases
final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final registerUseCaseProvider = Provider((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider(
      (ref) => ResetPasswordUseCase(ref.read(authRepositoryProvider)),
);

final resetPasswordConfirmUseCaseProvider = Provider(
      (ref) => ResetPasswordConfirmUseCase(ref.read(authRepositoryProvider)),
);

// Notifier
final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
    resetPasswordConfirmUseCase: ref.read(resetPasswordConfirmUseCaseProvider),
  );
});
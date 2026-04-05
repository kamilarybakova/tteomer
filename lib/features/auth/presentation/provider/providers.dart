import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/main/domain/usecase/fetch_registration_status.dart';
import 'package:tteomer/features/main/presentation/state/main_notifier.dart';
import 'package:tteomer/features/main/presentation/state/main_state.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_provider.dart';
import '../../../documents/data/datasource/materials_remote_datasource.dart';
import '../../../documents/data/repository/materials_repository_impl.dart';
import '../../../documents/domain/usecase/get_categories_usecase.dart';
import '../../../documents/domain/usecase/get_materials_usecase.dart';
import '../../../documents/presentation/provider/materials_notifier.dart';
import '../../../documents/presentation/provider/materials_state.dart';
import '../../../main/data/datasource/main_remote_datasource.dart';
import '../../../main/data/repository/main_repository_impl.dart';
import '../../../main/domain/repository/main_repository.dart';
import '../../../main/domain/usecase/fetch_news_usecase.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_confirm_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_notifier.dart';
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
    storage: ref.read(secureStorageProvider),
  );
});

final materialsRemoteDataSourceProvider = Provider(
      (ref) => MaterialsRemoteDataSourceImpl(ref.read(dioProvider)),
);

final materialsRepositoryProvider = Provider(
      (ref) => MaterialsRepositoryImpl(
    ref.read(materialsRemoteDataSourceProvider),
  ),
);

final getMaterialsUseCaseProvider = Provider(
      (ref) => GetMaterialsUseCase(
    ref.read(materialsRepositoryProvider),
  ),
);

final getCategoriesUseCaseProvider = Provider(
      (ref) => GetCategoriesUseCase(
    ref.read(materialsRepositoryProvider),
  ),
);

final materialsNotifierProvider =
StateNotifierProvider<MaterialsNotifier, MaterialsState>((ref) {
  return MaterialsNotifier(
    getMaterials: ref.read(getMaterialsUseCaseProvider),
    getCategories: ref.read(getCategoriesUseCaseProvider),
  );
});

final newsRemoteDataSourceProvider = Provider<MainRemoteDatasource>((ref) {
  return MainRemoteDatasourceImpl(ref.read(dioProvider));
});

final newsRepositoryProvider = Provider<MainRepository>((ref) {
  return MainRepositoryImpl(
    ref.read(newsRemoteDataSourceProvider),
  );
});

final fetchNewsUseCaseProvider = Provider((ref) {
  return FetchNewsUseCase(
    ref.read(newsRepositoryProvider),
  );
});

final fetchRegistrationStatusProvider = Provider((ref) {
  return FetchRegistrationStatus(
    ref.read(newsRepositoryProvider),
  );
});

final mainNotifierProvider =
StateNotifierProvider<MainNotifier, NewsState>((ref) {
  return MainNotifier(
    ref.read(fetchNewsUseCaseProvider),
    ref.read(fetchRegistrationStatusProvider),
  );
});
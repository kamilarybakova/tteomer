import 'package:dio/dio.dart';
import '../model/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
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
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/v1/auth/login/',
      data: {
        'email': email,
        'password': password,
      },
    );

    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String groupCode,
  }) async {
    final response = await dio.post(
      '/api/v1/auth/register/',
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'group_code': groupCode,
      },
    );

    return AuthResponseModel.fromJson(response.data);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await dio.post(
      '/api/v1/auth/password-reset/',
      data: {
        'email': email,
      },
    );
  }

  @override
  Future<void> resetPasswordConfirm({
    required String email,
    required String code,
    required String password
  }) async {
    dio.post(
      '/api/v1/auth/password-reset/confirm/',
      data: {
        'email': email,
        'code': code,
        'new_password': password,
      }
    );
  }
}
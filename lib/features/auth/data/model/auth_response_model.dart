import '../../domain/entities/auth_tokens.dart';

class AuthUserModel {
  final int id;
  final String email;
  final String role;
  final String? level;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.role,
    this.level,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      level: json['level'] as String?,
    );
  }
}

class AuthDataModel {
  final AuthUserModel user;
  final String access;
  final String refresh;

  const AuthDataModel({
    required this.user,
    required this.access,
    required this.refresh,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      access: json['access'] as String? ?? '',
      refresh: json['refresh'] as String? ?? '',
    );
  }
}

class AuthResponseModel extends AuthTokens {
  final bool success;
  final AuthDataModel data;

  AuthResponseModel({
    required this.success,
    required this.data,
  }) : super(
          accessToken: data.access,
          refreshToken: data.refresh,
          role: data.user.role,
        );

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] as bool? ?? false,
      data: AuthDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

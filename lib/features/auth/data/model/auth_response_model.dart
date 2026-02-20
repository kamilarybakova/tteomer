import '../../domain/entities/auth_tokens.dart';

class AuthResponseModel extends AuthTokens {
  AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }
}
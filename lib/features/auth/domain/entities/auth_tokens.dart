class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String? role;
  final String? level;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.role,
    this.level,
  });
}

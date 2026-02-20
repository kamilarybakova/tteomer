import '../../domain/entities/auth_tokens.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthTokens tokens;

  AuthSuccess(this.tokens);
}

class AuthRegistered extends AuthState {}

class ResetPasswordEmailSent extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
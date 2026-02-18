import 'exceptions.dart';
import 'failures.dart';

Failure mapExceptionToFailure(Exception e) {
  if (e is NetworkException) return NetworkFailure();
  if (e is ServerException) return ServerFailure(e.message);
  return UnknownFailure();
}

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('No internet connection');
}

class ServerFailure extends Failure {
  ServerFailure(super.msg);
}

class UnknownFailure extends Failure {
  UnknownFailure() : super('Something went wrong');
}

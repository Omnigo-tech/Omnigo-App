abstract class Failure {
  final String message;
  Failure(this.message);
}
class ServerFailures extends Failure {
  ServerFailures(super.message);
}
class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  AuthFailure(super.message);
}

// 원인을 알 수 없거나 기타 예외 상황 발생 시 사용
class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}

// connetivity plus

import 'package:baton/core/error/failure.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseErrorMapper {
  static Failure toFailure(FirebaseException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return AuthFailure('이미 사용 중인 이메일입니다.');
      case 'invalid-credential':
        return AuthFailure("인증 정보가 올바르지 않습니다. 다시 로그인해 주세요.");
      case 'user-disabled':
        return AuthFailure("계정이 비활성화되었습니다.");
      case 'network-request-failed':
        return NetworkFailure("네트워크 연결이 원활하지 않습니다. 연결 상태를 확인해 주세요.");
      case 'cancelled':
        return AuthFailure("로그인이 취소되었습니다.");
      default:
        return ServerFailure(e.message ?? '알 수 없는 오류가 발생했습니다.');
    }
  }
}

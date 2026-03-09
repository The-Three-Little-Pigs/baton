import 'package:baton/core/error/failure.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseErrorMapper {
  static Failure toFailure(FirebaseException e) {
    switch (e.code) {
      // 인증 관련
      case 'account-exists-with-different-credential':
      case 'email-already-in-use':
        return AuthFailure('이미 사용 중인 이메일입니다.');
      case 'invalid-credential':
        return AuthFailure("인증 정보가 올바르지 않습니다. 다시 로그인해 주세요.");
      case 'user-disabled':
        return AuthFailure("계정이 비활성화되었습니다.");
      case 'cancelled':
        return AuthFailure("로그인이 취소되었습니다.");
      case 'invalid-email':
        return AuthFailure('유효하지 않은 이메일 형식입니다.');
      case 'user-not-found':
        return AuthFailure('등록되지 않은 사용자입니다.');
      case 'wrong-password':
        return AuthFailure('비밀번호가 틀렸습니다.');
      case 'weak-password':
        return AuthFailure('비밀번호가 너무 취약합니다.');
      case 'too-many-requests':
        return AuthFailure('너무 많은 시도가 있었습니다. 잠시 후 다시 시도해 주세요.');
      case 'object-not-found':
        return ServerFailure('업로드할 대상을 찾을 수 없습니다.');
      case 'bucket-not-found':
        return ServerFailure('스토리지 설정(버킷)이 잘못되었습니다.');
      case 'quota-exceeded':
        return ServerFailure('저장 공간 용량이 초과되었습니다.');
      case 'unauthenticated':
        return AuthFailure('인증되지 않은 사용자입니다. 다시 로그인해주세요.');
      case 'unauthorized':
        return ServerFailure('파일 접근 권한이 없습니다.');
      case 'retry-limit-exceeded':
        return NetworkFailure('업로드 제한 시간을 초과했습니다. 다시 시도해주세요.');

      // 공통 및 DB 관련
      case 'network-request-failed':
      case 'unavailable':
        return NetworkFailure("네트워크 연결이 원활하지 않습니다.");
      case 'permission-denied':
        return ServerFailure('접근 권한이 없습니다.');
      case 'not-found':
        return ServerFailure('데이터를 찾을 수 없습니다.');
      case 'already-exists':
        return ServerFailure('이미 존재하는 데이터입니다.');
      case 'deadline-exceeded':
        return NetworkFailure('요청 시간이 초과되었습니다.');
      default:
        return ServerFailure('알 수 없는 오류가 발생했습니다.');
    }
  }
}

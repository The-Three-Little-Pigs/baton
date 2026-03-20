import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/login_status.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository/auth_repository.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LoginService {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  LoginService(this._authRepo, this._userRepo);

  // 1. 공통 로그인 로직 (핵심)
  Future<Result<LoginStatus, Failure>> _handleSocialLogin(
    Future<Result<auth.UserCredential, Failure>> Function() socialAuthCall,
  ) async {
    try {
      final authResult = await socialAuthCall();

      if (authResult is Error<auth.UserCredential, Failure>) {
        return Error((authResult).failure);
      }

      final firebaseUser =
          (authResult as Success<auth.UserCredential, Failure>).value.user;
      if (firebaseUser == null) {
        return Error(ServerFailure('사용자 정보를 가져올 수 없습니다.'));
      }

      // Firestore에서 유저 데이터 가져오기
      final userResult = await _userRepo.fetchUserData(firebaseUser.uid);

      if (userResult is Success<User?, Failure>) {
        final existingUser = userResult.value;

        // [수정 포인트] 기존 유저가 있다면 바로 성공 반환
        if (existingUser != null) {
          return Success(ExistingUser(existingUser));
        } else {
          // [수정 포인트] 신규 유저일 때, 우리 앱의 User 엔티티 필수 필드들을 모두 채워줍니다.
          final tempUser = User(
            uid: firebaseUser.uid,
            nickname: '', // [수정] 신규 유저는 항상 닉네임을 비워두어 가입 프로세스를 유도합니다.
            profileUrl: firebaseUser.photoURL ?? '',
            score: 36.5, // 기본 매너 온도 설정
            favorites: {}, // 초기값 빈 리스트
            blockedUsers: {}, // 초기값 빈 리스트
            recentlySearch: {}, // 초기값 빈 리스트
            deletedAt: null,
          );
          return Success(NewUser(tempUser));
        }
      }

      return Error(ServerFailure('데이터베이스 조회 중 오류가 발생했습니다.'));
    } catch (e) {
      return Error(ServerFailure('로그인 처리 중 예기치 못한 오류가 발생했습니다.'));
    }
  }

  Future<Result<LoginStatus, Failure>> signInWithGoogle() =>
      _handleSocialLogin(_authRepo.signInWithGoogle);
  Future<Result<LoginStatus, Failure>> signInWithKakao() =>
      _handleSocialLogin(_authRepo.signInWithKakao);
  Future<Result<LoginStatus, Failure>> signInWithApple() =>
      _handleSocialLogin(_authRepo.signInWithApple);
}

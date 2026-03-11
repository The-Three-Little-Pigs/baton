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
        return Error(authResult.failure);
      }

      final firebaseUser = (authResult as Success).value.user;
      if (firebaseUser == null) {
        return Error(ServerFailure('사용자 정보를 가져올 수 없습니다.'));
      }

      final userResult = await _userRepo.fetchUserData(firebaseUser.uid);

      if (userResult is Success<User?, Failure>) {
        final existingUser = userResult.value;

        if (existingUser != null) {
          return Success(ExistingUser(existingUser));
        } else {
          final tempUser = User(
            uid: firebaseUser.uid,
            profileUrl: firebaseUser.photoURL ?? '',
            nickname: firebaseUser.displayName ?? '새 사용자',
            score: 0.0,
          );
          return Success(NewUser(tempUser));
        }
      }

      return Error(ServerFailure('데이터베이스 조회 중 오류가 발생했습니다.'));
    } catch (e) {
      print("e: $e");
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

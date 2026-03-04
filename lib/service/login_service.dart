import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository/auth_repository.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:baton/models/repositories/repository_impl/auth_repository_impl.dart';
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/legacy.dart';

class UserNotifier extends StateNotifier<User?> {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  UserNotifier(this._authRepo, this._userRepo) : super(null);

  Future<bool> googleLogin() async {
    try {
      // 1. 구글/파이어베이스 인증 시도
      final authResult = await _authRepo.signInWithGoogle();

      if (authResult is Error) {
        state = null;
        print("구글 로그인 인증 실패");
        return false;
      }

      final firebaseUser = (authResult as Success<auth.User, dynamic>).value;

      // 2. DB에 기존 유저 정보가 있는지 먼저 확인
      final userResult = await _userRepo.fetchUserData(firebaseUser.uid);

      if (userResult is Success) {
        final existingUser = (userResult as Success<User?, dynamic>).value;
        if (existingUser != null) {
          state = existingUser;
          print("기존 유저 로그인 성공: ${existingUser.nickname}");
          return true;
        }
      }

      // [CASE B] 신규 유저라면 새로 포장해서 DB에 저장
      final newUser = User(
        uid: firebaseUser.uid,
        profileUrl: firebaseUser.photoURL ?? '',
        nickname: firebaseUser.displayName ?? '새 사용자',
        score: 0.0,
      );

      final createResult = await _userRepo.updateUserData(newUser);
      if (createResult is Success) {
        state = newUser;
        print("신규 유저 가입 및 로그인 성공");
        return true;
      } else {
        state = null;
        print("신규 유저 저장 실패");
        return false;
      }
    } catch (e) {
      state = null;
      print("로그인 프로세스 에러: $e");
      return false;
    }
  }

  Future<bool> kakaoLogin() async {
    try {
      // 1. 카카오 인증 시도
      final authResult = await _authRepo.signInWithKakao();
      if (authResult is Error) {
        state = null;
        print("카카오 인증 실패");
        return false;
      }

      final credential =
          (authResult as Success<auth.OAuthCredential, dynamic>).value;

      final userCredential = await auth.FirebaseAuth.instance
          .signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return false;

      // 2. DB에 기존 유저 정보가 있는지 확인
      final userResult = await _userRepo.fetchUserData(firebaseUser.uid);

      if (userResult is Success) {
        final existingUser = (userResult as Success<User?, dynamic>).value;
        if (existingUser != null) {
          state = existingUser;
          print("카카오 로그인 성공 (기존 유저): ${existingUser.nickname}");
          return true;
        }
      }

      // [CASE B] 신규 유저
      final newUser = User(
        uid: firebaseUser.uid,
        profileUrl: firebaseUser.photoURL ?? '',
        nickname: firebaseUser.displayName ?? '새 사용자',
        score: 0.0,
      );

      final createResult = await _userRepo.updateUserData(newUser);
      if (createResult is Success) {
        state = newUser;
        print("카카오 로그인 성공 (신규 유저)");
        return true;
      } else {
        state = null;
        print("카카오 신규 유저 저장 실패");
        return false;
      }
    } catch (e) {
      state = null;
      print("카카오 로그인 프로세스 에러: $e");
      return false;
    }
  }
}

// 2. 의존성 주입 (Provider 정의)
final loginViewModelProvider = StateNotifierProvider<UserNotifier, User?>((
  ref,
) {
  return UserNotifier(AuthRepositoryImpl(), UserRepositoryImpl());
});

import 'package:baton/core/error/failure.dart';
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

      if (authResult is! Success<auth.User, Failure>) {
        state = null;
        return false;
      }

      final firebaseUser = authResult.value;

      // 2. DB에 기존 유저 정보가 있는지 먼저 확인
      final userResult = await _userRepo.fetchUserData(firebaseUser.uid);

      if (userResult is Success<User?, Failure>) {
        final existingUser = userResult.value;
        if (existingUser != null) {
          state = existingUser;
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
        return true;
      } else {
        state = null;
        return false;
      }
    } catch (e) {
      state = null;
      return false;
    }
  }

  Future<bool> kakaoLogin() async {
    try {
      // 1. 카카오 인증 시도
      final authResult = await _authRepo.signInWithKakao();
      if (authResult is! Success<auth.OAuthCredential, Failure>) {
        state = null;
        return false;
      }

      final credential = authResult.value;

      final userCredential = await auth.FirebaseAuth.instance
          .signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return false;

      // 2. DB에 기존 유저 정보가 있는지 확인
      final userResult = await _userRepo.fetchUserData(firebaseUser.uid);

      if (userResult is Success<User?, Failure>) {
        final existingUser = userResult.value;
        if (existingUser != null) {
          state = existingUser;
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
        return true;
      } else {
        state = null;
        return false;
      }
    } catch (e) {
      state = null;
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

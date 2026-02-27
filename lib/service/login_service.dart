import 'package:baton/models/entities/user_entity.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:baton/models/repositories/repository_impl/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserNotifier extends StateNotifier<UserEntity?> {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  // 생성자에서 두 레포지토리를 주입받습니다.
  UserNotifier(this._authRepo, this._userRepo) : super(null);

  Future<void> googleLogin() async {
    try {
      // 1. 구글/파이어베이스 인증 시도
      final firebaseUser = await _authRepo.signInWithGoogle();
      if (firebaseUser == null) return;

      // 2. [추가] DB에 기존 유저 정보가 있는지 먼저 확인
      UserEntity? existingUser = await _userRepo.fetchUserData(
        firebaseUser.uid,
      );

      if (existingUser != null) {
        // [CASE A] 기존 유저라면 DB 정보를 그대로 상태에 반영
        state = existingUser;
        print("기존 유저 로그인 성공: ${existingUser.nickname}");
      } else {
        // [CASE B] 신규 유저라면 새로 포장해서 DB에 저장
        final newUser = UserEntity(
          uid: firebaseUser.uid,
          profileUrl: firebaseUser.photoURL ?? '',
          nickname: firebaseUser.displayName ?? '새 사용자',
          score: 0.0,
        );

        await _userRepo.updateUserData(newUser); // Firestore에 새 문서 생성
        state = newUser;
        print("신규 유저 가입 및 로그인 성공");
      }
    } catch (e) {
      state = null;
      print("로그인 프로세스 에러: $e");
    }
  }

  Future<void> kakaoLogin() async {
    try {
      // 1. 카카오/파이어베이스 인증 시도
      final credential = await _authRepo.signInWithKakao();
      if (credential == null) return;

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return;

      // 2. DB에 기존 유저 정보가 있는지 확인
      UserEntity? existingUser = await _userRepo.fetchUserData(
        firebaseUser.uid,
      );

      if (existingUser != null) {
        state = existingUser;
        print("카카오 로그인 성공 (기존 유저): ${existingUser.nickname}");
      } else {
        final newUser = UserEntity(
          uid: firebaseUser.uid,
          profileUrl: firebaseUser.photoURL ?? '',
          nickname: firebaseUser.displayName ?? '새 사용자',
          score: 0.0,
        );

        await _userRepo.updateUserData(newUser);
        state = newUser;
        print("카카오 로그인 성공 (신규 유저)");
      }
    } catch (e) {
      state = null;
      print("카카오 로그인 프로세스 에러: $e");
    }
  }
}

// 2. 의존성 주입 (Provider 정의)
final loginViewModelProvider = StateNotifierProvider<UserNotifier, UserEntity?>(
  (ref) {
    return UserNotifier(AuthRepository(), UserRepository());
  },
);

import 'dart:io';

import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/utils/auth_helper.dart';
import 'package:baton/models/repositories/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' hide User;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<Result<UserCredential, Failure>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Error(AuthFailure('Google 로그인 정보가 없습니다.'));
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return Error(AuthFailure('Firebase 사용자 정보를 가져오지 못했습니다.'));
      }

      return Success(userCredential);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('처리 중 예기치 못한 오류가 발생했습니다.'));
    }
  }

  @override
  Future<Result<UserCredential, Failure>> signInWithKakao() async {
    try {
      final token = await isKakaoTalkInstalled()
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      if (token.idToken == null) {
        return Error(AuthFailure('카카오 로그인 정보가 없습니다.'));
      }

      final credential = OAuthProvider(
        'oidc.kakao',
      ).credential(idToken: token.idToken, accessToken: token.accessToken);

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return Error(AuthFailure('Firebase 사용자 정보를 가져오지 못했습니다.'));
      }

      return Success(userCredential);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('처리 중 예기치 못한 오류가 발생했습니다.'));
    }
  }

  @override
  Future<Result<UserCredential, Failure>> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final hashNonce = sha256Hash(rawNonce);

      AuthorizationCredentialAppleID appleCredential;

      if (Platform.isIOS) {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: hashNonce,
        );
      } else {
        appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: 'com.threepigs.baton.service',
            redirectUri: Uri.parse(
              'https://baton-18034.firebaseapp.com/__/auth/handler',
            ),
          ),
          nonce: hashNonce,
        );
      }

      final AuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return Error(AuthFailure('Firebase 사용자 정보를 가져오지 못했습니다.'));
      }

      return Success(userCredential);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return Error(AuthFailure('로그인이 취소되었습니다.'));
      }
      return Error(ServerFailure('애플 인증 오류'));
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('처리 중 예기치 못한 오류가 발생했습니다.'));
    }
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      try {
        await UserApi.instance.logout();
      } catch (_) {}

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('처리 중 예기치 못한 오류가 발생했습니다.'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Error(AuthFailure('인증 정보가 없습니다.'));

      await user.delete(); // 파이어베이스 계정 삭제

      // 소셜 로그인 세션 정리
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      try {
        await UserApi.instance.logout();
      } catch (_) {}

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

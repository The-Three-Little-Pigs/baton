import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<Result<UserCredential, Failure>> signInWithGoogle();
  Future<Result<UserCredential, Failure>> signInWithKakao();
  Future<Result<UserCredential, Failure>> signInWithApple();
  Future<Result<void, Failure>> signOut();
  Future<Result<void, Failure>> deleteAccount();
}

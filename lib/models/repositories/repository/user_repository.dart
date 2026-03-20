import 'dart:io';

import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';

abstract class UserRepository {
  Future<Result<User?, Failure>> fetchUserData(String uid);
  Future<Result<void, Failure>> updateUserData(User user);
  Stream<Result<User?, Failure>> watchUserData(String uid);

  Future<Result<void, Failure>> userCreate(User user);
  Future<Result<void, Failure>> updateFCMToken(String uid, String token);
  Future<Result<bool, Failure>> checkNicknameDuplicate(String nickname);
  Future<Result<String, Failure>> uploadProfileImage(
    String uid,
    File imageFile,
  );
  Future<Result<void, Failure>> deleteUserData(String uid);
  Future<Result<void, Failure>> markUserAsDeleted(String uid);
  Future<Result<void, Failure>> withdrawAccount();
  Future<Result<void, Failure>> addRecentlySearch(String uid, String keyword);
  Future<Result<void, Failure>> removeRecentlySearch(
    String uid,
    String keyword,
  );
  Future<Result<void, Failure>> clearRecentlySearch(String uid);
 
}

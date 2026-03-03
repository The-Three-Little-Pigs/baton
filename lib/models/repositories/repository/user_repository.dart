import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';

abstract class UserRepository {
  Future<Result<User?, Failure>> fetchUserData(String uid);
  Future<Result<void, Failure>> updateUserData(User user);
  Future<Result<void, Failure>> userCreate(User user);
  Future<Result<void, Failure>> updateFCMToken(String uid, String token);
}

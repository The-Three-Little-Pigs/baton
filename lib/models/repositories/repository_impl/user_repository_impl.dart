import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<User?, Failure>> fetchUserData(String uid) async {
    try {
      final snapshot = await _firestore.collection("user").doc(uid).get();
      final data = snapshot.data();

      if (data == null) {
        return Success(null);
      }

      return Success(User.fromJson(data));
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> updateUserData(User user) async {
    try {
      await _firestore
          .collection("user")
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> userCreate(User user) async {
    try {
      await _firestore.collection("user").doc(user.uid).set(user.toJson());
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> updateFCMToken(String uid, String token) async {
    try {
      await _firestore.collection("user").doc(uid).update({'fcmToken': token});
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }
}

import 'dart:io';

import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  @override
  Future<Result<bool, Failure>> checkNicknameDuplicate(String nickname) async {
    try {
      final query = await _firestore
          .collection("user")
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();
      // 문서가 존재하면 중복 (true = 중복)
      return Success(query.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  Future<Result<String, Failure>> uploadProfileImage(
    String uid,
    File imageFile,
  ) async {
    try {
      // user_profiles 폴더 안에 유저 UID를 파일명으로 저장
      final ref = _storage.ref().child('user_profiles').child('$uid.jpg');

      // 파일 업로드 실행
      await ref.putFile(imageFile);

      // 업로드된 파일의 공개 URL 가져오기
      final url = await ref.getDownloadURL();

      return Success(url);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      // 2. 그 외 모든 에러 (파일 경로 오류, 메모리 부족 등)
      // Failure는 추상 클래스이므로, 미리 만들어둔 하위 클래스(ServerFailure 등)를 사용합니다.
      return Error(ServerFailure(e.toString()));
    }
  }
}

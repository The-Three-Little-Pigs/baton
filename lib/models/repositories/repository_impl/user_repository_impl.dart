import 'dart:io';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_storage/firebase_storage.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 💡 컬렉션
  static const String _collectionPath = "user";

  @override
  Future<Result<User?, Failure>> fetchUserData(String uid) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .get();
      final data = snapshot.data();

      if (data == null) {
        return const Success(null);
      }

      return Success(User.fromJson(data));
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> updateUserData(User user) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Stream<Result<User?, Failure>> watchUserData(String uid) {
    return _firestore.collection(_collectionPath).doc(uid).snapshots().map((
      snapshot,
    ) {
      try {
        final data = snapshot.data();
        if (data == null) return const Success(null);
        return Success(User.fromJson(data));
      } catch (e) {
        return Error(ServerFailure(e.toString()));
      }
    });
  }

  @override
  Future<Result<void, Failure>> userCreate(User user) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(user.uid)
          .set(user.toJson());
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> updateFCMToken(String uid, String token) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update({
        'fcmToken': token,
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<bool, Failure>> checkNicknameDuplicate(String nickname) async {
    try {
      final query = await _firestore
          .collection(_collectionPath)
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();
      return Success(query.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<String, Failure>> uploadProfileImage(
    String uid,
    File imageFile,
  ) async {
    try {
      final ref = _storage.ref().child('user_profiles').child('$uid.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return Success(url);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> deleteUserData(String uid) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).delete();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> markUserAsDeleted(String uid) async {
    try {
      final docRef = _firestore.collection(_collectionPath).doc(uid);
      final doc = await docRef.get();
      if (!doc.exists) return Error(ServerFailure('사용자 정보를 찾을 수 없습니다.'));

      final currentNickname = doc.data()?['nickname'] ?? 'user';
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await docRef.update({
        'isDeleted': true,
        'deleted_at': FieldValue.serverTimestamp(),
        // 닉네임을 해방하기 위해 뒤에 타임스탬프를 붙입니다.
        'nickname': '${currentNickname}_deleted_$timestamp',
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('회원 탈퇴 처리 중 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> withdrawAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return Error(AuthFailure('인증 정보가 없습니다. 다시 로그인해주세요.'));
      }

      final uid = user.uid;

      // 1. Firestore 데이터 삭제
      await _firestore.collection(_collectionPath).doc(uid).delete();

      // 2. Auth 계정 삭제 및 세션 정리
      // Note: 실제 서비스에서는 AuthRepository.deleteAccount()를 호출하는 것이 더 완벽합니다.
      // 여기서는 DB 데이터 삭제에 집중합니다.
      await user.delete();
      await FirebaseAuth.instance.signOut();

      return const Success(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return Error(AuthFailure('보안을 위해 다시 로그인한 후 탈퇴를 진행해주세요.'));
      }
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('회원 탈퇴 처리 중 오류가 발생했습니다.'));
    }
  }

  @override
  Future<Result<void, Failure>> addBlockedBy(
    String targetUid,
    String blockerUid,
  ) async {
    try {
      final docRef = _firestore.collection(_collectionPath).doc(targetUid);
      final doc = await docRef.get();

      if (!doc.exists) return Error(ServerFailure('사용자 정보를 찾을 수 없습니다.'));

      final data = doc.data();
      final double currentScore = (data?['score'] ?? 5.0).toDouble();
      
      // 🔥 점수 계산: 2.0씩 차감하되, 최저 2.0점 유지
      final double newScore = (currentScore - 2.0).clamp(2.0, 5.0);

      await docRef.update({
        'blockedBy': FieldValue.arrayUnion([blockerUid]),
        'score': newScore,
      });
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure('차단 처리 및 감점 실패: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> removeBlockedBy(
    String targetUid,
    String blockerUid,
  ) async {
    try {
      await _firestore.collection(_collectionPath).doc(targetUid).update({
        'blockedBy': FieldValue.arrayRemove([blockerUid]),
      });
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure('차단 해제 실패: $e'));
    }
  }
}

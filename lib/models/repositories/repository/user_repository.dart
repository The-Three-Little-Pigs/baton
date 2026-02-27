import 'package:baton/models/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<UserEntity?> fetchUserData(String uid) async {
    try {
      final snapshot = await _firestore.collection("user").doc(uid).get();
      final data = snapshot.data();

      if (data == null) return null;

      return UserEntity.fromJson(data);
    } catch (e) {
      print("유저 데이터 조회 실패: $e");
      return null;
    }
  }

  Future<void> updateUserData(UserEntity user) async {
    try {
      await _firestore
          .collection("user")
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      print("유저 데이터 업데이트 실패: $e");
    }
  }

  // 3. 신규 유저 생성 (Initial Create)
  Future<void> userCreate(UserEntity user) async {
    try {
      await _firestore.collection("user").doc(user.uid).set(user.toJson());
    } catch (e) {
      print("유저 생성 실패: $e");
    }
  }
}

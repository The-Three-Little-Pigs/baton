import 'package:baton/models/entities/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatListStreamProvider = StreamProvider<List<Chatroom>>((ref) {
  final firestore = FirebaseFirestore.instance;
  return firestore
      .collection('chatrooms')
      .orderBy('updatedAt', descending: true)
      // 리미트 적용
      .limit(20)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Chatroom.fromJson({'roomId': doc.id, ...doc.data()});
        }).toList();
      });
});

// lib/models/repositories/repository_impl/chat_repository_impl.dart
import 'dart:io';

import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/message.dart';
import 'package:baton/models/repositories/repository/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ChatRepositoryImpl(this._firestore, this._storage);

  @override
  Stream<List<Chatroom>> watchChatRooms(String myUserId) {
    return _firestore
        .collection('chatrooms')
        .where('participants', arrayContains: myUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Chatroom.fromFirestore(doc)).toList(),
        );
  }

  @override
  Stream<List<Message>> watchMessages(String roomId) {
    return _firestore
        .collection('chatrooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList(),
        );
  }

  @override
  Stream<Chatroom?> watchChatRoom(String roomId) {
    return _firestore.collection('chatrooms').doc(roomId).snapshots().map((
      doc,
    ) {
      if (!doc.exists) return null;
      return Chatroom.fromFirestore(doc);
    });
  }

  @override
  Future<Result<void, Failure>> markAsRead(
    String roomId,
    String myUserId,
  ) async {
    try {
      final chatroomDocRef = _firestore.collection('chatrooms').doc(roomId);
      await chatroomDocRef.update({
        'unreadCounts.$myUserId': 0,
        'lastReadAt.$myUserId': FieldValue.serverTimestamp(),
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('읽음 처리 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> sendTextMessage(
    String roomId,
    String myUserId,
    String targetUserId,
    String content,
    bool hasRoom,
  ) async {
    if (content.trim().isEmpty) return const Success(null);

    try {
      final chatroomDocRef = _firestore.collection('chatrooms').doc(roomId);
      final messageDocRef = chatroomDocRef.collection('messages').doc();

      final messageData = {
        'id': messageDocRef.id,
        'roomId': roomId,
        'senderId': myUserId,
        'content': content.trim(),
        'type': 'text',
        'createdAt': FieldValue.serverTimestamp(),
      };

      final batch = _firestore.batch();
      batch.set(messageDocRef, messageData);

      _updateChatRoomBatch(
        batch,
        chatroomDocRef,
        roomId,
        targetUserId,
        myUserId,
        content.trim(),
        hasRoom,
      );

      await batch.commit();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('텍스트 전송 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> sendImageMessage(
    String roomId,
    String myUserId,
    String targetUserId,
    File imageFile,
    bool hasRoom,
  ) async {
    final storageRef = _storage
        .ref()
        .child('chat_images')
        .child(roomId)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      // 1. Storage 업로드
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      try {
        // 2. DB 저장 (트랜잭션/배치)
        final chatroomDocRef = _firestore.collection('chatrooms').doc(roomId);
        final messageDocRef = chatroomDocRef.collection('messages').doc();

        final messageData = {
          'id': messageDocRef.id,
          'roomId': roomId,
          'senderId': myUserId,
          'content': imageUrl,
          'type': 'image',
          'createdAt': FieldValue.serverTimestamp(),
        };

        final batch = _firestore.batch();
        batch.set(messageDocRef, messageData);

        _updateChatRoomBatch(
          batch,
          chatroomDocRef,
          roomId,
          targetUserId,
          myUserId,
          '사진',
          hasRoom,
        );

        await batch.commit();
        return const Success(null);
      } on FirebaseException catch (firestoreError) {
        // DB 저장 실패 시 Storage 업로드 파일 삭제 (비용 누수 방지 롤백)
        await storageRef.delete();
        return Error(FirebaseErrorMapper.toFailure(firestoreError));
      } catch (firestoreError) {
        // DB 저장 실패 시 Storage 업로드 파일 삭제 (비용 누수 방지 롤백)
        await storageRef.delete();
        return Error(
          ServerFailure('이미지 DB 기록 실패 (롤백됨): ${firestoreError.toString()}'),
        );
      }
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('이미지 서버 업로드 실패: ${e.toString()}'));
    }
  }

  /// 공통 채팅방 업데이트 로직 (중복 제거)
  void _updateChatRoomBatch(
    WriteBatch batch,
    DocumentReference chatroomDocRef,
    String roomId,
    String targetUserId,
    String myUserId,
    String lastMessage,
    bool hasRoom,
  ) {
    if (!hasRoom) {
      batch.set(chatroomDocRef, {
        'roomId': roomId,
        'lastMessage': lastMessage,
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts': {targetUserId: FieldValue.increment(1), myUserId: 0},
        'participants': FieldValue.arrayUnion([myUserId, targetUserId]),
        'lastReadAt': {
          myUserId: FieldValue.serverTimestamp(),
          targetUserId: Timestamp(0, 0),
        },
        'prdImageUrl': '', // 추후 상품 이미지 URL 로직 연동
      });
    } else {
      batch.update(chatroomDocRef, {
        'lastMessage': lastMessage,
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts.$targetUserId': FieldValue.increment(1),
        'unreadCounts.$myUserId': 0,
        'lastReadAt.$myUserId': FieldValue.serverTimestamp(),
      });
    }
  }
}

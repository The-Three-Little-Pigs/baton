// lib/models/repositories/repository_impl/chat_repository_impl.dart
import 'dart:convert';
import 'dart:io';

import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/utils/logger.dart';
import 'package:baton/models/entities/appointment_data.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/message.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/models/repositories/repository/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  static const String _collectionPath = 'chatrooms';

  ChatRepositoryImpl(this._firestore, this._storage);

  @override
  Stream<List<Chatroom>> watchChatRooms(String myUserId) {
    return _firestore
        .collection(_collectionPath)
        .where('participants', arrayContains: myUserId)
        // .where('deletedByUids', arrayContains: myUserId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Chatroom.fromFirestore(doc))
              .where((room) => !room.deletedByUids.contains(myUserId))
              .toList(),
        );
  }

  @override
  Stream<List<Message>> watchMessages(String roomId) {
    return _firestore
        .collection(_collectionPath)
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
    return _firestore.collection(_collectionPath).doc(roomId).snapshots().map((
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
      final chatroomDocRef = _firestore.collection(_collectionPath).doc(roomId);
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
      final chatroomDocRef = _firestore.collection(_collectionPath).doc(roomId);
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
        final chatroomDocRef = _firestore
            .collection(_collectionPath)
            .doc(roomId);
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

  @override
  Future<Result<bool, Failure>> leaveRoom(String roomId, String myUid) async {
    try {
      final roomRef = _firestore.collection(_collectionPath).doc(roomId);
      // 1. deletedByUids에 내 UID 추가 (중복 없이)
      await roomRef.update({
        'deletedByUids': FieldValue.arrayUnion([myUid]),
      });
      // 2. 방 정보를 다시 가져와서 참여자 전원 퇴장 여부 확인
      final snapshot = await roomRef.get();
      final participants = List<String>.from(
        snapshot.data()?['participants'] ?? [],
      );
      final deletedByUids = List<String>.from(
        snapshot.data()?['deletedByUids'] ?? [],
      );
      // 3. 만약 참여자 전원이 나갔다면? 실제 데이터 완전 삭제
      if (deletedByUids.length >= participants.length) {
        // (1) 스토리지 폴더 삭제 (listAll 방식)
        await _deleteStorageFolder(roomId);

        // (2) 메시지 컬렉션 삭제
        // TODO: 메시지 컬렉션 삭제/ 잘 작동하는지 확인 필요
        // await _deleteAllMessages(roomId);

        // (3) 채팅방 문서 삭제
        await roomRef.delete();

        logger.i('Chat: 채팅방($roomId) 데이터가 완전히 삭제되었습니다.');
      }
      return const Success(true);
    } catch (e) {
      return Error(UnknownFailure('방 나가기 처리 중 오류 발생: $e'));
    }
  }

  Future<void> _deleteStorageFolder(String roomId) async {
    final folderRef = _storage.ref().child('chat_images').child(roomId);
    final ListResult result = await folderRef.listAll();

    final deleteTasks = result.items.map((fileRef) => fileRef.delete());
    await Future.wait(deleteTasks);
  }

  @override
  Future<Result<void, Failure>> sendAppointmentMessage({
    required String roomId,
    required String myUserId,
    required String targetUserId,
    required AppointmentData data,
    required bool hasRoom,
    AppointmentData? previousData,
  }) async {
    try {
      final chatroomDocRef = _firestore.collection(_collectionPath).doc(roomId);
      final messageDocRef = chatroomDocRef.collection('messages').doc();

      // 🔥 [핵심 버그 수정] Firestore에서 자동 생성된 문서 ID를 데이터에 채워줍니다.
      final actualData = data.copyWith(appointmentId: messageDocRef.id);

      final batch = _firestore.batch();
      batch.set(messageDocRef, {
        'id': messageDocRef.id,
        'roomId': roomId,
        'senderId': myUserId,
        'content': jsonEncode(actualData.toJson()),
        'type': 'appointment',
        'createdAt': FieldValue.serverTimestamp(),
      });
      final updateData = {
        'lastMessage': '약속',
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts.$targetUserId': FieldValue.increment(1),
        'unreadCounts.$myUserId': 0,
        'appointmentStatus': actualData.status.label,
        'appointmentDateTime': Timestamp.fromDate(actualData.dateTime),
        'activeAppointmentId':
            actualData.appointmentId, // 이제 빈 문자열이 아니라 진짜 ID가 들어갑니다!
        'confirmedCompleteUids': <String>[], // 새 약속 시 확정 상태 초기화
        'confirmedAt': null, // 확정 시간 초기화
      };
      // 방이 처음 생길 때의 초기 데이터 포함( 생략 가능하나 안전을 위해)
      if (!hasRoom) {
        batch.set(chatroomDocRef, {
          ...updateData,
          'roomId': roomId,
          'participants': [myUserId, targetUserId],
          'lastReadAt': {
            myUserId: FieldValue.serverTimestamp(),
            targetUserId: Timestamp(0, 0),
          },
          'deletedByUids': [],
          'unreadCounts': {myUserId: 0, targetUserId: 1},
          'prdImageUrl': '',
        }, SetOptions(merge: true));
      } else {
        batch.update(chatroomDocRef, updateData);
      }

      if (data.previousMessageId != null && previousData != null) {
        final prevMsgRef = chatroomDocRef
            .collection('messages')
            .doc(data.previousMessageId);
        // 🔥 [버그 수정] 새 약속(data)이 아닌, 기존 약속(previousData) 정보를 사용하여 상태만 변경합니다.
        // 이렇게 해야 이전 카드의 시간/장소 정보가 보존됩니다.
        final replaceData = previousData.copyWith(
          status: AppointmentStatus.replaced,
        );
        batch.update(prevMsgRef, {'content': jsonEncode(replaceData.toJson())});
      }
      await batch.commit();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(UnknownFailure('약속 전송 실패'));
    }
  }

  @override
  Future<Result<void, Failure>> updateAppointmentStatus({
    required String roomId,
    required String messageId,
    required AppointmentStatus newStatus,
  }) async {
    try {
      final msgRef = _firestore
          .collection(_collectionPath)
          .doc(roomId)
          .collection('messages')
          .doc(messageId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(msgRef);
        if (!snapshot.exists) return;
        final content = jsonDecode(snapshot.get('content') as String);
        final data = AppointmentData.fromJson(content);
        final updatedData = data.copyWith(status: newStatus);

        transaction.update(msgRef, {
          'content': jsonEncode(updatedData.toJson()),
        });

        // 채팅방 정보 업데이트 (확정/취소/완료 등 상태 변화 반영)
        final chatroomRef = _firestore.collection(_collectionPath).doc(roomId);
        if (newStatus == AppointmentStatus.confirmed) {
          transaction.update(chatroomRef, {
            'appointmentStatus': AppointmentStatus.confirmed.label,
            'activeAppointmentId': messageId,
          });
        } else if (newStatus == AppointmentStatus.cancelled) {
          transaction.update(chatroomRef, {
            'appointmentStatus': AppointmentStatus.cancelled.label,
            'activeAppointmentId': null, // 취소 시 활성화된 약속 ID 제거
            'confirmedCompleteUids': <String>[], // 취소 시 확정 상태 초기화
            'confirmedAt': null, // 취소 시 확정 시간 초기화
          });
        } else if (newStatus == AppointmentStatus.completed) {
          transaction.update(chatroomRef, {
            'appointmentStatus': AppointmentStatus.completed.label,
            'activeAppointmentId': null,
          });
        }
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(UnknownFailure('약속 상태 변경 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> updatePostStatus({
    required String postId,
    required ProductStatus newStatus,
    String? buyerId,
  }) async {
    try {
      final Map<String, dynamic> updateData = {'status': newStatus.label};

      // 💡 예약/판매 시점에 구매자 정보를 함께 업데이트
      if (buyerId != null) {
        updateData['buyer_id'] = buyerId;
      }

      await _firestore.collection('posts').doc(postId).update(updateData);
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(UnknownFailure('게시글 상태 변경 실패: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> confirmTransactionManually({
    required String roomId,
    required String postId,
    required String myUserId,
  }) async {
    final chatroomRef = _firestore.collection(_collectionPath).doc(roomId);
    try {
      // 1. [핵심] await를 붙이지 않으면 트랜잭션이 끝나기도 전에 Success가 반환되는 타이밍 에러가 발생합니다.
      await _firestore.runTransaction((transaction) async {
        // ==========================================
        // [READ 시작] 모든 읽기 작업을 먼저 수행합니다
        // ==========================================
        final roomSnapshot = await transaction.get(chatroomRef);
        if (!roomSnapshot.exists) return;
        final roomData = roomSnapshot.data()!;

        final activeAppointmentId = roomData['activeAppointmentId'] as String?;
        if (activeAppointmentId == null) return;

        final postRef = _firestore.collection('posts').doc(postId);
        final postSnapshot = await transaction.get(postRef);
        if (!postSnapshot.exists) return;
        final postData = postSnapshot.data()!;
        final String authorId =
            postData['author_id'] ?? postData['authorId'] ?? "";

        final msgRef = chatroomRef
            .collection('messages')
            .doc(activeAppointmentId);
        final msgSnapshot = await transaction.get(msgRef);

        // ==========================================
        // [WRITE 시작] 판단 후 데이터를 업데이트합니다
        // ==========================================
        var currentUids = List<String>.from(
          roomData['confirmedCompleteUids'] ?? [],
        );

        bool isListUpdated = false;
        if (!currentUids.contains(myUserId)) {
          currentUids.add(myUserId);
          isListUpdated = true;
        }

        if (currentUids.length >= 2) {
          // 채팅방(chatroomRef) 한 번에 업데이트

          transaction.update(chatroomRef, {
            'confirmedCompleteUids': currentUids,
            'activeAppointmentId': null,
            'appointmentStatus': AppointmentStatus.completed.label,
            'confirmedAt': FieldValue.serverTimestamp(),
          });

          // 메시지(msgRef) 업데이트
          if (msgSnapshot.exists) {
            final content = jsonDecode(msgSnapshot.get('content') as String);
            final data = AppointmentData.fromJson(content);
            final updatedData = data.copyWith(
              status: AppointmentStatus.completed,
            );
            transaction.update(msgRef, {
              'content': jsonEncode(updatedData.toJson()),
            });
          }

          // 게시글(postRef) 업데이트
          if (postId.isNotEmpty) {
            final participants = List<String>.from(
              roomData['participants'] ?? [],
            );
            final buyerId = participants.firstWhere(
              (id) => id != authorId,
              orElse: () => "",
            );
            transaction.update(_firestore.collection('posts').doc(postId), {
              'status': ProductStatus.sold.label,
              'buyer_id': buyerId,
            });
          }
        } else {
          // 쌍방 확정이 아니라면 내 ID만 추가
          if (isListUpdated) {
            transaction.update(chatroomRef, {
              'confirmedCompleteUids': currentUids,
            });
          }
        }
      });
      return const Success(null);
    } catch (e) {
      logger.e('수동 거래 확정 중 에러: $e');
      return Error(UnknownFailure('거래 확정 중 오류가 발생했습니다.'));
    }
  }
}

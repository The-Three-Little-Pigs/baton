import 'dart:io';

import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/message.dart';
import 'package:baton/notifier/test/test_auth_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatMessagesStreamProvider = StreamProvider.family<List<Message>, String>(
  (ref, roomId) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('chatrooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Message.fromFirestore(doc);
          }).toList();
        });
  },
);

final chatRoomStreamProvider = StreamProvider.family<Chatroom?, String>((
  ref,
  roomId,
) {
  final firestore = FirebaseFirestore.instance;
  return firestore.collection('chatrooms').doc(roomId).snapshots().map((doc) {
    if (!doc.exists) return null;
    return Chatroom.fromFirestore(doc);
  });
});

final chatActionProvider = Provider((ref) {
  return ChatAction(FirebaseFirestore.instance);
});

class ChatAction {
  final FirebaseFirestore _firestore;
  ChatAction(this._firestore);

  Future<void> markAsRead(String roomId, String myUserId) async {
    final chatroomDocRef = _firestore.collection('chatrooms').doc(roomId);
    await chatroomDocRef.update({
      'unreadCounts.$myUserId': 0,
      'lastReadAt.$myUserId': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendMessage(
    String roomId,
    String myUserId,
    String targetUserId,
    String content,
    bool hasRoom,
  ) async {
    if (content.trim().isEmpty) return;
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
    if (!hasRoom) {
      batch.set(chatroomDocRef, {
        'roomId': roomId,
        'lastMessage': content.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts': {targetUserId: FieldValue.increment(1), myUserId: 0},
        'participants': FieldValue.arrayUnion([myUserId, targetUserId]),
        'lastReadAt': {
          myUserId: FieldValue.serverTimestamp(),
          targetUserId: Timestamp(0, 0),
        },
        'prdImageUrl': '',
      });
    } else {
      batch.update(chatroomDocRef, {
        'lastMessage': content.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts.$targetUserId': FieldValue.increment(1),
        'unreadCounts.$myUserId': 0,
        'lastReadAt.$myUserId': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> sendImageMessage(
    String roomId,
    String myUserId,
    String targetUserId,
    File imageFile,
    bool hasRoom,
  ) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child(roomId)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    final UploadTask = await storageRef.putFile(imageFile);
    final imageUrl = await UploadTask.ref.getDownloadURL();

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

    if (!hasRoom) {
      batch.set(chatroomDocRef, {
        'roomId': roomId,
        'lastMessage': '사진',
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts': {targetUserId: FieldValue.increment(1), myUserId: 0},
        'participants': FieldValue.arrayUnion([myUserId, targetUserId]),
        'lastReadAt': {
          myUserId: FieldValue.serverTimestamp(),
          targetUserId: Timestamp(0, 0),
        },
        'prdImageUrl': '',
      });
    } else {
      batch.update(chatroomDocRef, {
        'lastMessage': '사진',
        'updatedAt': FieldValue.serverTimestamp(),
        'unreadCounts.$targetUserId': FieldValue.increment(1),
        'unreadCounts.$myUserId': 0,
        'lastReadAt.$myUserId': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}

final chatMessageUiModelProvider =
    Provider.family<AsyncValue<List<ChatMessageUiModel>>, String>((
      ref,
      roomId,
    ) {
      final messagesAsync = ref.watch(chatMessagesStreamProvider(roomId));
      final chatRoomAsync = ref.watch(chatRoomStreamProvider(roomId));
      //TODO: 테스트용 임시 구매자 아이디
      final myUserId = ref.watch(testAuthNotifierProvider);
      return messagesAsync.whenData((messages) {
        final chatroom = chatRoomAsync.value;
        final targetUserId =
            chatroom?.participants.firstWhere(
              (id) => id != myUserId,
              orElse: () => '',
            ) ??
            '';
        final targetLastRead = chatroom?.lastReadAt[targetUserId];
        return messages.map((msg) {
          bool isRead = false;
          if (targetLastRead != null) {
            isRead =
                msg.createdAt.isBefore(targetLastRead) ||
                msg.createdAt.isAtSameMomentAs(targetLastRead);
          }
          return ChatMessageUiModel(message: msg, isReadByTarget: isRead);
        }).toList();
      });
    });

class ChatMessageUiModel {
  final Message message;
  final bool isReadByTarget;

  ChatMessageUiModel({required this.message, required this.isReadByTarget});
}

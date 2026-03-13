import 'dart:core' hide Error;
import 'dart:io';

import 'package:baton/core/di/repository/chat_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/message.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_detail_notifier.g.dart';

@riverpod
class ChatDetailNotifier extends _$ChatDetailNotifier {
  late final String _myUserId;

  @override
  Stream<List<Message>> build(String roomId) {
    _myUserId = ref.watch(userProvider).value?.uid ?? '';
    final repository = ref.watch(chatRepositoryProvider);

    return repository.watchMessages(roomId);
  }

  /// 읽음 처리 로직
  Future<void> markAsRead(String roomId) async {
    final repository = ref.read(chatRepositoryProvider); // 액션(함수) 안에서는 read 사용

    final result = await repository.markAsRead(roomId, _myUserId);
    switch (result) {
      case Success():
        break; // 성공 시는 조용히 넘어감
      case Error(:final failure):
        print('읽음 처리 실패: ${failure.message}');
    }
  }

  /// 텍스트 메시지 전송 (에러 발생 시 UI용 문자열 리턴)
  Future<String?> sendTextMessage(
    String roomId,
    String targetUserId,
    String content,
    bool hasRoom,
  ) async {
    final repository = ref.read(chatRepositoryProvider);

    final result = await repository.sendTextMessage(
      roomId,
      _myUserId,
      targetUserId,
      content,
      hasRoom,
    );
    return switch (result) {
      Success() => null,
      Error(:final failure) => failure.message,
    };
  }

  /// 이미지 메시지 전송
  Future<String?> sendImageMessage(
    String roomId,
    String targetUserId,
    File imageFile,
    bool hasRoom,
  ) async {
    final repository = ref.read(chatRepositoryProvider);

    final result = await repository.sendImageMessage(
      roomId,
      _myUserId,
      targetUserId,
      imageFile,
      hasRoom,
    );
    return switch (result) {
      Success() => null,
      Error(:final failure) => failure.message,
    };
  }
}

@riverpod
Stream<Chatroom?> chatRoomStream(Ref ref, String roomId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchChatRoom(roomId);
}

class ChatMessageUiModel {
  final Message message;
  final bool isReadByTarget;

  ChatMessageUiModel({required this.message, required this.isReadByTarget});
}

@riverpod
AsyncValue<List<ChatMessageUiModel>> chatMessageUiModel(
  Ref ref,
  String roomId,
) {
  final messagesAsync = ref.watch(chatDetailProvider(roomId));
  final chatRoomAsync = ref.watch(chatRoomStreamProvider(roomId));
  final myUserId = ref.watch(userProvider).value?.uid ?? '';

  // Debugging logs to track exactly why it might be stuck in loading
  print(
    'chatMessageUiModelProvider ($roomId): messagesAsync=$messagesAsync, chatRoomAsync=$chatRoomAsync',
  );

  return messagesAsync.whenData((messages) {
    print('messages count: ${messages.length}');
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
}

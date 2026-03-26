import 'dart:core' hide Error;
import 'dart:io';

import 'package:baton/core/di/repository/chat_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/appointment_data.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/message.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_detail_notifier.g.dart';

@riverpod
class ChatDetailNotifier extends _$ChatDetailNotifier {
  late String _myUserId;

  @override
  Stream<List<Message>> build(String roomId) {
    _myUserId = ref.watch(userProvider).value?.uid ?? '';
    final repository = ref.watch(chatRepositoryProvider);

    return repository.watchMessages(roomId);
  }

  /// 읽음 처리 로직
  Future<void> markAsRead(String roomId) async {
    final repository = ref.read(chatRepositoryProvider);

    final result = await repository.markAsRead(roomId, _myUserId);
    switch (result) {
      case Success():
        break;
      case Error(:final failure):
        debugPrint('읽음 처리 실패: ${failure.message}');
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

  // 약속카드 전송
  Future<String?> sendAppointmentMessage(
    String roomId,
    String targetUserId,
    AppointmentData data,
    bool hasRoom,
  ) async {
    final repository = ref.read(chatRepositoryProvider);
    final result = await repository.sendAppointmentMessage(
      roomId: roomId,
      myUserId: _myUserId,
      targetUserId: targetUserId,
      data: data,
      hasRoom: hasRoom,
    );
    return switch (result) {
      Success() => null,
      Error(:final failure) => failure.message,
    };
  }

  Future<String?> updateAppointmentStatus(
    String roomId,
    String messageId,
    AppointmentStatus newStatus,
  ) async {
    final repository = ref.read(chatRepositoryProvider);
    final result = await repository.updateAppointmentStatus(
      roomId: roomId,
      messageId: messageId,
      newStatus: newStatus,
    );
    return switch (result) {
      Success() => null,
      Error(:final failure) => failure.message,
    };
  }

  Future<String?> confirmAppointment(
    String roomId,
    String messageId,
    String postId,
  ) async {
    final repository = ref.read(chatRepositoryProvider);

    // 1. [수정] .value 대신 .future를 사용하여 채팅방 데이터가 로드될 때까지 확실히 기다립니다.
    // 이를 통해 buyerId가 빈 값('')으로 잘못 저장되는 현상을 원천 차단합니다.
    final chatroom = await ref.read(chatRoomStreamProvider(roomId).future);
    final buyerId = chatroom?.participants.firstWhere(
      (id) => id != _myUserId,
      orElse: () => '',
    );
    // [방어 로직] 구매자 ID를 특정할 수 없는 경우 진행하지 않습니다.
    if (buyerId == null || buyerId.isEmpty) {
      return "구매자 정보를 확인할 수 없습니다. 잠시 후 다시 시도해 주세요.";
    }
    // 2. 약속 상태 변경 (메시지 상태: 확정됨)
    await repository.updateAppointmentStatus(
      roomId: roomId,
      messageId: messageId,
      newStatus: AppointmentStatus.confirmed,
    );
    // 3. 상품 상태 업데이트 (상품 상세 페이지 데이터 원천 변경)
    await repository.updatePostStatus(
      postId: postId,
      newStatus: ProductStatus.reserved,
      buyerId: buyerId,
    );
    // 4. [구조적 개선: Stream 전환 완료]
    // 이제 상품 상세 페이지가 해당 상품을 실시간 관찰(Stream)하고 있으므로,
    // 명시적인 invalidate(무효화) 없이도 데이터가 서버에 반영되는 순간 화면이 바뀝니다.
    // ref.invalidate(productDetailPageViewModelProvider(postId));
    debugPrint('✅ 상품 상태가 [예약중]으로 변경되었습니다. (Stream을 통한 실시간 동기화 작동)');
    return null;
  }

  Future<void> cancelAppointment(
    String roomId,
    String messageId,
    String postId,
  ) async {
    final repository = ref.read(chatRepositoryProvider);

    // 1. 상태를 취소로 변경
    final result = await repository.updateAppointmentStatus(
      roomId: roomId,
      messageId: messageId,
      newStatus: AppointmentStatus.cancelled,
    );

    // switch 문을 사용하여 Result 처리
    switch (result) {
      case Success():
        // 2. 취소되었으니 특정 상품(Post)을 다시 판매중으로 롤백
        if (postId.isNotEmpty) {
          final postResult = await repository.updatePostStatus(
            postId: postId,
            newStatus: ProductStatus.available,
            buyerId: null,
          );
          if (postResult case Error(:final failure)) {
            debugPrint('상품 상태 업데이트 실패: ${failure.message}');
          } else {
            // 🔥 [구조적 개선: Invalidation 전략]
            ref.invalidate(productDetailPageViewModelProvider(postId));
            debugPrint('✅ 게시글 상태가 [판매중]으로 롤백되었으며, 프로바이더가 무효화되었습니다!');
          }
        }
        break;

      case Error(:final failure):
        debugPrint(failure.message);
    }
  }

  // [추가] UI에서 '거래 확정하기' 버튼을 누르면 이 함수를 호출합니다!
  Future<void> confirmTransactionManually(String roomId, String postId) async {
    final repository = ref.read(chatRepositoryProvider);
    final result = await repository.confirmTransactionManually(
      roomId: roomId,
      postId: postId,
      myUserId: _myUserId,
    );
    switch (result) {
      case Success():
        // 🔥 [구조적 개선: Invalidation 전략]
        if (postId.isNotEmpty) {
          ref.invalidate(productDetailPageViewModelProvider(postId));
        }
        debugPrint('✅ 수동 확정 처리 완료 및 프로바이더 무효화');
        break;
      case Error(:final failure):
        debugPrint('거래 확정 실패: ${failure.message}');
    }
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
}

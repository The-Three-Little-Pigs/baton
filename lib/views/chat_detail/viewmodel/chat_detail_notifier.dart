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
    final updateResult = await repository.updateAppointmentStatus(
      roomId: roomId,
      messageId: messageId,
      newStatus: AppointmentStatus.confirmed,
    );
    if (updateResult case Error(:final failure)) {
      return failure.message;
    }
    final postResult = await repository.updatePostStatus(
      postId: postId,
      newStatus: ProductStatus.reserved,
    );
    if (postResult case Error(:final failure)) {
      debugPrint('상품 상태 업데이트 실패: ${failure.message}');
      return failure.message;
    }

    // 🔥 [서버 재접속 없는 즉시 렌더링 코드]
    final postNotifier = ref.read(
      productDetailPageViewModelProvider(postId).notifier,
    );
    final currentPost = postNotifier.state.value;

    if (currentPost != null) {
      // 서버에서 새로 받지 않고, 현재 화면의 객체 상태만 '예약중'으로 바꿔서 즉시 화면에 주입!
      postNotifier.state = AsyncData(
        currentPost.copyWith(status: ProductStatus.reserved),
      );
    } else {
      // 혹시라도 메모리에 객체가 없다면 어쩔 수 없이 서버 조회
      ref.invalidate(productDetailPageViewModelProvider(postId));
    }

    debugPrint('✅ 상품 상태가 [예약중]으로 정상 변경되었습니다!');
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
        if (postId.isEmpty) {
          debugPrint('postId is empty');
          return;
        }
        final postResult = await repository.updatePostStatus(
          postId: postId,
          newStatus: ProductStatus.available,
        );
        if (postResult case Error(:final failure)) {
          debugPrint('상품 상태 업데이트 실패: ${failure.message}');
        } else {
          // 🔥 [서버 재접속 없는 즉시 렌더링 코드]
          final postNotifier = ref.read(
            productDetailPageViewModelProvider(postId).notifier,
          );
          final currentPost = postNotifier.state.value;

          if (currentPost != null) {
            // 이번엔 스무스하게 즉시 '판매중'으로 바꿔치기
            postNotifier.state = AsyncData(
              currentPost.copyWith(status: ProductStatus.available),
            );
          } else {
            ref.invalidate(productDetailPageViewModelProvider(postId));
          }
          debugPrint('✅ 게시글 상태가 [판매중]으로 성공적으로 롤백되었습니다!');
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
        // 쌍방 확정이 이뤄져서 상품이 '판매완료'로 바뀌었을 때를 대비해 즉각적인 UI 반영(낙관적 업데이트)
        if (postId.isNotEmpty) {
          final postNotifier = ref.read(
            productDetailPageViewModelProvider(postId).notifier,
          );
          final currentPost = postNotifier.state.value;
          if (currentPost != null) {
            postNotifier.state = AsyncData(
              currentPost.copyWith(status: ProductStatus.sold),
            );
          } else {
            ref.invalidate(productDetailPageViewModelProvider(postId));
          }
        }
        debugPrint('✅ 수동 확정 버튼 클릭 처리 완료');
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

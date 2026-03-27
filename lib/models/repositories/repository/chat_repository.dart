import 'dart:io';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/appointment_data.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/message.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:baton/models/enum/product_status.dart';

abstract class ChatRepository {
  /// 채팅방 목록 실시간 구독
  Stream<List<Chatroom>> watchChatRooms(String myUserId);

  /// 특정 채팅방의 메시지 목록 실시간 구독
  Stream<List<Message>> watchMessages(String roomId);

  /// 특정 채팅방 상세 정보 실시간 구독
  Stream<Chatroom?> watchChatRoom(String roomId);

  /// 메시지 읽음 처리
  Future<Result<void, Failure>> markAsRead(String roomId, String myUserId);

  /// 텍스트 메시지 전송
  Future<Result<void, Failure>> sendTextMessage(
    String roomId,
    String myUserId,
    String targetUserId,
    String content,
    bool hasRoom,
  );

  /// 이미지 메시지 전송 (Storage 업로드 포함)
  Future<Result<void, Failure>> sendImageMessage(
    String roomId,
    String myUserId,
    String targetUserId,
    File imageFile,
    bool hasRoom,
  );

  /// 채팅방 나가기 (삭제)
  Future<Result<bool, Failure>> leaveRoom(String roomId, String myUserId);

  /// 시스템 메시지 전송
  // Future<Result<void, Failure>> sendSystemMessage(
  //   String roomId,
  //   String content,
  // );
  // 약속 메세지 전송
  Future<Result<void, Failure>> sendAppointmentMessage({
    required String roomId,
    required String myUserId,
    required String targetUserId,
    required AppointmentData data,
    required bool hasRoom,
    AppointmentData? previousData,
  });

  // 약속 상태 업데이트
  Future<Result<void, Failure>> updateAppointmentStatus({
    required String roomId,
    required String messageId,
    required AppointmentStatus newStatus,
  });

  Future<Result<void, Failure>> updatePostStatus({
    required String postId,
    required ProductStatus newStatus,
    String? buyerId,
  });
  Future<Result<void, Failure>> confirmTransactionManually({
    required String roomId,
    required String postId,
    required String myUserId,
  });

  /// 특정 상품에 대한 채팅방 개수 실시간 구독
}

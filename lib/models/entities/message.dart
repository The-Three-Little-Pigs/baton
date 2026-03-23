import 'dart:convert';

import 'package:baton/models/entities/appointment_data.dart';
import 'package:baton/models/enum/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

DateTime _parseDate(dynamic date) {
  if (date == null) return DateTime.now();
  if (date is Timestamp) return date.toDate();
  if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
  return DateTime.now();
}

class Message {
  final String id; // 메세지 아이디
  final String roomId; // 채팅방 아이디
  final String senderId; // 메세지 보낸 사람
  final String content; // 메세지 내용
  final MessageType type; // 메세지 타입
  final DateTime createdAt; // 메세지 생성 시간
  final bool isPending; // 메세지 전송 상태
  final AppointmentData? appointmentData; // 약속 데이터

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isPending = false,
    this.appointmentData,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final type = MessageType.values.firstWhere(
      (e) => e.name == json['type'] || e.label == json['type'],
      orElse: () => MessageType.text,
    );
    final contentStr = json['content'] as String;
    AppointmentData? parsedAppointmentData;
    if (type == MessageType.appointment && contentStr.isNotEmpty) {
      try {
        parsedAppointmentData = AppointmentData.fromJson(
          jsonDecode(contentStr),
        );
      } catch (e) {
        debugPrint('fromJson parsing error: $e');
      }
    }
    return Message(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      senderId: json['senderId'] as String,
      content: contentStr,
      type: type,
      createdAt: _parseDate(json['createdAt']),
      isPending: json['isPending'] ?? false,
      appointmentData: parsedAppointmentData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'content': content,
      'type': type.label,
      'createdAt': createdAt,
      'isPending': isPending,
    };
  }

  Message copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    bool? isPending,
  }) {
    return Message(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isPending: isPending ?? this.isPending,
    );
  }

  factory Message.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isPending = doc.metadata.hasPendingWrites;
    final type = MessageType.values.firstWhere(
      (e) => e.name == data['type'] || e.label == data['type'],
      orElse: () => MessageType.text,
    );
    final contentStr = data['content'] as String;
    AppointmentData? parsedAppointmentData;
    if (type == MessageType.appointment && contentStr.isNotEmpty) {
      try {
        parsedAppointmentData = AppointmentData.fromJson(
          jsonDecode(contentStr),
        );
      } catch (e) {
        debugPrint('fromFirestore parsing error: $e');
      }
    }
    return Message(
      id: data['id'] ?? '',
      roomId: data['roomId'] ?? '',
      senderId: data['senderId'] ?? '',
      content: contentStr,
      type: type,
      createdAt: _parseDate(data['createdAt']),
      isPending: isPending,
      appointmentData: parsedAppointmentData,
    );
  }
}

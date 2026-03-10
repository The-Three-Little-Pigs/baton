import 'package:baton/models/enum/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime _parseDate(dynamic date) {
  if (date == null) return DateTime.now();
  if (date is Timestamp) return date.toDate();
  if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
  return DateTime.now();
}

class Message {
  final String roomId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final bool isPending;

  Message({
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
    this.isPending = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      roomId: json['roomId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      createdAt: _parseDate(json['createdAt']),
      isPending: json['isPending'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'createdAt': createdAt,
      'isPending': isPending,
    };
  }

  Message copyWith({
    String? roomId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    bool? isPending,
  }) {
    return Message(
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
    return Message(
      roomId: data['roomId'] ?? '',
      senderId: data['senderId'] ?? '',
      content: data['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      createdAt: _parseDate(data['createdAt']),
      isPending: isPending,
    );
  }
}

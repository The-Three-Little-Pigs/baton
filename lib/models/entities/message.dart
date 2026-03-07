import 'package:baton/models/enum/message_type.dart';

class Message {
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;

  Message({
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      createdAt: json['created_at'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'content': content,
      'type': type.name,
      'created_at': createdAt,
    };
  }

  Message copyWith({
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

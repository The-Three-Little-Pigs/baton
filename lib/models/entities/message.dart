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
}

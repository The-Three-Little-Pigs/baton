import 'package:baton/models/enum/chat_status.dart';

class ChatRoom {
  final List<String> participants;
  final Map<String, int> unReadCount;
  final DateTime updatedAt;
  final String postId;
  final String lastMessage;
  final ChatStatus status;

  ChatRoom({
    required this.participants,
    required this.unReadCount,
    required this.updatedAt,
    required this.postId,
    required this.lastMessage,
    required this.status,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      participants: json['participants'] as List<String>,
      unReadCount: json['unReadCount'] as Map<String, int>,
      updatedAt: json['updatedAt'] as DateTime,
      postId: json['postId'] as String,
      lastMessage: json['lastMessage'] as String,
      status: ChatStatus.values.firstWhere((e) => e.name == json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'unReadCount': unReadCount,
      'updatedAt': updatedAt,
      'postId': postId,
      'lastMessage': lastMessage,
      'status': status.name,
    };
  }

  ChatRoom copyWith({
    List<String>? participants,
    Map<String, int>? unReadCount,
    DateTime? updatedAt,
    String? postId,
    String? lastMessage,
    ChatStatus? status,
  }) {
    return ChatRoom(
      participants: participants ?? this.participants,
      unReadCount: unReadCount ?? this.unReadCount,
      updatedAt: updatedAt ?? this.updatedAt,
      postId: postId ?? this.postId,
      lastMessage: lastMessage ?? this.lastMessage,
      status: status ?? this.status,
    );
  }
}

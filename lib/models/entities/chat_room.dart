class ChatRoom {
  final List<String> participants;
  final Map<String, int> unReadCount;
  final DateTime updatedAt;
  final String postId;
  final String lastMessage;

  ChatRoom({
    required this.participants,
    required this.unReadCount,
    required this.updatedAt,
    required this.postId,
    required this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      participants: json['participants'],
      unReadCount: json['unReadCount'],
      updatedAt: json['updatedAt'],
      postId: json['postId'],
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'unReadCount': unReadCount,
      'updatedAt': updatedAt,
      'postId': postId,
      'lastMessage': lastMessage,
    };
  }

  ChatRoom copyWith({
    List<String>? participants,
    Map<String, int>? unReadCount,
    DateTime? updatedAt,
    String? postId,
    String? lastMessage,
  }) {
    return ChatRoom(
      participants: participants ?? this.participants,
      unReadCount: unReadCount ?? this.unReadCount,
      updatedAt: updatedAt ?? this.updatedAt,
      postId: postId ?? this.postId,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}

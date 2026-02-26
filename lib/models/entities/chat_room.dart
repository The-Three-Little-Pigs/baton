class ChatRoom {
  final List<String> participants;
  final Map<String, int> unReadCount;
  final DateTime updatedAt;
  final String prdImageUrl;
  final String lastMessage;

  ChatRoom({
    required this.participants,
    required this.unReadCount,
    required this.updatedAt,
    required this.prdImageUrl,
    required this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      participants: json['participants'],
      unReadCount: json['unReadCount'],
      updatedAt: json['updatedAt'],
      prdImageUrl: json['prdImageUrl'],
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'unReadCount': unReadCount,
      'updatedAt': updatedAt,
      'prdImageUrl': prdImageUrl,
      'lastMessage': lastMessage,
    };
  }

  ChatRoom copyWith({
    List<String>? participants,
    Map<String, int>? unReadCount,
    DateTime? updatedAt,
    String? prdImageUrl,
    String? lastMessage,
  }) {
    return ChatRoom(
      participants: participants ?? this.participants,
      unReadCount: unReadCount ?? this.unReadCount,
      updatedAt: updatedAt ?? this.updatedAt,
      prdImageUrl: prdImageUrl ?? this.prdImageUrl,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}

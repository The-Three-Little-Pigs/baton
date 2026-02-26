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
}

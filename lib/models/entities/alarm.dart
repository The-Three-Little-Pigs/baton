class Alarm {
  final String alarmId;
  final String title;
  final String content;
  final String imageUrl;
  final String authorId;
  final DateTime createdAt;

  Alarm({
    required this.alarmId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.authorId,
    required this.createdAt,
  });
}

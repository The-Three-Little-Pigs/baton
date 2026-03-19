class Alarm {
  final String alarmId; // 작성자_수신자
  final String title; // 제목
  final String content; // 내용
  final String imageUrl; // 이미지
  final String authorId; // 작성자
  final String receiverId; // 수신자
  final DateTime createdAt; // 생성 시간

  Alarm({
    required this.alarmId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.authorId,
    required this.receiverId,
    required this.createdAt,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      alarmId: json['alarm_id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      authorId: json['author_id'],
      receiverId: json['receiver_id'],
      createdAt: json['created_at'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alarm_id': alarmId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'author_id': authorId,
      'receiver_id': receiverId,
      'created_at': createdAt,
    };
  }
}

class Alarm {
  final String alarmId; // 작성자_수신자
  final String title; // 제목
  final String content; // 내용
  final String imageUrl; // 이미지
  final String authorId; // 작성자
  final String receiverId; // 수신자
  final DateTime createdAt; // 생성 시간
  final bool isRead; // 읽음 여부

  Alarm({
    required this.alarmId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.authorId,
    required this.receiverId,
    required this.createdAt,
    this.isRead = false,
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
      isRead: json['is_read'] ?? false,
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
      'is_read': isRead,
    };
  }

  Alarm copyWith({
    String? alarmId,
    String? title,
    String? content,
    String? imageUrl,
    String? authorId,
    String? receiverId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Alarm(
      alarmId: alarmId ?? this.alarmId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      authorId: authorId ?? this.authorId,
      receiverId: receiverId ?? this.receiverId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

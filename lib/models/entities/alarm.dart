class Alarm {
  final String alarmId; // 작성자_수신자
  final String title; // 제목
  final String content; // 내용
  final String imageUrl; // 이미지
  final String authorId; // 작성자
  final String receiverId; // 수신자
  final String? postId; // 연관 게시글 아이디 (이동용)
  final DateTime createdAt; // 생성 시간
  final bool isRead; // 읽음 여부

  Alarm({
    required this.alarmId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.authorId,
    required this.receiverId,
    this.postId,
    required this.createdAt,
    this.isRead = false,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      alarmId: json['alarm_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      authorId: json['author_id'] as String? ?? '',
      receiverId: json['receiver_id'] as String? ?? '',
      postId: json['post_id'] as String?,
      createdAt: _parseDateTime(json['created_at']),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    // Firestore Timestamp
    if (value.runtimeType.toString().contains('Timestamp')) {
      return (value as dynamic).toDate() as DateTime;
    }
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'alarm_id': alarmId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'author_id': authorId,
      'receiver_id': receiverId,
      'post_id': postId,
      'created_at': createdAt, // Firestore SDK가 자동으로 Timestamp로 변환
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
    String? postId,
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
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

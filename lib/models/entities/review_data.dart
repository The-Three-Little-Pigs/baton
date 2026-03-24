import 'package:cloud_firestore/cloud_firestore.dart';

// 안전한 날짜 파싱을 위한 헬퍼 함수
DateTime _parseDate(dynamic date) {
  if (date == null) return DateTime.now();
  if (date is Timestamp) return date.toDate();
  if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
  return DateTime.now();
}

class ReviewData {
  final String reviewId;
  final String writerId; // 후기 작성자 (나)
  final String receiverId; // 후기 수신자 (상대방)
  final String postId; // 거래된 상품 ID
  final String roomId; // 채팅방 ID (중복 작성 방지용)
  final double rating; // 별점 (1.0 ~ 5.0)
  final String? content; // 후기 텍스트 (선택)
  final DateTime createdAt;

  const ReviewData({
    required this.reviewId,
    required this.writerId,
    required this.receiverId,
    required this.postId,
    required this.roomId,
    required this.rating,
    this.content,
    required this.createdAt,
  });

  // 1. JSON으로부터 객체 생성
  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviewId: json['reviewId'] as String? ?? '',
      writerId: json['writerId'] as String? ?? '',
      receiverId: json['receiverId'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      roomId: json['roomId'] as String? ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      content: json['content'] as String?,
      createdAt: _parseDate(json['createdAt']),
    );
  }

  // 2. 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'writerId': writerId,
      'receiverId': receiverId,
      'postId': postId,
      'roomId': roomId,
      'rating': rating,
      'content': content,
      'createdAt': createdAt,
    };
  }

  // 3. 필드 수정을 위한 copyWith
  ReviewData copyWith({
    String? reviewId,
    String? writerId,
    String? receiverId,
    String? postId,
    String? roomId,
    double? rating,
    String? content,
    DateTime? createdAt,
  }) {
    return ReviewData(
      reviewId: reviewId ?? this.reviewId,
      writerId: writerId ?? this.writerId,
      receiverId: receiverId ?? this.receiverId,
      postId: postId ?? this.postId,
      roomId: roomId ?? this.roomId,
      rating: rating ?? this.rating,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // 4. Firestore DocumentSnapshot으로부터 객체 생성 (안전한 파싱)
  factory ReviewData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ReviewData(
      reviewId: doc.id,
      writerId: data['writerId']?.toString() ?? '',
      receiverId: data['receiverId']?.toString() ?? '',
      postId: data['postId']?.toString() ?? '',
      roomId: data['roomId']?.toString() ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      content: data['content']?.toString(),
      createdAt: _parseDate(data['createdAt']),
    );
  }

  // 5. Firestore에 저장할 데이터 맵 (전역 상수값 등 처리)
  Map<String, dynamic> toFirestore() {
    return {
      'writerId': writerId,
      'receiverId': receiverId,
      'postId': postId,
      'roomId': roomId,
      'rating': rating,
      'content': content,
      'createdAt': createdAt, // Firestore SDK가 DateTime을 자동으로 Timestamp로 변환함
    };
  }
}

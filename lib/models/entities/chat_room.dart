import 'package:baton/models/enum/chat_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chatroom {
  final String roomId; // 채팅방 아이디
  final List<String> participants; // 채팅방 참여자
  final Map<String, int> unreadCounts; // 안읽은 메세지 수
  final DateTime updatedAt; // 마지막 업데이트 시간
  final String prdImageUrl; // 상품 이미지
  final String lastMessage; // 마지막 메세지
  final Map<String, dynamic> lastReadAt; // 마지막 읽은 시간
  final ChatStatus status; // 채팅방 상태(거래중, 거래완료, 거래취소)
  final List<String> deletedByUids; // 채팅방 삭제자

  Chatroom({
    required this.roomId,
    required this.participants,
    required this.unreadCounts,
    required this.updatedAt,
    required this.prdImageUrl,
    required this.lastMessage,
    required this.lastReadAt,
    required this.status,
    required this.deletedByUids,
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      roomId: json['roomId'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      unreadCounts: Map<String, int>.from(json['unreadCounts'] ?? {}),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      prdImageUrl: json['prdImageUrl'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastReadAt: Map<String, dynamic>.from(json['lastReadAt'] ?? {}),
      status: ChatStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ChatStatus.all,
      ),
      deletedByUids: List<String>.from(json['deletedByUids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'participants': participants,
      'unreadCounts': unreadCounts,
      'updatedAt': updatedAt,
      'prdImageUrl': prdImageUrl,
      'lastMessage': lastMessage,
      'lastReadAt': lastReadAt,
      'status': status,
      'deletedByUids': deletedByUids,
    };
  }

  Chatroom copyWith({
    String? roomId,
    List<String>? participants,
    Map<String, int>? unreadCounts,
    DateTime? updatedAt,
    String? prdImageUrl,
    String? lastMessage,
    Map<String, dynamic>? lastReadAt,
    ChatStatus? status,
    List<String>? deletedByUids,
  }) {
    return Chatroom(
      roomId: roomId ?? this.roomId,
      participants: participants ?? this.participants,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      updatedAt: updatedAt ?? this.updatedAt,
      prdImageUrl: prdImageUrl ?? this.prdImageUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      status: status ?? this.status,
      deletedByUids: deletedByUids ?? this.deletedByUids,
    );
  }

  factory Chatroom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // 안전한 lastReadAt 파싱
    final rawLastReadAt = data['lastReadAt'] as Map<String, dynamic>? ?? {};
    final parsedLastReadAt = <String, DateTime>{};
    rawLastReadAt.forEach((key, value) {
      if (value is Timestamp) {
        parsedLastReadAt[key] = value.toDate();
      }
    });

    // 안전한 unreadCounts 파싱 (double 등이 섞여 들어오는 에러 방지)
    final rawUnreadCounts = data['unreadCounts'] as Map<String, dynamic>? ?? {};
    final parsedUnreadCounts = <String, int>{};
    rawUnreadCounts.forEach((key, value) {
      if (value is num) {
        parsedUnreadCounts[key] = value.toInt();
      }
    });

    // 안전한 participants 파싱
    final rawParticipants = data['participants'] as List<dynamic>? ?? [];
    final parsedParticipants = rawParticipants
        .map((e) => e.toString())
        .toList();

    return Chatroom(
      roomId: data['roomId']?.toString() ?? '',
      participants: parsedParticipants,
      unreadCounts: parsedUnreadCounts,
      updatedAt: DateTime.now(),
      prdImageUrl: data['prdImageUrl']?.toString() ?? '',
      lastMessage: data['lastMessage']?.toString() ?? '',
      lastReadAt: parsedLastReadAt,
      status: ChatStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ChatStatus.all,
      ),
      deletedByUids: List<String>.from(data['deletedByUids'] ?? []),
    );
  }
}

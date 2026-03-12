import 'package:baton/models/enum/chat_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime _parseDate(dynamic date) {
  if (date == null) return DateTime.now();
  if (date is Timestamp) return date.toDate();
  if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
  return DateTime.now();
}

class Chatroom {
  final String roomId;
  final List<String> participants;
  final Map<String, int> unreadCounts;
  final DateTime updatedAt;
  final String prdImageUrl;
  final String lastMessage;
  final Map<String, dynamic> lastReadAt;
  final ChatStatus status;
  final List<String> deletedByUids;

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
      updatedAt: _parseDate(json['updatedAt']),
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
      updatedAt: _parseDate(data['updatedAt']),
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

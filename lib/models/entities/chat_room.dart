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

  Chatroom({
    required this.roomId,
    required this.participants,
    required this.unreadCounts,
    required this.updatedAt,
    required this.prdImageUrl,
    required this.lastMessage,
    required this.lastReadAt,
    required this.status,
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
    );
  }

  factory Chatroom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawLastReadAt = data['lastReadAt'] as Map<String, dynamic>? ?? {};
    final parsedLastReadAt = <String, DateTime>{};
    rawLastReadAt.forEach((key, value) {
      if (value is Timestamp) {
        parsedLastReadAt[key] = value.toDate();
      }
    });
    return Chatroom(
      roomId: data['roomId'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
      updatedAt: _parseDate(data['updatedAt']),
      prdImageUrl: data['prdImageUrl'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastReadAt: parsedLastReadAt,
      status: ChatStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ChatStatus.all,
      ),
    );
  }
}

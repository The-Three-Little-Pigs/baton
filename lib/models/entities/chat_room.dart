import 'package:baton/models/enum/chat_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

DateTime _parseDate(dynamic date) {
  if (date == null) return DateTime.now();
  if (date is Timestamp) return date.toDate();
  if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
  return DateTime.now();
}

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
  final String? appointmentStatus; // 현재 약속 상태
  final DateTime? appointmentDateTime; // 마지막으로 확정/제안된 약속 시간
  final String? activeAppointmentId; // 현재 활성화된 약속 ID
  final List<String> confirmedCompleteUids; // 거래확정 완료자
  final DateTime? confirmedAt; // 거래확정 시간

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
    this.appointmentStatus,
    this.appointmentDateTime,
    this.activeAppointmentId,
    this.confirmedCompleteUids = const [],
    this.confirmedAt,
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      roomId: json['roomId'] as String,
      participants: List<String>.from(json['participants'] ?? []),
      unreadCounts: Map<String, int>.from(json['unreadCounts'] ?? {}),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      prdImageUrl: json['prdImageUrl'] as String,
      lastMessage: json['lastMessage'] as String,
      lastReadAt: Map<String, dynamic>.from(json['lastReadAt'] ?? {}),
      status: ChatStatus.values.firstWhere(
        (e) => e.label == json['status'],
        orElse: () => ChatStatus.all,
      ),
      deletedByUids: List<String>.from(json['deletedByUids'] ?? []),
      appointmentStatus: json['appointmentStatus'] as String?,
      appointmentDateTime: (json['appointmentDateTime'] as Timestamp?)
          ?.toDate(),
      activeAppointmentId: json['activeAppointmentId'] as String?,
      confirmedCompleteUids: List<String>.from(
        json['confirmedCompleteUids'] ?? [],
      ),
      confirmedAt: (json['confirmedAt'] as Timestamp?)?.toDate(),
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
      'appointmentStatus': appointmentStatus,
      'appointmentDateTime': appointmentDateTime,
      'activeAppointmentId': activeAppointmentId,
      'confirmedCompleteUids': confirmedCompleteUids,
      'confirmedAt': confirmedAt,
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
    String? appointmentStatus,
    DateTime? appointmentDateTime,
    String? activeAppointmentId,
    List<String>? confirmedCompleteUids,
    DateTime? confirmedAt,
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
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
      activeAppointmentId: activeAppointmentId ?? this.activeAppointmentId,
      confirmedCompleteUids:
          confirmedCompleteUids ?? this.confirmedCompleteUids,
      confirmedAt: confirmedAt ?? this.confirmedAt,
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
        (e) => e.label == data['status'],
        orElse: () => ChatStatus.all,
      ),
      deletedByUids: List<String>.from(data['deletedByUids'] ?? []),
      appointmentStatus: data['appointmentStatus']?.toString(),
      appointmentDateTime: _parseDate(data['appointmentDateTime']),
      activeAppointmentId: data['activeAppointmentId']?.toString(),
      confirmedCompleteUids: List<String>.from(
        data['confirmedCompleteUids'] ?? [],
      ),
      confirmedAt: _parseDate(data['confirmedAt']),
    );
  }
}

import 'package:baton/models/enum/appointment_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentData {
  final String appointmentId;
  final String method;
  final DateTime dateTime;
  final AppointmentStatus status;
  final String proposeBy;
  final String? previousMessageId;

  AppointmentData({
    required this.appointmentId,
    required this.method,
    required this.dateTime,
    required this.status,
    required this.proposeBy,
    this.previousMessageId,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    final dynamic dateVal = json['dateTime'];
    if (dateVal is Timestamp) {
      parsedDate = dateVal.toDate();
    } else if (dateVal is String) {
      parsedDate = DateTime.tryParse(dateVal) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now(); // 만약을 대비한 기본값
    }

    return AppointmentData(
      appointmentId: json['appointmentId'] as String,
      method: json['method'] as String,
      dateTime: parsedDate,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.label == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      proposeBy: json['proposeBy'] as String,
      previousMessageId: json['previousMessageId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'method': method,
      'dateTime': dateTime.toIso8601String(),
      'status': status.label,
      'proposeBy': proposeBy,
      'previousMessageId': previousMessageId,
    };
  }

  AppointmentData copyWith({
    String? appointmentId,
    String? method,
    DateTime? dateTime,
    AppointmentStatus? status,
    String? proposeBy,
    String? previousMessageId,
  }) {
    return AppointmentData(
      appointmentId: appointmentId ?? this.appointmentId,
      method: method ?? this.method,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      proposeBy: proposeBy ?? this.proposeBy,
      previousMessageId: previousMessageId ?? this.previousMessageId,
    );
  }
}

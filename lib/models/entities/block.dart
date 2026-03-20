// 블락 유저 사용

import 'package:cloud_firestore/cloud_firestore.dart';

DateTime _parseDate(dynamic date) {
  if (date == null) return DateTime.now();
  if (date is Timestamp) return date.toDate();
  if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
  return DateTime.now();
}

class Block {
  final String? id;
  final String blockerId; //차단 한 사람
  final String blockedId; //차단 당한 사람
  final DateTime createdAt;

  Block({
    this.id,
    required this.blockerId,
    required this.blockedId,
    required this.createdAt,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] as String,
      blockerId: json['blockerId'] as String,
      blockedId: json['blockedId'] as String,
      createdAt: _parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockerId': blockerId,
      'blockedId': blockedId,
      'createdAt': createdAt,
    };
  }

  Block copyWith({
    String? id,
    String? blockerId,
    String? blockedId,
    DateTime? createdAt,
  }) {
    return Block(
      id: id ?? this.id,
      blockerId: blockerId ?? this.blockerId,
      blockedId: blockedId ?? this.blockedId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

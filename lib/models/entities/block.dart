// 블락 유저 사용
class Block {
  final String blockerId;
  final String blokedId;

  Block({required this.blockerId, required this.blokedId});

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      blockerId: json['blocker_id'] as String,
      blokedId: json['bloked_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'blocker_id': blockerId, 'bloked_id': blokedId};
  }

  Block copyWith({String? blockerId, String? blokedId}) {
    return Block(
      blockerId: blockerId ?? this.blockerId,
      blokedId: blokedId ?? this.blokedId,
    );
  }
}

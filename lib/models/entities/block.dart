// 블락 유저 사용
class Block {
  final String blockerId; //차단 한 사람
  final String blokedId; //차단 당한 사람

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

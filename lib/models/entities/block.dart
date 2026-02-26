class Block {
  final String blockerId;
  final String blokedId;

  Block({required this.blockerId, required this.blokedId});

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(blockerId: json['blocker_id'], blokedId: json['bloked_id']);
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

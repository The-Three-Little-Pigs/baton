class UserEntity {
  final String uid;
  final String profileUrl;
  final String nickname;
  final double? score;

  UserEntity({
    required this.uid,
    required this.profileUrl,
    required this.nickname,
    required this.score,
  });
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uid: json['uid'] as String,
      profileUrl: json['profileUrl'] as String,
      nickname: json['nickname'] as String,
      score: (json['score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'profileUrl': profileUrl,
      'nickname': nickname,
      'score': score,
    };
  }
}

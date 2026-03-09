class User {
  final String uid;
  final String profileUrl;
  final String nickname;
  final double? score;
  final String? fcmToken;

  User({
    required this.uid,
    required this.profileUrl,
    required this.nickname,
    required this.score,
    this.fcmToken,
    String? profileImageUrl,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      profileUrl: json['profileUrl'] as String,
      nickname: json['nickname'] as String,
      score: (json['score'] as num?)?.toDouble(),
      fcmToken: json['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'profileUrl': profileUrl,
      'nickname': nickname,
      'score': score,
      'fcmToken': fcmToken,
    };
  }
}

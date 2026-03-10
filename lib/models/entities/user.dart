class User {
  final String uid;
  final String profileUrl; // 💡 필드명 확인
  final String nickname;
  final double? score;
  final String? fcmToken;
  final List<String> favorites;
  final List<String> blockedUsers;

  User({
    required this.uid,
    required this.profileUrl,
    required this.nickname,
    required this.score,
    this.fcmToken,
    this.favorites = const [],
    this.blockedUsers = const [],
    // 💡 여기서 'String? profileImageUrl' 이라는 잘못된 파라미터를 삭제했습니다.
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      profileUrl: json['profileUrl'] as String,
      nickname: json['nickname'] as String,
      score: (json['score'] as num?)?.toDouble(),
      fcmToken: json['fcmToken'] as String?,
      favorites: List<String>.from(json['favorites'] ?? []),
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'profileUrl': profileUrl,
      'nickname': nickname,
      'score': score,
      'fcmToken': fcmToken,
      'favorites': favorites,
      'blockedUsers': blockedUsers,
    };
  }

  User copyWith({
    String? profileUrl, // 💡 이름을 profileUrl로 통일
    String? nickname,
    double? score,
    String? fcmToken,
    List<String>? favorites,
    List<String>? blockedUsers,
  }) {
    return User(
      uid: uid,
      profileUrl: profileUrl ?? this.profileUrl,
      nickname: nickname ?? this.nickname,
      score: score ?? this.score,
      fcmToken: fcmToken ?? this.fcmToken,
      favorites: favorites ?? this.favorites,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }
}
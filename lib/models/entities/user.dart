class User {
  final String uid;
  final String nickname;
  final String? profileUrl;
  final double score;
  final String fcmToken;
  final List<String> favorites;
  final List<String> blockedUsers;
  final List<String> blockedBy;

  User({
    required this.uid,
    required this.nickname,
    required this.profileUrl,
    required this.score,
    required this.fcmToken,
    required this.favorites,
    required this.blockedUsers,
    required this.blockedBy,
  });

  User copyWith({
    String? uid,
    String? nickname,
    String? profileUrl,
    double? score,
    String? fcmToken,
    List<String>? favorites,
    List<String>? blockedUsers,
    List<String>? blockedBy,
  }) {
    return User(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl ?? this.profileUrl,
      score: score ?? this.score,
      fcmToken: fcmToken ?? this.fcmToken,
      favorites: favorites ?? this.favorites,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      blockedBy: blockedBy ?? this.blockedBy,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'nickname': nickname,
    'profileUrl': profileUrl,
    'score': score,
    'fcmToken': fcmToken,
    'favorites': favorites,
    'blockedUsers': blockedUsers,
    'blockedBy': blockedBy,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      nickname: json['nickname'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      score: (json['score'] ?? 36.5).toDouble(),
      fcmToken: json['fcmToken'] ?? '',
      favorites: List<String>.from(json['favorites'] ?? []),
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
      blockedBy: List<String>.from(json['blockedBy'] ?? []),
    );
  }
}

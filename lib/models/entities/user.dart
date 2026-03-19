class User {
  final String uid;
  final String nickname;
  final String? profileUrl;
  final double score;
  final Set<String> favorites;
  final List<String> blockedUsers;
  final List<String> blockedBy;
  final bool isDeleted; // 🔥 추가: 소프트 삭제 여부

  User({
    required this.uid,
    required this.nickname,
    required this.profileUrl,
    required this.score,
    required this.favorites,
    required this.blockedUsers,
    required this.blockedBy,
    this.isDeleted = false,
  });

  User copyWith({
    String? uid,
    String? nickname,
    String? profileUrl,
    double? score,
    Set<String>? favorites,
    List<String>? blockedUsers,
    List<String>? blockedBy,
    bool? isDeleted,
  }) {
    return User(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl ?? this.profileUrl,
      score: score ?? this.score,
      favorites: favorites ?? this.favorites,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      blockedBy: blockedBy ?? this.blockedBy,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'nickname': nickname,
    'profileUrl': profileUrl,
    'score': score,
    'favorites': favorites.toSet(),
    'blockedUsers': blockedUsers,
    'blockedBy': blockedBy,
    'isDeleted': isDeleted,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      nickname: json['nickname'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      score: (json['score'] ?? 36.5).toDouble(),
      favorites: Set<String>.from(json['favorites'] ?? []),
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
      blockedBy: List<String>.from(json['blockedBy'] ?? []),
      isDeleted: json['isDeleted'] ?? json['is_deleted'] ?? false,
    );
  }
}

class User {
  final String uid; // 유저 아이디
  final String nickname; // 유저 닉네임
  final String? profileUrl; // 유저 프로필 이미지
  final double score; // 유저 매너 온도
  final Set<String> favorites; // 유저 찜 목록
  final Set<String> blockedUsers; // 유저 차단 목록
  final Set<String> recentlySearch;
  final DateTime? deletedAt;
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
    required this.recentlySearch,
    this.deletedAt,
    required this.blockedBy,
    this.isDeleted = false,
  });

  User copyWith({
    String? uid,
    String? nickname,
    String? profileUrl,
    double? score,
    Set<String>? favorites,
    Set<String>? blockedUsers,
    Set<String>? recentlySearch,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return User(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl ?? this.profileUrl,
      score: score ?? this.score,
      favorites: favorites ?? this.favorites,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      recentlySearch: recentlySearch ?? this.recentlySearch,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'nickname': nickname,
    'profileUrl': profileUrl,
    'score': score,
    'favorites': favorites.toSet(),
    'blockedUsers': blockedUsers.toSet(),
    'recentlySearch': recentlySearch,
    'deletedAt': deletedAt,
    'blockedUsers': blockedUsers,
    'isDeleted': isDeleted,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      nickname: json['nickname'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      score: (json['score'] ?? 36.5).toDouble(),
      favorites: Set<String>.from(json['favorites'] ?? []),
      blockedUsers: Set<String>.from(json['blockedUsers'] ?? []),
      recentlySearch: Set<String>.from(json['recentlySearch'] ?? []),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt']),
      isDeleted: json['isDeleted'] ?? json['is_deleted'] ?? false,
    );
  }
}

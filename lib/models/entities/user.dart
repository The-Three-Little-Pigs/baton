class User {
  final String uid; // 유저 아이디
  final String nickname; // 유저 닉네임
  final String? profileUrl; // 유저 프로필 이미지
  final double score; // 유저 매너 온도
  final Set<String> favorites; // 유저 찜 목록
  final DateTime? deletedAt;
 

  User({
    required this.uid,
    required this.nickname,
    required this.profileUrl,
    required this.score,
    required this.favorites,    
    this.deletedAt,
    
    
  });

  User copyWith({
    String? uid,
    String? nickname,
    String? profileUrl,
    double? score,
    Set<String>? favorites,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return User(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl ?? this.profileUrl,
      score: score ?? this.score,
      favorites: favorites ?? this.favorites,
      deletedAt: deletedAt ?? this.deletedAt,
      
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'nickname': nickname,
    'profileUrl': profileUrl,
    'score': score,
    'favorites': favorites.toList(),    
    'deletedAt': deletedAt,
   
    
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      nickname: json['nickname'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      score: (json['score'] ?? 5.0).toDouble(),
      favorites: Set<String>.from(json['favorites'] ?? []),
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
      blockedBy: List<String>.from(json['blockedBy'] ?? []),
      isDeleted: json['isDeleted'] ?? json['is_deleted'] ?? false,
    );
  }
}

class User {
  final String uid;
  final String? profileUrl;
  final String nickname;
  // final double? scrore;

  User({required this.uid, required this.profileUrl, required this.nickname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      profileUrl: json['profile_url'],
      nickname: json['nickname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'profile_url': profileUrl, 'nickname': nickname};
  }

  User copyWith({String? uid, String? profileUrl, String? nickname}) {
    return User(
      uid: uid ?? this.uid,
      profileUrl: profileUrl ?? this.profileUrl,
      nickname: nickname ?? this.nickname,
    );
  }
}

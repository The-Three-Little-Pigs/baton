class FCMToken {
  final String token; // fcm token 값(기기마다 고유한 값)
  final String uid; // 유저 아이디
  final String os; // 운영체제(ios, android, web)
  final bool isActive; // 활성화 여부

  FCMToken({
    required this.token,
    required this.uid,
    required this.os,
    required this.isActive,
  });

  factory FCMToken.fromJson(Map<String, dynamic> json) => FCMToken(
    token: json['token'] as String,
    uid: json['uid'] as String,
    os: json['os'] as String,
    isActive: json['isActive'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'uid': uid,
    'os': os,
    'isActive': isActive,
  };
}

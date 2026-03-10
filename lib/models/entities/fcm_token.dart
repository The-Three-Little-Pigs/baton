class FCMToken {
  final String token;
  final String uid;
  final String deviceType;

  FCMToken({required this.token, required this.uid, required this.deviceType});

  factory FCMToken.fromJson(Map<String, dynamic> json) => FCMToken(
    token: json['token'] as String,
    uid: json['uid'] as String,
    deviceType: json['deviceType'] as String,
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'uid': uid,
    'deviceType': deviceType,
  };
}

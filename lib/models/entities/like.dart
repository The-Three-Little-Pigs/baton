class Like {
  final String liker;
  final String postId;

  Like({required this.liker, required this.postId});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      liker: json['liker'] as String,
      postId: json['post_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'liker': liker, 'post_id': postId};
  }

  Like copyWith({String? liker, String? postId}) {
    return Like(liker: liker ?? this.liker, postId: postId ?? this.postId);
  }
}

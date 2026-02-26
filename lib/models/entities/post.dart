class Post {
  final String postId;
  final String title;
  final double? purchasePrice;
  final double salePrice;
  final String imageUrl;
  final String content;
  final int likeCount;
  final int chatCount;
  final String category;
  final String authorId;
  final String createdAt;

  Post({
    required this.postId,
    required this.title,
    this.purchasePrice,
    required this.salePrice,
    required this.imageUrl,
    required this.content,
    required this.likeCount,
    required this.chatCount,
    required this.category,
    required this.authorId,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'],
      title: json['title'],
      purchasePrice: json['purchase_price'],
      salePrice: json['sale_price'],
      imageUrl: json['image_url'],
      content: json['content'],
      likeCount: json['like_count'],
      chatCount: json['chat_count'],
      category: json['category'],
      authorId: json['author_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'title': title,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'image_url': imageUrl,
      'content': content,
      'like_count': likeCount,
      'chat_count': chatCount,
      'category': category,
      'author_id': authorId,
      'created_at': createdAt,
    };
  }

  Post copyWith({
    String? postId,
    String? title,
    double? purchasePrice,
    double? salePrice,
    String? imageUrl,
    String? content,
    int? likeCount,
    int? chatCount,
    String? category,
    String? authorId,
    String? createdAt,
  }) {
    return Post(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      chatCount: chatCount ?? this.chatCount,
      category: category ?? this.category,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

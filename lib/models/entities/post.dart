class Post {
  final String postId;
  final String title;
  final double? purchasePrice;
  final double salePrice;
  final List<String> imageUrls;
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
    required this.imageUrls,
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
      imageUrls: json['image_url'],
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
      'image_url': imageUrls,
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
    List<String>? imageUrls,
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
      imageUrls: imageUrls ?? this.imageUrls,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      chatCount: chatCount ?? this.chatCount,
      category: category ?? this.category,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

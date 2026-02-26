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
}

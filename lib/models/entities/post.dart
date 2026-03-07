import 'package:baton/models/enum/category.dart';
import 'package:baton/models/enum/product_status.dart';

class Post {
  final String postId;
  final String title;
  final int? purchasePrice;
  final int? salePrice;
  final List<String> imageUrls;
  final String content;
  final int likeCount;
  final int chatCount;
  final Category category;
  final String authorId;
  final String createdAt;
  final ProductStatus status;

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
    required this.status,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'] as String,
      title: json['title'] as String,
      purchasePrice: json['purchase_price'] as int?,
      salePrice: json['sale_price'] as int?,
      imageUrls: List<String>.from(json['image_url'] ?? []),
      content: json['content'] as String,
      likeCount: json['like_count'] as int,
      chatCount: json['chat_count'] as int,
      category: Category.values.firstWhere((e) => e.name == json['category']),
      authorId: json['author_id'] as String,
      createdAt: json['created_at'] as String,
      status: ProductStatus.values.firstWhere((e) => e.name == json['status']),
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
      'category': category.name,
      'author_id': authorId,
      'created_at': createdAt,
      'status': status.name,
    };
  }

  Post copyWith({
    String? postId,
    String? title,
    int? purchasePrice,
    int? salePrice,
    List<String>? imageUrls,
    String? content,
    int? likeCount,
    int? chatCount,
    Category? category,
    String? authorId,
    String? createdAt,
    ProductStatus? status,
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
      status: status ?? this.status,
    );
  }
}

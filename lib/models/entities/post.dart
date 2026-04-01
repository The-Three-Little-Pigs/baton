import 'package:baton/models/enum/category.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId; // 게시글 아이디
  final String title; // 게시글 제목
  final int? purchasePrice; // 구매 가격
  final int? salePrice; // 판매 가격
  final List<String> imageUrls; // 게시글 이미지
  final String content; // 게시글 내용
  final int likeCount; // 좋아요 수
  final int chatCount; // 채팅방 수
  final Category category; // 카테고리
  final String authorId; // 작성자 아이디
  final DateTime createdAt; // 작성 시간
  final ProductStatus status; // 게시글 상태
  final int viewCount; // 🔥 추가: 조회수
  final String? buyerId; // 구매자 아이디
  final bool hiddenBySeller; // 판매 내역에서 숨김 여부
  final bool hiddenByBuyer; // 구매 내역에서 숨김 여부

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
    this.viewCount = 0,
    this.buyerId,
    this.hiddenBySeller = false,
    this.hiddenByBuyer = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'] as String? ?? '',
      title: json['title'] as String? ?? '제목 없음',
      purchasePrice: json['purchase_price'] as int?,
      salePrice: json['sale_price'] as int?,
      imageUrls: List<String>.from(json['image_url'] ?? []),
      content: json['content'] as String? ?? '',
      likeCount: json['like_count'] as int? ?? 0,
      chatCount: json['chat_count'] as int? ?? 0,
      category: Category.values.firstWhere(
        (e) => e.label == json['category'],
        orElse: () => Category.etc,
      ),
      authorId: json['author_id'] as String? ?? '',
      createdAt: _parseDateTime(json['created_at']),
      status: ProductStatus.values.firstWhere(
        (e) => e.label == json['status'] || e.name == json['status'],
        orElse: () {
          final s = json['status']?.toString() ?? '';
          if (s == '예약중' || s == '거래중' || s == '예약' || s == 'reserved') {
            return ProductStatus.reserved;
          }
          if (s == '판매완료' || s == 'sold') {
            return ProductStatus.sold;
          }
          return ProductStatus.available;
        },
      ),
      viewCount: json['view_count'] as int? ?? 0,
      buyerId: json['buyer_id'] as String?,
      hiddenBySeller: json['hidden_by_seller'] as bool? ?? false,
      hiddenByBuyer: json['hidden_by_buyer'] as bool? ?? false,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is int) {
      // Algolia는 초(seconds) 또는 밀리초(milliseconds) 단위로 저장할 수 있습니다.
      // 10자리 이하면 초 단위로 판단합니다.
      if (value < 10000000000) {
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    } else if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
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
      'category': category.label,
      'author_id': authorId,
      'created_at': createdAt,
      'status': status.label,
      'view_count': viewCount,
      'buyer_id': buyerId,
      'hidden_by_seller': hiddenBySeller,
      'hidden_by_buyer': hiddenByBuyer,
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
    DateTime? createdAt,
    ProductStatus? status,
    int? viewCount,
    String? buyerId,
    bool? hiddenBySeller,
    bool? hiddenByBuyer,
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
      viewCount: viewCount ?? this.viewCount,
      buyerId: buyerId ?? this.buyerId,
      hiddenBySeller: hiddenBySeller ?? this.hiddenBySeller,
      hiddenByBuyer: hiddenByBuyer ?? this.hiddenByBuyer,
    );
  }
}

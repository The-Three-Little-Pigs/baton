import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';

abstract class LikeRepository {
  /// 관심상품 토글 (관심상품 추가/삭제)
  Future<Result<void, Failure>> toggleLike(String postId, String userId);

  /// 사용자가 관심 누른 상품 페이징 조회
  Future<Result<List<Post>, Failure>> getLikedPosts(String userId);
}

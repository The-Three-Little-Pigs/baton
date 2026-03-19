import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/category.dart';

abstract class PostRepository {
  Future<Result<void, Failure>> createPost(Post post);
  Future<Result<void, Failure>> updatePost(Post post);
  Future<Result<void, Failure>> deletePost(String postId);
  Future<Result<List<Post>, Failure>> getPosts(
    Set<Category>? categories,
    DateTime? lastTime,
    String? lastPostId,
  );
  Future<Result<List<Post>, Failure>> getSalesHistory(String userId);
  Future<Result<List<Post>, Failure>> getPurchaseHistory(String userId);
  Future<Result<Post, Failure>> getPostById(String postId);
  Future<Result<void, Failure>> incrementViewCount(String postId);
}

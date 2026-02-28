import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';

abstract class PostRepository {
  Future<Result<void, Failure>> createPost(Post post);
  Future<Result<void, Failure>> updatePost(Post post);
  Future<Result<void, Failure>> deletePost(Post post);
  Future<Result<List<Post>, Failure>> getPosts();
}

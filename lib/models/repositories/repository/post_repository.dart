import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';

abstract class PostRepository {
  Future<Result> createPost(Post post);
  Future<Result> updatePost(Post post);
  Future<Result> deletePost(Post post);
  Future<Result> getPosts();
}

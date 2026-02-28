import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/repositories/repository/post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result> createPost(Post post) {
    _firestore.collection('posts').add(post.toJson());
  }

  @override
  Future<Result> deletePost(Post post) {
    throw UnimplementedError();
  }

  @override
  Future<Result> getPosts() {
    throw UnimplementedError();
  }

  @override
  Future<Result> updatePost(Post post) {
    throw UnimplementedError();
  }
}

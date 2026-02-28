import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/repositories/repository/post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepositoryImpl implements PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<void, Failure>> createPost(Post post) async {
    try {
      final docRef = _firestore.collection('posts').doc();

      await docRef.set(
        post.copyWith(postId: docRef.id).toJson(),
        SetOptions(merge: true),
      );

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> deletePost(Post post) async {
    try {
      final docRef = _firestore.collection('posts').doc(post.postId);
      await docRef.delete();

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<List<Post>, Failure>> getPosts() async {
    try {
      final snapshot = await _firestore.collection('posts').get();
      final posts = snapshot.docs
          .map((doc) => Post.fromJson(doc.data()))
          .toList();

      return Success(posts);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> updatePost(Post post) async {
    try {
      final docRef = _firestore.collection('posts').doc(post.postId);
      await docRef.update(post.toJson());

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }
}

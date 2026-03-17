import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/category.dart';
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
  Future<Result<void, Failure>> deletePost(String postId) async {
    try {
      final docRef = _firestore.collection('posts').doc(postId);
      await docRef.delete();

      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<List<Post>, Failure>> getPosts(
    Set<Category>? categories,
    DateTime? lastTime,
    String? lastPostId,
  ) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection('posts')
          .orderBy('created_at', descending: true);

      if (categories != null && categories.isNotEmpty) {
        final categoryNames = categories.map((c) => c.label).toList();
        query = query.where('category', whereIn: categoryNames);
      }

      if (lastTime != null) {
        // startAfter를 사용하여 이전 페이지의 마지막 데이터 이후부터 가져옴
        query = query.startAfter([Timestamp.fromDate(lastTime)]);
      }

      final snapshot = await query.limit(20).get();

      final posts = snapshot.docs
          .map((doc) => Post.fromJson(doc.data()))
          .toList();

      return Success(posts);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('데이터를 불러오는 중 오류가 발생했습니다: $e'));
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

  @override
  Future<Result<Post, Failure>> getPostById(String postId) async {
    try {
      final docRef = _firestore.collection('posts').doc(postId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return Error(ServerFailure('Post not found'));
      }

      final post = Post.fromJson(doc.data()!);
      return Success(post);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    }
  }

  @override
  Future<Result<List<Post>, Failure>> getPostBySearch(String keyword) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('title', arrayContains: keyword)
          .get();

      final posts = snapshot.docs
          .map((doc) => Post.fromJson(doc.data()))
          .toList();

      return Success(posts);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('데이터를 불러오는 중 오류가 발생했습니다: $e'));
    }
  }
}

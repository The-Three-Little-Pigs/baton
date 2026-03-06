import 'package:baton/models/enum/category.dart';
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
    } catch (e) {
      return Error(ServerFailure('데이터 저장 중 알 수 없는 오류가 발생했습니다: $e'));
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
    } catch (e) {
      return Error(ServerFailure('데이터 삭제 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }

  /// 카테고리에 맞게 post 가져오기(null이면 전체)
  @override
  Future<Result<List<Post>, Failure>> getPosts(
    Set<Category>? categories,
  ) async {
    try {
      final docRef = _firestore.collection('posts');

      if (categories?.isNotEmpty ?? false) {
        // Firestore는 Enum 타입을 직접 이해하지 못하므로, String(e.name)으로 변환하여 전달
        final categoryNames = categories!.map((e) => e.name).toList();
        final snapshot = await docRef
            .where('category', whereIn: categoryNames)
            .orderBy('createdAt', descending: true)
            .get();
        final posts = snapshot.docs
            .map((doc) => Post.fromJson(doc.data()))
            .toList();
        return Success(posts);
      }

      final snapshot = await docRef.get();
      final posts = snapshot.docs
          .map((doc) => Post.fromJson(doc.data()))
          .toList();
      return Success(posts);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('데이터를 불러오는 중 알 수 없는 오류가 발생했습니다: $e'));
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
    } catch (e) {
      return Error(ServerFailure('데이터 수정 중 알 수 없는 오류가 발생했습니다: $e'));
    }
  }
}

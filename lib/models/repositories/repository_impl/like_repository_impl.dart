import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/like.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/repositories/repository/like_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeRepositoryImpl implements LikeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<void, Failure>> toggleLike(String postId, String userId) async {
    try {
      final String likeDocId = '${userId}_$postId';
      final docRef = _firestore.collection('likes').doc(likeDocId);
      final postRef = _firestore.collection('posts').doc(postId);
      final likeDoc = await docRef.get();
      final batch = _firestore.batch();

      if (likeDoc.exists) {
        batch.delete(docRef);
        batch.update(postRef, {'like_count': FieldValue.increment(-1)});
      } else {
        final like = Like(liker: userId, postId: postId);
        batch.set(docRef, like.toJson());
        batch.update(postRef, {'like_count': FieldValue.increment(1)});
      }
      await batch.commit();
      return Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('관심상품 처리 중 알수 없는 오류가 발생했습니다:$e'));
    }
  }

  @override
  Future<Result<List<Post>, Failure>> getLikedPosts(String userId) async {
    try {
      final likeSnapshot = await _firestore
          .collection('likes')
          .where('liker', isEqualTo: userId)
          .get();

      final postIds = likeSnapshot.docs
          .map((doc) => doc['post_id'] as String)
          .toList();
      if (postIds.isEmpty) return Success([]);
      List<Post> likedPosts = [];
      for (var i = 0; i < postIds.length; i += 10) {
        int endIndex = i + 10;
        if (endIndex > postIds.length) endIndex = postIds.length;
        final chunk = postIds.sublist(i, endIndex);
        final postSnapshot = await _firestore
            .collection('posts')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        likedPosts.addAll(
          postSnapshot.docs.map((doc) => Post.fromJson(doc.data())).toList(),
        );
      }
      likedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Success(likedPosts);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('목록을 불러오는 중 오류가 발생했습니다: $e'));
    }
  }
}

import 'package:baton/core/database/baton_database.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/utils/logger.dart';
import 'package:baton/models/entities/alarm.dart';
import 'package:baton/models/entities/like.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/repositories/repository/like_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeRepositoryImpl implements LikeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BatonDatabase _database;

  LikeRepositoryImpl({required BatonDatabase database}) : _database = database;

  @override
  Future<Result<void, Failure>> toggleLike(String postId, String userId) async {
    if (postId.isEmpty || userId.isEmpty) {
      return Error(
        ServerFailure(
          '게시글 ID 또는 사용자 ID가 유효하지 않습니다. (userId: $userId, postId: $postId)',
        ),
      );
    }

    bool isLocalSuccess = false;
    try {
      // 1. 로컬 DB 선반반영 (낙관적 업데이트)
      await _database.toggleFavorite(postId);
      isLocalSuccess = true;

      // 2. 서버 반영
      final String likeDocId = '${userId}_$postId';
      final docRef = _firestore.collection('likes').doc(likeDocId);
      final postRef = _firestore.collection('posts').doc(postId);

      // 게시글 존재 여부 먼저 확인 (Batch Update 실패 방지)
      final postDoc = await postRef.get();
      if (!postDoc.exists) {
        throw FirebaseException(
          plugin: 'firestore',
          message: '해당 게시글이 존재하지 않습니다. (ID: $postId)',
        );
      }

      final likeDoc = await docRef.get();
      final batch = _firestore.batch();

      if (likeDoc.exists) {
        batch.delete(docRef);
        batch.update(postRef, {'like_count': FieldValue.increment(-1)});
      } else {
        final like = Like(liker: userId, postId: postId);
        batch.set(docRef, like.toJson());
        batch.update(postRef, {'like_count': FieldValue.increment(1)});

        final postData = postDoc.data()!;
        final String authorId = postData['author_id'];

        // --- Alarm 생성 연동 ---
        // 본인 게시글에 찜한 경우에는 알림을 보내지 않음
        if (userId != authorId) {
          // 찜한 사람의 닉네임 가져오기
          final currentUserDoc = await _firestore
              .collection('user')
              .doc(userId)
              .get();
          final String nickname = currentUserDoc.data()?['nickname'] ?? '누군가';

          final String title = postData['title']?.toString() ?? '제목 없음';
          final List<dynamic> imageUrls = postData['image_url'] is List
              ? postData['image_url']
              : [];
          final String firstImage = imageUrls.isNotEmpty
              ? imageUrls.first.toString()
              : '';

          final alarmRef = _firestore.collection('alarms').doc();
          final alarm = Alarm(
            alarmId: alarmRef.id,
            title: '내 상품 관심',
            content: '"$title" 상품이 새 관심을 받았어요.',
            imageUrl: firstImage,
            authorId: userId,
            receiverId: authorId,
            postId: postId, // 연관 게시물 아이디 추가
            createdAt: DateTime.now(),
            isRead: false,
          );

          batch.set(alarmRef, alarm.toJson());
        }
      }
      await batch.commit();
      return Success(null);
    } on FirebaseException catch (e, st) {
      logger.e('🔥 찜하기 실패 (FirebaseException): $e', stackTrace: st);
      // 실패 시 로컬 원복 (다시 토글하여 원래대로 되돌림)
      if (isLocalSuccess) {
        await _database.toggleFavorite(postId).catchError((_) {});
      }
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e, st) {
      logger.e('🔥 찜하기 실패 (일반에러): $e', stackTrace: st);
      if (isLocalSuccess) {
        await _database.toggleFavorite(postId).catchError((_) {});
      }
      return Error(ServerFailure('관심상품 처리 중 알수 없는 오류가 발생했습니다: $e'));
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
        // TODO: fromJson 오류 확인하기
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

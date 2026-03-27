import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/review_data.dart';
import 'package:baton/models/repositories/repository/review_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirebaseFirestore _firestore;

  ReviewRepositoryImpl(this._firestore);

  @override
  Future<Result<ReviewData, Failure>> createReview(ReviewData review) async {
    try {
      // 1. 중복 체크 (선택 사항이나 권장: 같은 방, 같은 작성자)
      final existing = await _firestore
          .collection('reviews')
          .where('roomId', isEqualTo: review.roomId)
          .where('writerId', isEqualTo: review.writerId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return Error<ReviewData, Failure>(
          DatabaseFailure('이미 해당 거래에 대한 후기를 작성하셨습니다.'),
        );
      }

      // 2. 저장
      final docRef = _firestore.collection('reviews').doc();
      final newReview = review.copyWith(reviewId: docRef.id);

      await docRef.set(newReview.toFirestore());

      // [참고] 향후 여기에서 상대방 User의 온도나 평점 평균을 계산하는 트랜잭션 로직을 추가할 수 있습니다.

      return Success<ReviewData, Failure>(newReview);
    } catch (e) {
      return Error<ReviewData, Failure>(
        ServerFailure('후기 작성 실패: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<ReviewData?, Failure>> getReviewByRoomAndWriter({
    required String roomId,
    required String writerId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('roomId', isEqualTo: roomId)
          .where('writerId', isEqualTo: writerId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Success<ReviewData?, Failure>(null);
      }
      return Success<ReviewData?, Failure>(
        ReviewData.fromFirestore(snapshot.docs.first),
      );
    } catch (e) {
      return Error<ReviewData?, Failure>(
        ServerFailure('후기 조회 실패: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<ReviewData>, Failure>> getReceivedReviews(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('receiverId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs
          .map((doc) => ReviewData.fromFirestore(doc))
          .toList();
      return Success<List<ReviewData>, Failure>(reviews);
    } catch (e) {
      return Error<List<ReviewData>, Failure>(
        ServerFailure('받은 후기 목록 조회 실패: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<ReviewData>, Failure>> getSentReviews(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('writerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs
          .map((doc) => ReviewData.fromFirestore(doc))
          .toList();
      return Success<List<ReviewData>, Failure>(reviews);
    } catch (e) {
      return Error<List<ReviewData>, Failure>(
        ServerFailure('보낸 후기 목록 조회 실패: ${e.toString()}'),
      );
    }
  }

  @override
  Stream<List<ReviewData>> watchReceivedReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('receiverId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReviewData.fromFirestore(doc)).toList());
  }

  @override
  Stream<List<ReviewData>> watchSentReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('writerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReviewData.fromFirestore(doc)).toList());
  }

  // TODO: 리버팟 사용해서 데이터 가져오기
  @override
  Future<Result<Chatroom?, Failure>> getChatRoomByPostId(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('chatrooms')
          .where('post_id', isEqualTo: postId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Success<Chatroom?, Failure>(null);
      }

      return Success<Chatroom?, Failure>(
        Chatroom.fromFirestore(snapshot.docs.first),
      );
    } catch (e) {
      return Error<Chatroom?, Failure>(
        ServerFailure('채팅방 정보를 가져오지 못했습니다: ${e.toString()}'),
      );
    }
  }
}

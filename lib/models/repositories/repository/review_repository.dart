import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/models/entities/review_data.dart';

abstract class ReviewRepository {
  /// 후기 작성
  Future<Result<ReviewData, Failure>> createReview(ReviewData review);

  /// 특정 채팅방에서 내가 이미 후기를 썼는지 확인 (중복 방지 + 수정용)
  Future<Result<ReviewData?, Failure>> getReviewByRoomAndWriter({
    required String roomId,
    required String writerId,
  });

  /// 상대방이 나에게 보낸 후기 리스트 (프로필 탭 가로 스크롤용)
  Future<Result<List<ReviewData>, Failure>> getReceivedReviews(String userId);

  /// 상대방이 나에게 보낸 후기 실시간 스트림
  Stream<List<ReviewData>> watchReceivedReviews(String userId);

  /// 내가 다른 사람에게 보낸 후기 리스트 (보낸 후기 관리용)
  Future<Result<List<ReviewData>, Failure>> getSentReviews(String userId);

  /// 내가 다른 사람에게 보낸 후기 실시간 스트림
  Stream<List<ReviewData>> watchSentReviews(String userId);

  /// 특정 게시글 아이디로 연관된 채팅방 찾기 (거래 내역에서 후기 작성용)
  Future<Result<Chatroom?, Failure>> getChatRoomByPostId(String postId);
}

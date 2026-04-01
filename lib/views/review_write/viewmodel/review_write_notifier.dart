import 'package:baton/core/di/repository/review_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/review_data.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_write_notifier.g.dart';

class ReviewWriteState {
  final double rating;
  final String content;
  final bool isLoading;

  ReviewWriteState({
    this.rating = 0.0,
    this.content = '',
    this.isLoading = false,
  });

  ReviewWriteState copyWith({
    double? rating,
    String? content,
    bool? isLoading,
  }) {
    return ReviewWriteState(
      rating: rating ?? this.rating,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get canSubmit => rating > 0;
}

@riverpod
class ReviewWriteNotifier extends _$ReviewWriteNotifier {
  @override
  ReviewWriteState build() => ReviewWriteState();

  void updateRating(double rating) {
    state = state.copyWith(rating: rating);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content);
  }

  Future<String?> submitReview({
    required String receiverId,
    required String postId,
    required String roomId,
  }) async {
    final myUserId = ref.read(userProvider).value?.uid ?? '';
    if (myUserId.isEmpty) return '사용자 정보를 찾을 수 없습니다.';

    state = state.copyWith(isLoading: true);

    final review = ReviewData(
      reviewId: '', // 서버에서 생성
      writerId: myUserId,
      receiverId: receiverId,
      postId: postId,
      roomId: roomId,
      rating: state.rating,
      content: state.content.trim().isEmpty ? null : state.content.trim(),
      createdAt: DateTime.now(),
    );

    final repository = ref.read(reviewRepositoryProvider);
    final result = await repository.createReview(review);

    state = state.copyWith(isLoading: false);

    return switch (result) {
      Success() => null,
      Error(:final failure) => failure.message,
    };
  }
}

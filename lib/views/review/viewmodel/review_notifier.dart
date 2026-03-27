import 'package:baton/core/di/repository/review_provider.dart';
import 'package:baton/models/entities/review_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_notifier.g.dart';

@riverpod
Stream<List<ReviewData>> receivedReviews(Ref ref, String userId) {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.watchReceivedReviews(userId);
}

@riverpod
Stream<List<ReviewData>> sentReviews(Ref ref, String userId) {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.watchSentReviews(userId);
}

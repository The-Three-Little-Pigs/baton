import 'package:baton/core/di/repository/review_provider.dart';
import 'package:baton/core/result/result.dart' as res; // 별칭(res)을 주어 충돌 방지
import 'package:baton/models/entities/review_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_notifier.g.dart';

@riverpod
Future<List<ReviewData>> receivedReviews(Ref ref, String userId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getReceivedReviews(userId);

  return switch (result) {
    res.Success(value: final reviews) => reviews,
    res.Error(:final failure) => throw Exception(failure.message),
  };
}

@riverpod
Future<List<ReviewData>> sentReviews(Ref ref, String userId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final result = await repository.getSentReviews(userId);

  return switch (result) {
    res.Success(value: final reviews) => reviews,
    res.Error(:final failure) => throw Exception(failure.message),
  };
}

// lib/views/chat_detail/viewmodel/has_written_review_provider.dart

import 'package:baton/core/di/repository/review_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'has_written_review_provider.g.dart';

/// 특정 채팅방에서 현재 사용자가 이미 후기를 작성했는지 확인합니다.
///
/// - [roomId]: 확인할 채팅방 ID
/// - [writerId]: 확인할 작성자 UID (보통 현재 로그인 사용자)
///
/// 에러 발생 시 보수적으로 `false`를 반환하여 버튼을 활성 상태로 유지합니다.
@riverpod
Future<bool> hasWrittenReview(
  Ref ref, {
  required String roomId,
  required String writerId,
}) async {
  final repo = ref.watch(reviewRepositoryProvider);
  final result = await repo.getReviewByRoomAndWriter(
    roomId: roomId,
    writerId: writerId,
  );
  return switch (result) {
    Success(value: final review) => review != null,
    Error() => false,
  };
}

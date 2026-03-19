import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/repositories/repository/like_repository.dart';
import 'package:baton/models/repositories/repository_impl/like_repository_impl.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_notifier.g.dart';

@riverpod
LikeRepository likeRepository(Ref ref) {
  return LikeRepositoryImpl();
}

@Riverpod(keepAlive: true)
class LikeNotifier extends _$LikeNotifier {
  @override
  FutureOr<List<Post>> build() async {
    final user = ref.watch(userProvider);
    final currentUserId = user.value?.uid ?? "";
    return _fetchLikedPosts(currentUserId);
  }

  Future<List<Post>> _fetchLikedPosts(String currentUserId) async {
    final repository = ref.read(likeRepositoryProvider);
    final result = await repository.getLikedPosts(currentUserId);

    switch (result) {
      case Success(:final value):
        return value; // 성공 시 리스트 반환
      case Error(:final failure):
        throw Exception(failure.message); // 에러 시 throw
    }
  }

  Future<void> toggleLike(Post post) async {
    final currentUserId = ref.read(userProvider).value?.uid ?? "";
    final previousState = state; // 실패 시 원복을 위한 보험 데이터

    // (1) UI 낙관적 렌더링 - 서버를 기다리지 않고 화면용 데이터부터 먼저 조작!
    if (state.value != null) {
      final currentList = List<Post>.from(state.value!);

      // 이미 찜한 리스트에 있는지 확인
      final isLikedIndex = currentList.indexWhere(
        (p) => p.postId == post.postId,
      );
      if (isLikedIndex >= 0) {
        currentList.removeAt(isLikedIndex); // 있었으면 목록에서 삭제
      } else {
        // 없었으면 맨 앞에 삽입. 그리고 (화면만이라도) 카운트 1 올린 가짜 복사본을 보여줌
        final updatedPost = post.copyWith(likeCount: post.likeCount + 1);
        currentList.insert(0, updatedPost);
      }

      // 상태 갱신 방송. "앱 안의 모든 하트 위젯들아! 방금 데이터 이거야! 다 즉시 바뀌어라!"
      state = AsyncData(currentList);
    }
    // (2) 이제 백그라운드에서 진짜 통신 진행
    final repository = ref.read(likeRepositoryProvider);
    final result = await repository.toggleLike(post.postId, currentUserId);
    // (3) 실패 시에만 유저 화면을 이전 데이터로 되돌림(Rollback)
    switch (result) {
      case Success():
        break; // 성공 시 아무것도 안 함
      case Error():
        state = previousState; // 실패 시 원복
        break;
    }
  }
}

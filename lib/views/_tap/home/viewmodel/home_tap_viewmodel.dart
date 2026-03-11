import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_tap_viewmodel.g.dart';

@riverpod
class HomeTapViewModel extends _$HomeTapViewModel {
  DateTime? _lastTime;
  String? _lastPostId;
  bool _isLastDoc = false;

  @override
  Future<List<Post>> build() async {
    final categories = ref.watch(categoryChipsProvider);

    _lastTime = null;
    _lastPostId = null;
    _isLastDoc = false;

    final result = await ref
        .read(postRepositoryProvider)
        .getPosts(categories, null, null);

    return switch (result) {
      Success(value: final posts) => _processNewPosts(posts),
      Error(failure: final failure) => throw failure.message,
    };
  }

  /// 새로운 포스트 리스트를 받았을 때 상태를 갱신하는 로직
  List<Post> _processNewPosts(List<Post> posts) {
    if (posts.isEmpty) {
      _isLastDoc = true;
    } else {
      _lastTime = posts.last.createdAt;
      _lastPostId = posts.last.postId;

      if (posts.length < 20) _isLastDoc = true;
    }
    return posts;
  }

  Future<void> fetchPosts() async {
    if (state.isLoading || _isLastDoc) return;
    if (!state.hasValue) return;

    final categories = ref.read(categoryChipsProvider);

    final previousPosts = state.value!;

    final result = await ref
        .read(postRepositoryProvider)
        .getPosts(categories, _lastTime, _lastPostId);

    switch (result) {
      case Success(value: final newPosts):
        final processedPosts = _processNewPosts(newPosts);
        // 기존 데이터 뒤에 새 데이터 붙이기 (Append)
        state = AsyncData([...previousPosts, ...processedPosts]);

      case Error(failure: final failure):
        // 추가 로딩 실패 시 에러 상태로 덮어쓰거나 토스트 알림 처리를 할 수 있음
        state = AsyncError(failure.message, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/category.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_tap_viewmodel.g.dart';

class HomeTapState {
  final List<Post> posts;
  final DateTime? lastTime;
  final String? lastPostId;
  final bool isLastDoc;
  final bool isFetchingMore;

  HomeTapState({
    required this.posts,
    this.lastTime,
    this.lastPostId,
    required this.isLastDoc,
    this.isFetchingMore = false,
  });

  HomeTapState copyWith({
    List<Post>? posts,
    DateTime? lastTime,
    String? lastPostId,
    bool? isLastDoc,
    bool? isFetchingMore,
  }) {
    return HomeTapState(
      posts: posts ?? this.posts,
      lastTime: lastTime ?? this.lastTime,
      lastPostId: lastPostId ?? this.lastPostId,
      isLastDoc: isLastDoc ?? this.isLastDoc,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

@riverpod
class HomeTapViewModel extends _$HomeTapViewModel {
  @override
  Future<HomeTapState> build() async {
    // 카테고리 변경 시 자동으로 build가 다시 실행되도록 감시
    final categories = ref.watch(categoryChipsProvider);
    //   return _fetchPosts(categories: categories);
    // }
    ref.watch(userProvider);

    /// 공통 데이터 페칭 및 상태 생성 로직
    Future<HomeTapState> _fetchPosts({
      required Set<Category> categories,
      DateTime? lastTime,
      String? lastPostId,
      List<Post> previousPosts = const [],
    }) async {
      final result = await ref
          .read(postRepositoryProvider)
          .getPosts(categories, lastTime, lastPostId);

      return switch (result) {
        // Success(value: final newPosts) => _createState(newPosts, previousPosts),
        Success(value: final posts) => _processNewPosts(
          filterBlockedPosts(posts),
        ),
        Error(failure: final failure) => throw failure.message,
      };
    }

    /// 새로운 포스트 리스트를 기반으로 HomeTapState를 생성하는 로직
    HomeTapState _createState(List<Post> newPosts, List<Post> previousPosts) {
      final isLast = newPosts.isEmpty || newPosts.length < 20;
      final combinedPosts = [...previousPosts, ...newPosts];

      return HomeTapState(
        posts: combinedPosts,
        lastTime: combinedPosts.isNotEmpty
            ? combinedPosts.last.createdAt
            : null,
        lastPostId: combinedPosts.isNotEmpty ? combinedPosts.last.postId : null,
        isLastDoc: isLast,
        isFetchingMore: false,
      );
    }

    Future<void> fetchPosts() async {
      final currentState = state.value;
      // 이미 로딩 중이거나 데이터가 없거나 마지막 데이터인 경우 중복 호출 방지
      if (state.isLoading ||
          currentState == null ||
          currentState.isFetchingMore ||
          currentState.isLastDoc) {
        return;
      }

      // 기존 데이터를 유지한 채로 내부 로딩 상태만 표시 (isFetchingMore: true)
      state = AsyncData(currentState.copyWith(isFetchingMore: true));

      // try {
      //   final newState = await _fetchPosts(
      //     categories: ref.read(categoryChipsProvider),
      //     lastTime: currentState.lastTime,
      //     lastPostId: currentState.lastPostId,
      //     previousPosts: currentState.posts,
      //   );
      //   state = AsyncData(newState);
      // } catch (e, st) {
      //   state = AsyncError(e, st);
      final previousPosts = state.value!;

      final result = await ref
          .read(postRepositoryProvider)
          .getPosts(categories, _lastTime, _lastPostId);

      switch (result) {
        case Success(value: final newPosts):
          final processedPosts = _processNewPosts(filterBlockedPosts(newPosts));
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

    List<Post> filterBlockedPosts(List<Post> posts) {
      final currentUser = ref.watch(userProvider).value;
      if (currentUser == null) return posts;

      final blockedUsers = currentUser.blockedUsers;
      final blockedByUsers = currentUser.blockedBy;

      final allHiddenUsers = {...blockedUsers, ...blockedByUsers};
      if (allHiddenUsers.isEmpty) return posts;

      return posts
          .where((post) => !allHiddenUsers.contains(post.authorId))
          .toList();
    }
  }
}

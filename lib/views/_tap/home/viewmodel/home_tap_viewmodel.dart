import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/category.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // ⭐️ 최적화 포인트 1: '내가 차단한 목록'의 실제 내용물이 바뀔 때만 새로고침 트리거
    // .join(',')을 통해 List(객체 비교)가 아닌 String(값 비교)으로 감시 범위를 좁혔습니다.
    // 상대방이 나를 차단해서 내 데이터가 업데이트되어도, 내 차단 목록이 그대로면 무시됩니다.
    ref.watch(
      userProvider.select((user) => user.value?.blockedUsers.join(',')),
    );

    // 카테고리 변경 감시
    final categories = ref.watch(categoryChipsProvider);

    return _fetchPosts(categories: categories);
  }

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
      // ⭐️ 최적화 포인트 2: 필터링 로직 적용 (filterBlockedPosts를 거쳐서 상태 생성)
      Success(value: final newPosts) => _createState(
        filterBlockedPosts(newPosts),
        previousPosts,
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
      lastTime: combinedPosts.isNotEmpty ? combinedPosts.last.createdAt : null,
      lastPostId: combinedPosts.isNotEmpty ? combinedPosts.last.postId : null,
      isLastDoc: isLast,
      isFetchingMore: false,
    );
  }

  /// 기존 데이터를 유지한 채로 추가 로딩 (Pagination)
  Future<void> fetchPosts() async {
    final currentState = state.value;
    if (state.isLoading ||
        currentState == null ||
        currentState.isFetchingMore ||
        currentState.isLastDoc) {
      return;
    }

    state = AsyncData(currentState.copyWith(isFetchingMore: true));

    try {
      final newState = await _fetchPosts(
        categories: ref.read(categoryChipsProvider),
        lastTime: currentState.lastTime,
        lastPostId: currentState.lastPostId,
        previousPosts: currentState.posts,
      );
      state = AsyncData(newState);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// 차단한 사용자 및 나를 차단한 사용자의 게시물을 필터링
  List<Post> filterBlockedPosts(List<Post> posts) {
    // ⭐️ 최적화 포인트 3: 여기서는 watch 대신 read를 사용합니다.
    // build에서 이미 필요한 시점에만 새로고침을 수행하므로, 여기서 watch를 하면 필터링이 꼬이게 됩니다.
    final currentUser = ref.read(userProvider).value;
    if (currentUser == null) return posts;

    final blockedUsers = currentUser.blockedUsers;
    final blockedByUsers = currentUser.blockedBy;

    // 내가 차단한 사람 + 나를 차단한 사람 모두 합침
    final allHiddenUsers = {...blockedUsers, ...blockedByUsers};
    if (allHiddenUsers.isEmpty) return posts;

    return posts
        .where((post) => !allHiddenUsers.contains(post.authorId))
        .toList();
  }
}

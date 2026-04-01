import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/views/search_result/viewmodel/search_result_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_result_viewmodel.g.dart';

@riverpod
class SearchResultViewModel extends _$SearchResultViewModel {
  @override
  FutureOr<SearchResultState> build(String keyword) async {
    final postRepository = ref.read(postRepositoryProvider);
    final result = await postRepository.getPostBySearch(keyword, page: 0);

    return switch (result) {
      Success(:final value) => SearchResultState(
          posts: value,
          currentPage: 0,
          isLastPage: value.length < 20,
        ),
      Error(:final failure) => throw Exception(failure.message),
    };
  }

  /// 추가 데이터 로드 (Pagination)
  Future<void> fetchMore() async {
    final currentState = state.value;
    if (state.isLoading ||
        currentState == null ||
        currentState.isFetchingMore ||
        currentState.isLastPage) {
      return;
    }

    // 로딩 상태 업데이트 (UI에서 isFetchingMore를 감시할 수 있음)
    state = AsyncData(currentState.copyWith(isFetchingMore: true));

    final nextPage = currentState.currentPage + 1;
    final postRepository = ref.read(postRepositoryProvider);
    final result = await postRepository.getPostBySearch(keyword, page: nextPage);

    state = await AsyncValue.guard(() async {
      return switch (result) {
        Success(:final value) => currentState.copyWith(
            posts: [...currentState.posts, ...value],
            currentPage: nextPage,
            isLastPage: value.length < 20,
            isFetchingMore: false,
          ),
        Error(:final failure) => throw Exception(failure.message),
      };
    });
  }

  /// 필터 토글: 정가 이하
  void toggleUnderPurchasePrice() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData(currentState.copyWith(
      isUnderPurchasePrice: !currentState.isUnderPurchasePrice,
    ));
  }

  /// 필터 토글: 판매중인 상품
  void toggleIsAvailableOnly() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData(currentState.copyWith(
      isAvailableOnly: !currentState.isAvailableOnly,
    ));
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

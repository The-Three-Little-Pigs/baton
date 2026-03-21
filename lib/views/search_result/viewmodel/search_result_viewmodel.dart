import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_result_viewmodel.g.dart';

@riverpod
class SearchResultViewModel extends _$SearchResultViewModel {
  @override
  FutureOr<List<Post>> build(String keyword) async {
    final postRepository = ref.read(postRepositoryProvider);
    final result = await postRepository.getPostBySearch(keyword);

    return switch (result) {
      Success(:final value) => value,
      Error(:final failure) => throw Exception(failure.message),
    };
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final postRepository = ref.read(postRepositoryProvider);
      final result = await postRepository.getPostBySearch(keyword);
      return switch (result) {
        Success(:final value) => value,
        Error(:final failure) => throw Exception(failure.message),
      };
    });
  }
}

import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_tap_viewmodel.g.dart';

@riverpod
class HomeTapViewModel extends _$HomeTapViewModel {
  @override
  Future<List<Post>> build() async {
    final categories = ref.watch(categoryChipsProvider);
    final result = await ref.read(postRepositoryProvider).getPosts(categories);

    return switch (result) {
      Success(value: final posts) => posts,
      Error(failure: final failure) => throw failure.message,
    };
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => build());
  }
}

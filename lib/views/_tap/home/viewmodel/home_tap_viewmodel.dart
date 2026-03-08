import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_tap_viewmodel.g.dart';

@riverpod
class HomeTapViewModel extends _$HomeTapViewModel {
  DateTime? _lastTime;
  bool _isLastDoc = false;
  bool _isLoading = false;

  @override
  Future<List<Post>> build() async {
    final categories = ref.watch(categoryChipsProvider);
    final result = await ref.read(postRepositoryProvider).getPosts(categories);

    return switch (result) {
      Success(value: final posts) => posts,
      Error(failure: final failure) => throw failure.message,
    };
  }

  Future<void> fetchPosts() async {
    if (_isLoading || _isLastDoc) return;
  }

  Future<void> refresh() async {
    state = AsyncData([]);
  }
}

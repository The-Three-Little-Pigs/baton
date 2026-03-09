import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'similar_product_notifier.g.dart';

@riverpod
class SimilarProductNotifier extends _$SimilarProductNotifier {
  @override
  Future<List<Post>> build(Category category, String currentPostId) async {
    return _fetchSimilarProducts(category, currentPostId);
  }

  Future<List<Post>> _fetchSimilarProducts(
    Category category,
    String currentPostId,
  ) async {
    final postRepository = ref.read(postRepositoryProvider);
    final result = await postRepository.getPosts({category}, null, null);

    switch (result) {
      case Success(value: final posts):
        final filteredPosts = posts
            .where((post) => post.postId != currentPostId)
            .take(6)
            .toList();
        return filteredPosts;
      case Error(failure: final f):
        throw f;
    }
  }
}

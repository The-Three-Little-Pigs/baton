import 'package:baton/core/di/service/algolia_provider.dart';
import 'package:baton/models/repositories/repository/post_repository.dart';
import 'package:baton/models/repositories/repository_impl/post_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(Ref ref) {
  final algoliaService = ref.watch(algoliaServiceProvider);
  return PostRepositoryImpl(algoliaService: algoliaService);
}

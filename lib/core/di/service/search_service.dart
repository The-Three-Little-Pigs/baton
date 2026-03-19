import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/di/repository/search_provider.dart';
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:baton/service/search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_service.g.dart';

@riverpod
SearchService searchService(Ref ref) {
  return SearchService(
    userRepository: ref.watch(userRepositoryProvider),
    searchRepository: ref.watch(searchRepositoryProvider),
    postRepository: ref.watch(postRepositoryProvider),
  );
}

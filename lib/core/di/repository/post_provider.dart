import 'package:baton/models/repositories/repository/post_repository.dart';
import 'package:baton/models/repositories/repository_impl/post_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

@riverpod
PostRepository postRepositoryProvider(Ref ref) {
  return PostRepositoryImpl();
}

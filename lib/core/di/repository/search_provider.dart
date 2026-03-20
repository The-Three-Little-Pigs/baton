import 'package:baton/models/repositories/repository/search_repository.dart';
import 'package:baton/models/repositories/repository_impl/search_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
SearchRepository searchRepository(Ref ref) {
  return SearchRepositoryImpl();
}

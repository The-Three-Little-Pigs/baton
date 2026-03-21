import 'package:baton/core/di/db/db_provider.dart';
import 'package:baton/models/entities/search_history.dart';
import 'package:baton/models/repositories/repository/search_repository.dart';
import 'package:baton/models/repositories/repository_impl/search_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

@riverpod
SearchRepository searchRepository(Ref ref) {
  return SearchRepositoryImpl(
    firestore: FirebaseFirestore.instance,
    database: ref.watch(batonDatabaseProvider),
  );
}

/// 로컬 검색 기록 스트림 프로바이더
@riverpod
Stream<List<SearchHistory>> recentlySearchHistory(Ref ref) {
  return ref.watch(searchRepositoryProvider).watchLocalSearchHistory();
}

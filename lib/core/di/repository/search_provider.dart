import 'package:baton/core/di/db/db_provider.dart';
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

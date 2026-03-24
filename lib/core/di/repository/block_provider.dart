import 'package:baton/core/di/db/db_provider.dart';
import 'package:baton/models/repositories/repository/block_repository.dart';
import 'package:baton/models/repositories/repository_impl/block_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_provider.g.dart';

@riverpod
BlockRepository blockRepository(Ref ref) {
  final database = ref.watch(batonDatabaseProvider);
  return BlockRepositoryImpl(database: database);
}

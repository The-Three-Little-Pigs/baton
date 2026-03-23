// lib/core/di/service/algolia_provider.dart

import 'package:baton/service/algolia/algolia_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'algolia_provider.g.dart';

@Riverpod(keepAlive: true)
AlgoliaService algoliaService(Ref ref) {
  final service = AlgoliaService();
  ref.onDispose(() => service.dispose());
  return service;
}

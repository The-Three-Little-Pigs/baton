// lib/core/di/repository/user_provider.dart
import 'package:baton/models/repositories/repository/user_repository.dart';
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
UserRepository userRepositoryProvider(Ref ref) {
  return UserRepositoryImpl();
}

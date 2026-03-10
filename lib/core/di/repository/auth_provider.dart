import 'package:baton/models/repositories/repository/auth_repository.dart';
import 'package:baton/models/repositories/repository_impl/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl();
}

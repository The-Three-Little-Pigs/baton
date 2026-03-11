import 'package:baton/core/di/repository/auth_provider.dart';
import 'package:baton/core/di/repository/user_provider.dart';
import 'package:baton/service/login_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_service.g.dart';

@riverpod
LoginService loginService(Ref ref) {
  return LoginService(
    ref.read(authRepositoryProvider),
    ref.read(userRepositoryProvider),
  );
}

import 'package:baton/core/di/service/login_service.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/login_status.dart';
import 'package:baton/models/enum/social_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_page_view_model.g.dart';

@riverpod
class LoginPageViewModel extends _$LoginPageViewModel {
  @override
  Future<LoginStatus?> build() async {
    return null;
  }

  Future<void> login(SocialType type) async {
    state = AsyncLoading();

    final result = switch (type) {
      SocialType.kakao =>
        await ref.read(loginServiceProvider).signInWithKakao(),
      SocialType.apple =>
        await ref.read(loginServiceProvider).signInWithApple(),
      SocialType.google =>
        await ref.read(loginServiceProvider).signInWithGoogle(),
    };
    print("result : $result");

    switch (result) {
      case Success(value: final status):
        state = AsyncData(status);
      case Error(failure: final failure):
        print(failure.message);
        state = AsyncError(failure.message, StackTrace.current);
        throw failure.message;
    }
  }
}

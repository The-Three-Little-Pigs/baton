import 'package:baton/core/di/service/login_service.dart';
import 'package:baton/notifier/user/user_notifier.dart';

import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/login_status.dart';
import 'package:baton/models/enum/social_type.dart';
import 'package:baton/core/utils/logger.dart';
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
    ref.read(authTransitionProvider.notifier).start();

    try {
      final result = switch (type) {
        SocialType.kakao =>
          await ref.read(loginServiceProvider).signInWithKakao(),
        SocialType.apple =>
          await ref.read(loginServiceProvider).signInWithApple(),
        SocialType.google =>
          await ref.read(loginServiceProvider).signInWithGoogle(),
      };
      logger.d("result : $result");

      switch (result) {
        case Success(value: final status):
          // [추가] 로그인 성공 시 전역 유저 정보를 초기화하여 최신 정보를 가져오도록 유도
          ref.invalidate(userProvider);
          state = AsyncData(status);
        case Error(failure: final failure):
          logger.e(failure.message);
          state = AsyncError(failure.message, StackTrace.current);
          throw failure.message;
      }
    } finally {
      ref.read(authTransitionProvider.notifier).end();
    }
  }
}

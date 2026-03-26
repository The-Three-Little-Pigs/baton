import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:baton/models/entities/login_status.dart';
import 'package:baton/models/enum/social_type.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/login/viewmodel/login_page_view_model.dart';

import 'package:baton/views/login/widgets/social_login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 💡 로그인된 상태(Firebase Auth)라면 즉시 로딩 화면을 보여주어 로그인 UI 노출을 원천 차단
    final isFirebaseLoggedIn =
        ref.watch(userProvider).maybeWhen(data: (user) => user != null, orElse: () => false) ||
        FirebaseAuth.instance.currentUser != null;

    if (isFirebaseLoggedIn) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    ref.listen(

      loginPageViewModelProvider,
      (previous, next) {
        next.whenData((status) {
          if (status == null) return;

          switch (status) {
            case ExistingUser():
              context.goNamed('home');
            case NewUser():
              context.pushNamed('signUp');
          }
        });
      },
      onError: (error, stackTrace) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString()))),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 186),
            // 로고 및 서비스 명
            Column(
              children: [
                Image.asset('assets/icons/logo.png', width: 120, height: 120),
                AppSpacing.h16,
                const Text(
                  'BATON',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 77),
            // 소셜 로그인 버튼 영역
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  SocialLoginButton(
                    text: 'Google 로그인',
                    iconPath: 'assets/icons/google.png',
                    backgroundColor: Colors.white,
                    onTap: () async {
                      ref
                          .read(loginPageViewModelProvider.notifier)
                          .login(SocialType.google);
                    },
                  ),
                  SocialLoginButton(
                    text: '카카오 로그인',
                    iconPath: 'assets/icons/kakao.png',
                    backgroundColor: const Color(0xFFFFE812), // 카카오 노란색
                    onTap: () async {
                      ref
                          .read(loginPageViewModelProvider.notifier)
                          .login(SocialType.kakao);
                    },
                  ),
                  SocialLoginButton(
                    text: 'Apple 로그인',
                    iconPath: 'assets/icons/apple.png',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () async {
                      ref
                          .read(loginPageViewModelProvider.notifier)
                          .login(SocialType.apple);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

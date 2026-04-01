import 'package:baton/core/utils/logger.dart';
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
import 'package:baton/core/utils/ui/app_snackbar.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isSlowLoading = false;

  @override
  void initState() {
    super.initState();
    // 7초 후에도 로딩 중이면 메시지 표시
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          _isSlowLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    // 💡 로그인된 상태(Firebase Auth)라면 즉시 로딩 화면을 보여주어 로그인 UI 노출을 원천 차단
    final isFirebaseLoggedIn =
        userAsync.maybeWhen(data: (user) => user != null, orElse: () => false) ||
            FirebaseAuth.instance.currentUser != null;

    if (isFirebaseLoggedIn) {
      logger.i(
        "[LoginPage] Rendering Loading Spinner. UserAsyncStatus: ${userAsync.isLoading ? 'Loading' : 'Idle'}, AuthUser: ${FirebaseAuth.instance.currentUser?.uid}",
      );
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              if (_isSlowLoading) ...[
                const SizedBox(height: 24),
                const Text(
                  "데이터를 불러오는 데 시간이 걸리고 있습니다.",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    ref.invalidate(userProvider);
                  },
                  child: const Text("로그아웃 후 다시 시도"),
                ),
              ],
            ],
          ),
        ),
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
      onError: (error, stackTrace) => AppSnackBar.show(context, error.toString()),
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

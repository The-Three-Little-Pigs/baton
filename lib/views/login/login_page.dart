import 'package:baton/service/login_service.dart';
import 'package:baton/views/login/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Expanded(flex: 6, child: SizedBox(height: 400)),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SocialLoginButton(
                    text: '구글로 로그인하기',
                    backgroundColor: Colors.white,
                    onTap: () async {
                      final success = await ref
                          .read(loginViewModelProvider.notifier)
                          .googleLogin();
                      if (success && context.mounted) {
                        context.go('/signUp');
                      }
                    },
                  ),
                  SocialLoginButton(
                    text: '카카오로 로그인하기',
                    backgroundColor: const Color(0xFFFEE500),
                    onTap: () async {
                      final success = await ref
                          .read(loginViewModelProvider.notifier)
                          .kakaoLogin();
                      if (success && context.mounted) {
                        context.go('/signUp');
                      }
                    },
                  ),
                  SocialLoginButton(
                    text: '애플로 로그인하기',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () {
                      // TODO: Apple Login Implementation
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

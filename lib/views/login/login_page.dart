import 'package:baton/models/entities/login_status.dart';
import 'package:baton/models/enum/social_type.dart';
import 'package:baton/views/login/viewmodel/login_page_view_model.dart';
import 'package:baton/views/login/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      ref
                          .read(loginPageViewModelProvider.notifier)
                          .login(SocialType.google);
                    },
                  ),
                  SocialLoginButton(
                    text: '카카오로 로그인하기',
                    backgroundColor: const Color(0xFFFEE500),
                    onTap: () async {
                      ref
                          .read(loginPageViewModelProvider.notifier)
                          .login(SocialType.kakao);
                    },
                  ),
                  SocialLoginButton(
                    text: '애플로 로그인하기',
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
          ),
        ],
      ),
    );
  }
}

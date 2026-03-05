import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(loginViewModelProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Expanded(flex: 6, child: SizedBox(height: 400)),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final viewModel = ref.read(
                        loginViewModelProvider.notifier,
                      );
                      final success = await viewModel.googleLogin();
                      if (success && context.mounted) {
                        context.go('/signUp');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.outline),
                      ),
                      child: const Text('구글로 로그인하기'),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final viewModel = ref.read(
                        loginViewModelProvider.notifier,
                      );
                      final success = await viewModel.kakaoLogin();
                      if (success && context.mounted) {
                        context.go('/signUp');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 95,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: appColors?.kakaoYellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('카카오로 로그인하기'),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: appColors?.naverGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('네이버로 로그인하기'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:baton/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(loginViewModelProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(flex: 6, child: SizedBox(height: 400)),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final viewModel = ref.read(
                        loginViewModelProvider.notifier,
                      );
                      viewModel.googleLogin();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('구글로 로그인하기'),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final viewModel = ref.read(
                        loginViewModelProvider.notifier,
                      );
                      viewModel.kakaoLogin();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 95,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('카카오로 로그인하기'),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('애플로 로그인하기'),
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

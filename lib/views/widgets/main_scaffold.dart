import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/chat/chat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        backgroundColor: const Color(0xFFFCFDFF),
        elevation: 0,
        onTap: (index) {
          navigationShell.goBranch(index);
        },
        iconSize: 30,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '홈'),
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context, ref, child) {
                final unreadCount = ref.watch(totalUnreadCountProvider);

                // 💡 핵심 로직: 안읽은게 있고 && 현재 탭이 채팅(index 1)이 아닐 때만 표시
                final bool showBadge =
                    unreadCount > 0 && navigationShell.currentIndex != 1;
                return Badge(
                  isLabelVisible: showBadge,
                  // smallSize: 8,
                  // backgroundColor: AppColors.primary,
                  label: Text(
                    unreadCount > 99
                        ? '99+'
                        : '$unreadCount', // 99개가 넘을 때의 처리 (Baton 기준)
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: AppColors.primary,
                  // alignment: const AlignmentDirectional(18, -8),
                  child: const Icon(Icons.chat_bubble_rounded),
                );
              },
            ),
            label: '채팅',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: '마이',
          ),
        ],
      ),
    );
  }
}

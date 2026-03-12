import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfileTap extends ConsumerWidget {
  const ProfileTap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [Icon(Icons.more_vert, size: 24)],
      ),
      //추가하면서 일단 컬럼 리스트뷰로 바뀌났어용
      body: ListView(
        children: [
          UserProfileCard(),
          SizedBox(height: 8),
          SectionTitle(title: '거래 관리'),
          MenuListItem(icon: Icons.local_offer, content: '내 상품 관리'),
          SizedBox(height: 8),
          MenuListItem(
            svgPath: 'assets/icons/sales_history.svg',
            content: '판매내역',
            routePath: '/salesHistory',
          ),
          SizedBox(height: 8),
          MenuListItem(
            icon: Icons.shopping_cart,
            content: '구매내역',
            routePath: '/purchaseHistory',
          ),
          SizedBox(height: 10),
          SectionTitle(title: '활동'),
          MenuListItem(
            svgPath: 'assets/icons/recently_view.svg',
            content: '최근 본 상품',
          ),
          SizedBox(height: 8),
          MenuListItem(
            icon: Icons.favorite,
            content: '관심 상품',
            routePath: '/like',
          ),

          /// 로그아웃 및 탈퇴 버튼
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await ref.read(userProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/');
                    }
                  },
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: const Color(0xFFB3B3B3),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFB3B3B3),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(width: 1, height: 10, color: const Color(0xFFB3B3B3)),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(userProvider.notifier)
                        .withdraw(
                          onSuccess: () {
                            if (context.mounted) {
                              context.go('/');
                            }
                          },
                          onError: (message) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('탈퇴 실패: $message')),
                              );
                            }
                          },
                        );
                  },
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      color: const Color(0xFFB3B3B3),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFB3B3B3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40), // 마지막 여백
        ],
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.secondary, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 40,
          top: 20,
          bottom: 20,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '양도합니다',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '프로필 수정',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.star_rounded, color: AppColors.primary, size: 24),
            Text('5.0'),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  final IconData? icon;
  final String content;
  final String? svgPath;
  final String? routePath;
  const MenuListItem({
    super.key,
    this.icon,
    required this.content,
    this.svgPath,
    this.routePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        child: InkWell(
          onTap: () {
            if (routePath != null) {
              context.push(routePath!);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 14,
                top: 20,
                bottom: 20,
              ),
              child: Row(
                children: [
                  if (svgPath != null)
                    SvgPicture.asset(
                      svgPath!,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  if (icon != null)
                    Icon(icon!, color: AppColors.primary, size: 24),
                  SizedBox(width: 12),
                  Text(content),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

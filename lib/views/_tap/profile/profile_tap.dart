import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/review/viewmodel/review_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

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
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              children: [
                SectionTitle(title: '후기'),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    context.push('/review');
                  },
                  child: Text(
                    '전체 보기',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const _RecentReviewsSection(),
          const SizedBox(height: 16),
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
          SizedBox(height: 8),
          MenuListItem(
            svgPath: 'assets/icons/blok_person_icon.svg',
            content: '차단 관리',
            routePath: '/',
          ),
          SizedBox(height: 8),
          MenuListItem(
            svgPath: 'assets/icons/block_product_icon.svg',
            content: '가린 상품 관리',
            routePath: '/',
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
                              AppSnackBar.show(context, '탈퇴 실패: $message');
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

class UserProfileCard extends ConsumerWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceVariant),
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
              radius: 30,
              child: ClipOval(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: userAsync.when(
                    data: (user) {
                      if (user?.profileUrl != null) {
                        return Image.network(
                          user!.profileUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              SvgPicture.asset(
                                'assets/images/profile_image_60.svg',
                              ),
                        );
                      } else {
                        return SvgPicture.asset(
                          'assets/images/profile_image_60.svg',
                        );
                      }
                    },
                    loading: () {
                      return SvgPicture.asset(
                        'assets/images/profile_image_60.svg',
                      );
                    },
                    error: (error, stack) {
                      return SvgPicture.asset(
                        'assets/images/profile_image_60.svg',
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  userAsync.when(
                    data: (user) => Text(
                      user?.nickname ?? '로그인 필요',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    loading: () =>
                        const Text('...', style: TextStyle(fontSize: 16)),
                    error: (_, _) =>
                        const Text('에러 발생', style: TextStyle(fontSize: 16)),
                  ),

                  Text(
                    '프로필 수정',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.star_rounded, color: AppColors.primary, size: 24),
            userAsync.when(
              data: (user) => Text(
                user?.score.toStringAsFixed(1) ?? '5.0',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              loading: () => const Text('5.0'),
              error: (_, _) => const Text('5.0'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentReviewsSection extends ConsumerWidget {
  const _RecentReviewsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUserId = ref.watch(userProvider).value?.uid ?? '';
    if (myUserId.isEmpty) return const SizedBox.shrink();

    final reviewsAsync = ref.watch(receivedReviewsProvider(myUserId));

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              '아직 받은 후기가 없어요.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          );
        }

        return SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                height: 98,
                width: 211,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          review.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        review.content ?? '(내용 없음)',
                        style: const TextStyle(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text('Error: $e'),
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
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
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

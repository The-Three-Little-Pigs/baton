import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileTap extends StatelessWidget {
  const ProfileTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [Icon(Icons.more_vert, size: 24)],
      ),
      body: Column(
        children: [
          UserProfileCard(),
          SizedBox(height: 8),
          SectionTitle(title: '거래 관리'),
          MenuListItem(icon: Icons.local_offer, content: '내 상품 관리'),
          SizedBox(height: 8),
          MenuListItem(icon: Icons.local_mall, content: '판매내역'),
          SizedBox(height: 8),
          MenuListItem(icon: Icons.shopping_cart, content: '구매내역'),
          SizedBox(height: 10),
          SectionTitle(title: '활동'),
          MenuListItem(icon: Icons.watch_later, content: '최근 본 상품'),
          SizedBox(height: 8),
          MenuListItem(icon: Icons.favorite, content: '관심 상품'),
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
  final IconData icon;
  final String content;
  const MenuListItem({super.key, required this.icon, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          child: InkWell(
            onTap: () {},
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
                    Icon(icon, color: AppColors.primary),
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
      ),
    );
  }
}

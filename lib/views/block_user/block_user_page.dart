import 'package:baton/notifier/block/block_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:baton/views/widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class BlockUserPage extends ConsumerWidget {
  const BlockUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockState = ref.watch(blockProvider);
    final myBlocks = blockState.myBlocks;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '차단 관리',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: myBlocks.isEmpty
          ? const Center(child: Text('차단한 사용자가 없습니다.'))
          : ListView.builder(
              itemCount: myBlocks.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    BlockUserTile(userId: myBlocks[index].blockedId),
                    Divider(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      thickness: 1,
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class BlockUserTile extends ConsumerWidget {
  final String userId;
  const BlockUserTile({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authorProvider(userId));

    return userAsync.when(
      data: (user) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        child: Row(
          children: [
            // 1. 프로필 이미지: 중첩 없이 바로 user 객체 사용
            ClipOval(
              child: SizedBox(
                width: 48,
                height: 48,
                child: (user.profileUrl != null && user.profileUrl!.isNotEmpty)
                    ? Image.network(
                        user.profileUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _fallbackIcon(),
                      )
                    : _fallbackIcon(),
              ),
            ),
            const SizedBox(width: 10), // 간격 추가
            // 2. 닉네임: Expanded로 감싸면 버튼을 오른쪽 끝으로 보낼 수 있습니다.
            Expanded(
              child: Text(
                user.nickname,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 3. 차단 해제 버튼
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CommonDialog(
                    title: '차단 해제',
                    content: '${user.nickname}님을 차단 해제하시겠습니까?',
                    leftText: '취소',
                    rightText: '해제',
                    onLeftTap: () => Navigator.pop(context),
                    onRightTap: () {
                      Navigator.pop(context);
                      ref.read(blockProvider.notifier).toggleBlock(userId);
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red),
                ),
                child: const Text(
                  '차단 해제',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('에러: $userId')),
    );
  }

  // 기본 이미지용 헬퍼
  Widget _fallbackIcon() =>
      SvgPicture.asset('assets/images/profile_image_60.svg', fit: BoxFit.cover);
}

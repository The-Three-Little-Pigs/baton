import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/review/viewmodel/review_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReviewPage extends ConsumerWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUserId = ref.watch(userProvider).value?.uid ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            '후기',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: '받은 후기'),
              Tab(text: '보낸 후기'),
            ],
          ),
        ),
        body: myUserId.isEmpty
            ? const Center(child: Text('로그인이 필요합니다.'))
            : TabBarView(
                children: [
                  _ReviewList(userId: myUserId, isReceived: true),
                  _ReviewList(userId: myUserId, isReceived: false),
                ],
              ),
      ),
    );
  }
}

class _ReviewList extends ConsumerWidget {
  final String userId;
  final bool isReceived;

  const _ReviewList({required this.userId, required this.isReceived});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = isReceived
        ? ref.watch(receivedReviewsProvider(userId))
        : ref.watch(sentReviewsProvider(userId));

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(
            child: Text(
              isReceived ? '아직 받은 후기가 없어요.' : '아직 보낸 후기가 없어요.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        }

        return ListView.separated(
          itemCount: reviews.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            review.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('yyyy년 MM월 dd일').format(review.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 작성자/수신자 표시 (이름 실데이터 조회는 간단하게 생략하거나 익명 처리)
                  _UserNicknameText(
                    userId: isReceived ? review.writerId : review.receiverId,
                  ),
                  const SizedBox(height: 12),
                  if (review.content != null) ...[
                    Text(
                      review.content!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Container(
                    height: 36,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.push('/product/${review.postId}');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              '거래 상품',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            _ReviewProductNameText(postId: review.postId),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class _UserNicknameText extends ConsumerWidget {
  final String userId;

  const _UserNicknameText({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authorProvider(userId));

    return userAsync.when(
      data: (user) => Text(
        user.nickname,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w500,
        ),
      ),
      loading: () => Text(
        '...',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w500,
        ),
      ),
      error: (_, __) => Text(
        '알 수 없음',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ReviewProductNameText extends ConsumerWidget {
  final String postId;

  const _ReviewProductNameText({required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(productDetailPageViewModelProvider(postId));

    return postAsync.when(
      data: (post) => Text(
        post.title,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      loading: () => Text(
        '...',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w400,
        ),
      ),
      error: (_, __) => Text(
        '알 수 없는 상품',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

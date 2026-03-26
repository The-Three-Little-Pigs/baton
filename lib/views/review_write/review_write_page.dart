import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/core/di/repository/review_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/views/review_write/viewmodel/review_write_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

class ReviewWritePage extends ConsumerStatefulWidget {
  final String opponentName;
  final String receiverId;
  final String postId;
  final String roomId;
  final String productTitle;
  final String productPrice;
  final String? productImageUrl;
  final DateTime? confirmedAt;

  const ReviewWritePage({
    super.key,
    required this.opponentName,
    required this.receiverId,
    required this.postId,
    required this.roomId,
    required this.productTitle,
    required this.productPrice,
    this.productImageUrl,
    this.confirmedAt,
  });

  @override
  ConsumerState<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends ConsumerState<ReviewWritePage> {
  bool _isAlreadyWritten = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkDuplicateReview();
  }

  Future<void> _checkDuplicateReview() async {
    final myId = ref.read(userProvider).value?.uid;
    if (myId == null) return;

    final repo = ref.read(reviewRepositoryProvider);
    final result = await repo.getReviewByRoomAndWriter(
      roomId: widget.roomId,
      writerId: myId,
    );

    if (mounted) {
      setState(() {
        _isChecking = false;
        if (result case Success(value: final review)) {
          if (review != null) {
            _isAlreadyWritten = true;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewWriteProvider);
    final notifier = ref.read(reviewWriteProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          '후기 작성',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isChecking
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. 상품 정보 섹션 (패딩 20)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        if (_isAlreadyWritten)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: const Text(
                              '이미 이 거래에 대한 후기를 작성하셨습니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.confirmedAt != null
                                    ? '${widget.confirmedAt!.year}년 ${widget.confirmedAt!.month}월 ${widget.confirmedAt!.day}일'
                                    : '',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push('/product/${widget.postId}');
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                      child: widget.productImageUrl != null
                                          ? Image.network(
                                              widget.productImageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 14,
                                                      color: AppColors
                                                          .textTertiary,
                                                    ),
                                                  ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/images/empty_image_50.svg',
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.productTitle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${widget.productPrice}원',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ✅ 구분선 (화면 끝까지)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),

                  // 2. 별점 및 후기 섹션 (패딩 20)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        // 별점 타이틀
                        Text(
                          '[${widget.opponentName}] 님과\n거래가 어떠셨나요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: 2.5,
                    unratedColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: AppColors.primary,
                    ),
                    onRatingUpdate: _isAlreadyWritten
                        ? (_) {}
                        : (rating) => notifier.updateRating(rating),
                    ignoreGestures: _isAlreadyWritten,
                  ),
                  const SizedBox(height: 40),

                  // 후기 입력 타이틀
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '거래 후기',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '(${state.content.length}/1000)',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    enabled: !_isAlreadyWritten,
                    maxLines: 5,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: _isAlreadyWritten
                          ? ''
                          : '거래 후기를 자유롭게 남겨주세요.\n(욕설, 비방, 허위 정보는 등록이 제한될 수 있어요)',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                    ),
                    onChanged: (val) => notifier.updateContent(val),
                  ),

                  // 별점 안내 문구
                ],
              ),
            ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!state.canSubmit)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '별점을 선택해주세요',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (state.canSubmit && !state.isLoading)
                    ? () async {
                        final error = await notifier.submitReview(
                          receiverId: widget.receiverId,
                          postId: widget.postId,
                          roomId: widget.roomId,
                        );
                        if (error == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('후기가 등록되었습니다!')),
                            );
                            context.pop();
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(error)));
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        '작성 완료',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

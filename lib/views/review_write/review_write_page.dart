import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/core/di/repository/review_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/views/review_write/viewmodel/review_write_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  const ReviewWritePage({
    super.key,
    required this.opponentName,
    required this.receiverId,
    required this.postId,
    required this.roomId,
    required this.productTitle,
    required this.productPrice,
    this.productImageUrl,
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '후기 작성',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isChecking
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  // 1. 상품 정보 섹션
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          image: widget.productImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(widget.productImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: widget.productImageUrl == null
                            ? const Icon(Icons.image, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '결제 완료 일자 추출 필요', // 예시 날짜
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              widget.productTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${widget.productPrice}원',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  // 2. 별점 섹션
                  Text(
                    '[${widget.opponentName}] 님과\n거래가 어떠셨나요?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: state.rating,
                    minRating: 1,
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
                  const SizedBox(height: 50),

                  // 3. 텍스트 입력 섹션
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '거래 후기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '(${state.content.length}/1000)',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    enabled: !_isAlreadyWritten,
                    maxLines: 8,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: _isAlreadyWritten
                          ? ''
                          : '거래 후기를 자유롭게 남겨주세요.\n(욕설, 비방, 허위 정보는 등록이 제한될 수 있어요)',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    onChanged: (val) => notifier.updateContent(val),
                  ),
                  const SizedBox(height: 80),

                  // 4. 별점 선택 안내 문구 (에러 힌트)
                  if (!state.canSubmit)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.info, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            '별점을 선택해주세요',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  // 5. 작성 완료 버튼
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
                                  AppSnackBar.show(context, '후기가 등록되었습니다!');
                                  context.pop();
                                }
                              } else {
                                if (context.mounted) {
                                  AppSnackBar.show(context, error);
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(
                          0.3,
                        ),
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

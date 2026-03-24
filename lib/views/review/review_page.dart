import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 더미 데이터 (디자인 레퍼런스와 동일)
    final reviews = [
      {
        'rating': 5.0,
        'reviewer': '길동이',
        'date': '2025년 12월 9일',
        'content': null,
        'productName': '상품이름',
      },
      {
        'rating': 5.0,
        'reviewer': '길동이',
        'date': '2025년 12월 9일',
        'content': '좋은 가격에 빠른거래 감사합니다 덕분에 좋은 거래!',
        'productName': '상품이름',
      },
      {
        'rating': 5.0,
        'reviewer': '길동이',
        'date': '2025년 12월 9일',
        'content': '좋은 가격에 빠른거래 감사합니다 덕분에 좋은 거래!',
        'productName': '상품이름',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '후기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // 편집 바텀시트나 동작 추가
            },
            child: const Text(
              '편집',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: ListView.separated(
        itemCount: reviews.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final review = reviews[index];
          final hasContent = review['content'] != null;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 상단: 별점 + 작성일
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
                          (review['rating'] as double).toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      review['date'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 2. 작성자 이름
                Text(
                  review['reviewer'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. 리뷰 내용 (있는 경우만 출력)
                if (hasContent) ...[
                  Text(
                    review['content'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 4. 거래 상품 박스
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        '거래상품',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          review['productName'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

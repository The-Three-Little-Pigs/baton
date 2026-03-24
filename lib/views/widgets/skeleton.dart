import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 앱 전역에서 사용할 기본 스켈레톤 박스
class BatonSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const BatonSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0), // 슬레이트 200 수준
      highlightColor: const Color(0xFFF1F5F9), // 슬레이트 100 수준
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// ProductItem 위젯과 대응되는 스켈레톤 위젯
class ProductItemSkeleton extends StatelessWidget {
  const ProductItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이미지 영역 (정사각형)
        const AspectRatio(
          aspectRatio: 1,
          child: BatonSkeleton(borderRadius: 16),
        ),
        const SizedBox(height: 12),
        // 정보 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              const BatonSkeleton(width: double.infinity, height: 16),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 가격
                  const BatonSkeleton(width: 80, height: 20),
                  // 날짜
                  const BatonSkeleton(width: 40, height: 12),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ProductGrid와 대응되는 스켈레톤 그리드
class ProductGridSkeleton extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const ProductGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.7,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductItemSkeleton(),
    );
  }
}

/// 인기 검색어 섹션용 스켈레톤
class HotKeywordSkeleton extends StatelessWidget {
  const HotKeywordSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildColumn()),
        Expanded(child: _buildColumn()),
      ],
    );
  }

  Widget _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: List.generate(
        5,
        (index) => Row(
          spacing: 8,
          children: [
            const BatonSkeleton(width: 16, height: 16),
            const BatonSkeleton(width: 80, height: 16),
          ],
        ),
      ),
    );
  }
}

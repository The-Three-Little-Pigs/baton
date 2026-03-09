import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoProduct extends StatelessWidget {
  const NoProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/exclamation.svg', width: 30, height: 30),
        AppSpacing.h8,
        Text("등록된 상품이 없어요."),
        Text("다른 카테고리를 확인해보세요."),
      ],
    );
  }
}

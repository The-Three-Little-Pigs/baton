import 'package:baton/views/widgets/empty_page.dart';
import 'package:flutter/material.dart';

class NoProduct extends StatelessWidget {
  const NoProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyPage(title: "등록된 상품이 없어요.", subTitle: "다른 카테고리를 확인해보세요.");
  }
}

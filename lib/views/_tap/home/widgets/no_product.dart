import 'package:flutter/material.dart';

class NoProduct extends StatelessWidget {
  const NoProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(Icons.priority_high, size: 30),
        ),
        Text("등록된 상품이 없어요."),
        Text("다른 카테고리를 확인해보세요."),
      ],
    );
  }
}

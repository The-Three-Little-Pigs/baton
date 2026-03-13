import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class NoLikeProduct extends StatelessWidget {
  const NoLikeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/exclamation.svg'),
        SizedBox(height: 8),
        Text("아직 관심상품이 없어요."),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            context.go('/home');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: const EdgeInsets.only(
              left: 22,
              right: 10,
              top: 14,
              bottom: 14,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("상품 둘러보기", style: TextStyle(color: Colors.white)),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

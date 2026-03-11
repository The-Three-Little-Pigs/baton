import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key, required this.title, required this.subTitle});
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/exclamation.svg', width: 30, height: 30),
        AppSpacing.h8,
        Text(title),
        Text(subTitle),
      ],
    );
  }
}

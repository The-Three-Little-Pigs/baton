import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        'assets/images/home_logo.svg',
        height: 20,
        fit: BoxFit.cover,
      ),
    );
  }
}

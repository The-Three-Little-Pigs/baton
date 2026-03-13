import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeLogo extends StatelessWidget {
  const HomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/home_logo.svg',
      height: 30,
      fit: BoxFit.cover,
    );
  }
}

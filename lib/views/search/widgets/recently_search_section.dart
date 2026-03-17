import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecentlySearchSection extends StatelessWidget {
  const RecentlySearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "최근 검색",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              "전체 삭제",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        RecentlySearchItem(),
      ],
    );
  }
}

class RecentlySearchItem extends StatelessWidget {
  const RecentlySearchItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        SvgPicture.asset(
          'assets/icons/nest_clock_farsight_analog.svg',
          width: 24,
          height: 24,
        ),
        Text(
          "최근 검색어",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {},
          child: Icon(Icons.close, color: Color(0xFFB3B3B3), size: 18),
        ),
      ],
    );
  }
}

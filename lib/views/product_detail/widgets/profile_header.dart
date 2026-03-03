import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.authorId});

  final String authorId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage("https://picsum.photos/200"),
        ),
        AppSpacing.w8,
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('authorId.nickname', style: TextStyle(fontSize: 16))],
        ),
        const Spacer(),
        // user - score
      ],
    );
  }
}

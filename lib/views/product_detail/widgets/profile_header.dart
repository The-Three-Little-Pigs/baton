import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key, required this.authorId});

  final String authorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorAsync = ref.watch(authorProvider(authorId));

    return authorAsync.when(
      data: (author) {
        final hasImage =
            author.profileUrl != null && author.profileUrl!.isNotEmpty;
        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: hasImage
                  ? ClipOval(
                      child: Image.network(
                        author.profileUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: SvgPicture.asset(
                        'assets/images/empty_profile_60.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            AppSpacing.w8,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.nickname,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // user - score
          ],
        );
      },
      error: (Object error, StackTrace stackTrace) =>
          Center(child: Text(error.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlarmItem extends StatelessWidget {
  const AlarmItem({
    super.key,
    required this.header,
    required this.date,
    required this.imageUrl,
    required this.content,
    required this.icon,
    this.isEditMode = false,
    this.isSelected = false,
    this.onSelected,
  });

  final String header;
  final String date;
  final String imageUrl;
  final Widget content; // Widget으로 변경 (Text 등)
  final IconData icon;
  final bool isEditMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEditMode ? () => onSelected?.call(!isSelected) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isEditMode) ...[
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : const Color(0xFFFCFDFF),
                border: isSelected ? null : Border.all(color: AppColors.divider),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(icon,
                        color: Theme.of(context).colorScheme.primary, size: 20),
                    Text(header,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFFBCBCBC),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 11,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                          : SvgPicture.asset(
                              'assets/images/empty_image.svg',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                    ),
                    Expanded(child: content),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

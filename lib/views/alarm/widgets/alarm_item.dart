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
    required this.isRead,
    this.onTap,
  });

  final String header;
  final String date;
  final String imageUrl;
  final String content;
  final IconData icon;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 읽은 알림은 0.5 투명도 적용하여 연하게 표시
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: isRead ? 0.5 : 1.0,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  Text(
                    header,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Row(
                spacing: 11,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported, size: 20),
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/images/empty_image.svg',
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                  ),
                  Expanded(
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 14,
                        color: isRead ? Colors.grey : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

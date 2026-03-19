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
  });

  final String header;
  final String date;
  final String imageUrl;
  final Text content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              Text(header, style: TextStyle(fontWeight: FontWeight.w600)),
              Spacer(),
              Text(date),
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
                      )
                    : SvgPicture.asset(
                        'assets/images/empty_image.svg',
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
              ),
              content,
            ],
          ),
        ],
      ),
    );
  }
}

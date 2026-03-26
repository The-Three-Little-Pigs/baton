import 'package:flutter/material.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index + 1;
            });
          },
          itemBuilder: (context, index) {
            return Image.network(widget.imageUrls[index], fit: BoxFit.cover);
          },
        ),
        Positioned(
          bottom: 8,
          right: 24,
          child: Container(
            alignment: Alignment.center,
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFCCCCCC),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "$_currentPage / ${widget.imageUrls.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                letterSpacing: 1.2,
                color: Color(0xFF4A535F),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

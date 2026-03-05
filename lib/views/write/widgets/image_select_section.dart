import 'dart:io';

import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baton/views/write/viewmodel/image_notifier.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectSection extends ConsumerWidget {
  const ImageSelectSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(imageProvider);

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SubTitle(title: "사진 등록", required: false),
            Text(
              "(${images.length}/10)",
              style: TextStyle(color: const Color(0xFFB3B3B3), fontSize: 14),
            ),
          ],
        ),
        SizedBox(
          height: 60,
          child: Row(
            spacing: 14,
            children: [
              ProudctAddButton(
                onTap: () async {
                  final xFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (xFile == null) return;
                  ref.read(imageProvider.notifier).addImage(xFile.path);
                },
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: _ItemImage(
                        imagePath: images[index],
                        onRemove: () {
                          ref.read(imageProvider.notifier).removeAt(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProudctAddButton extends StatelessWidget {
  const ProudctAddButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: const Color(0xFFCDD8E7), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.imagePath, required this.onRemove});

  final String imagePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(imagePath), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 14,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

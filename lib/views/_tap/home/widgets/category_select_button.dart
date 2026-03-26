import 'package:baton/views/_tap/home/viewmodel/filter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelectButton extends ConsumerWidget {
  const CategorySelectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSelected = ref.watch(filterProvider).isOpen;

    return GestureDetector(
      onTap: () {
        ref.read(filterProvider.notifier).toggle();
      },
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: ShapeDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : const Color(0xFFFCFDFE),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected
                  ? theme.colorScheme.primary
                  : const Color(0xFFB5C1D0),
            ),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Icon(
          Icons.tune_outlined,
          size: 20,
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

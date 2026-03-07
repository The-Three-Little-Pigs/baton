import 'package:baton/models/enum/category.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryChipsProvider);

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Category.values.length,
        itemBuilder: (context, index) {
          final category = Category.values[index];
          final isSelected = categories.contains(category);
          return CategoryChip(
            label: category.name,
            isSelected: isSelected,
            category: category,
            onSelected: (selectedCategory) {
              ref
                  .read(categoryChipsProvider.notifier)
                  .toggleCategory(selectedCategory);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.onSelected,
    required this.category,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;
  final Category category;
  final void Function(Category category) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = isSelected
        ? theme.colorScheme.primary
        : const Color(0xFF5E6875);

    return FilterChip(
      label: Row(
        children: [
          Text(label),
          if (isSelected) Icon(Icons.close, size: 20, color: activeColor),
        ],
      ),
      selected: isSelected,
      onSelected: (value) => onSelected(category),
      backgroundColor: Colors.transparent,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.zero,
      labelStyle: TextStyle(
        color: activeColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : const Color(0xFFB5C1D0),
        width: 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

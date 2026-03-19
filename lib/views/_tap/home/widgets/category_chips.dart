import 'package:baton/models/enum/category.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:baton/views/widgets/category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategories = ref.watch(categoryChipsProvider);

    return SizedBox(
      height: 38, // 높이 소폭 조정
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Category.values.length,
        itemBuilder: (context, index) {
          final category = Category.values[index];
          final isSelected = selectedCategories.contains(category);
          return CategoryTag(
            label: category.label,
            isSelected: isSelected,
            showDeleteIcon: isSelected, // 선택된 경우만 X 아이콘 노출
            onTap: () {
              ref
                  .read(categoryChipsProvider.notifier)
                  .toggleCategory(category);
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}

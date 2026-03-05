import 'package:baton/models/enum/category.dart';
import 'package:baton/views/widgets/chip_button.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:baton/views/write/viewmodel/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "카테고리", required: true),
        CategorySelectButton(),
      ],
    );
  }
}

class CategorySelectButton extends ConsumerWidget {
  const CategorySelectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<String>(
          context: context,
          builder: (context) {
            return CategoryBottomSheet();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        alignment: Alignment.centerRight,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFFB5C1D0), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.chevron_right, size: 24),
      ),
    );
  }
}

class CategoryBottomSheet extends ConsumerWidget {
  const CategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    final onSelected = ref.read(categoryProvider.notifier).setCategory;

    return Container(
      padding: const EdgeInsets.fromLTRB(20.5, 20.5, 20.5, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              const Text(
                "카테고리",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  size: 24,
                  color: Color(0xFF191919),
                ),
              ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20.5),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: Category.values.map((cat) {
                  return ChipButton(
                    label: cat.name,
                    isSelected: cat.name == category,
                    onSelected: (value) => onSelected(cat.name),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

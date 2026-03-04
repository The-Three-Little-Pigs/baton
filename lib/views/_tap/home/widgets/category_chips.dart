import 'package:baton/models/enum/category.dart';
import 'package:baton/views/widgets/chip_button.dart';
import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Category.values.length,
        itemBuilder: (context, index) {
          return ChipButton(label: Category.values[index].name);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
      ),
    );
  }
}

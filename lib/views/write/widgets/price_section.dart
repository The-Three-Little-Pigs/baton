import 'package:baton/views/widgets/labeled_input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/sale_notifier.dart' show saleProvider;

class PriceSection extends ConsumerWidget {
  const PriceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSharing = ref.watch(saleProvider).isSharing;

    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "가격", required: true),
        const LabeledInputField(
          label: "구매가",
          hintText: "가격을 입력해주세요.",
          isPriceSection: true,
        ),
        if (!isSharing)
          const LabeledInputField(
            label: "판매가",
            hintText: "가격을 입력해주세요.",
            isPriceSection: true,
          ),
      ],
    );
  }
}

import 'package:baton/views/widgets/chip_button.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/sale_notifier.dart' show saleProvider;

class TradeTypeSection extends ConsumerWidget {
  const TradeTypeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "유형", required: true),
        Row(
          spacing: 8,
          children: [
            ChipButton(
              label: "판매하기",
              isSelected: !ref.watch(saleProvider).isSharing,
              onSelected: (_) =>
                  ref.read(saleProvider.notifier).setSharing(false),
            ),
            ChipButton(
              label: "나눔하기",
              isSelected: ref.watch(saleProvider).isSharing,
              onSelected: (_) =>
                  ref.read(saleProvider.notifier).setSharing(true),
            ),
          ],
        ),
      ],
    );
  }
}

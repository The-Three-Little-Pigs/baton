import 'package:baton/views/widgets/labeled_input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/sale_notifier.dart' show saleProvider;

class PriceSection extends ConsumerStatefulWidget {
  const PriceSection({super.key});

  @override
  ConsumerState<PriceSection> createState() => _PriceSectionState();
}

class _PriceSectionState extends ConsumerState<PriceSection> {
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _salePriceController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(saleProvider);
    _purchasePriceController = TextEditingController(
      text: state.purchasePrice?.toString() ?? "",
    );
    _salePriceController = TextEditingController(
      text: state.salePrice?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSharing = ref.watch(saleProvider).isSharing;

    ref.listen(saleProvider, (previous, next) {
      if (_purchasePriceController.text != next.purchasePrice?.toString() &&
          next.purchasePrice != null) {
        _purchasePriceController.text = next.purchasePrice.toString();
      }
      if (_salePriceController.text != next.salePrice?.toString() &&
          next.salePrice != null) {
        _salePriceController.text = next.salePrice.toString();
      }
    });

    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "가격", required: true),
        LabeledInputField(
          controller: _purchasePriceController,
          label: "구매가",
          hintText: "가격을 입력해주세요.",
          isPriceSection: true,
          onChanged: (value) {
            final price = int.tryParse(value) ?? 0;
            ref.read(saleProvider.notifier).setPurchasePrice(price);
          },
          border: Border.all(color: const Color(0xFFB5C1D0), width: 1),
        ),
        if (!isSharing)
          LabeledInputField(
            controller: _salePriceController,
            label: "판매가",
            hintText: "가격을 입력해주세요.",
            isPriceSection: true,
            onChanged: (value) {
              final price = int.tryParse(value) ?? 0;
              ref.read(saleProvider.notifier).setSalePrice(price);
            },
            border: Border.all(color: const Color(0xFFB5C1D0), width: 1),
          ),
      ],
    );
  }
}

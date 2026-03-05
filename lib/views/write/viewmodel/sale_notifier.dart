import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sale_notifier.g.dart';

class SaleState {
  final double purchasePrice;
  final double? salePrice;
  final bool isSharing;

  SaleState({
    required this.purchasePrice,
    this.salePrice,
    required this.isSharing,
  });

  SaleState copyWith({
    double? purchasePrice,
    double? salePrice,
    bool? isSharing,
  }) {
    return SaleState(
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      isSharing: isSharing ?? this.isSharing,
    );
  }
}

@riverpod
class SaleNotifier extends _$SaleNotifier {
  @override
  SaleState build() {
    return SaleState(purchasePrice: 0, salePrice: 0, isSharing: false);
  }

  void setPurchasePrice(double price) {
    state = state.copyWith(purchasePrice: price);
  }

  void setSalePrice(double price) {
    state = state.copyWith(salePrice: price);
  }

  void setSharing(bool isSharing) {
    state = state.copyWith(isSharing: isSharing);
  }
}

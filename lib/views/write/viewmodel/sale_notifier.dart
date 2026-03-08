import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sale_notifier.g.dart';

class SaleState {
  final int? purchasePrice;
  final int? salePrice;
  final bool isSharing;

  SaleState({this.purchasePrice, this.salePrice, required this.isSharing});

  SaleState copyWith({int? purchasePrice, int? salePrice, bool? isSharing}) {
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
    return SaleState(purchasePrice: null, salePrice: null, isSharing: false);
  }

  void setPurchasePrice(int price) {
    state = state.copyWith(purchasePrice: price);
  }

  void setSalePrice(int price) {
    state = state.copyWith(salePrice: price);
  }

  void setSharing(bool isSharing) {
    state = state.copyWith(isSharing: isSharing);
  }
}

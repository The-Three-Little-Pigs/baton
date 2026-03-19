// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductItemNotifier)
final productItemProvider = ProductItemNotifierProvider._();

final class ProductItemNotifierProvider
    extends $NotifierProvider<ProductItemNotifier, void> {
  ProductItemNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productItemNotifierHash();

  @$internal
  @override
  ProductItemNotifier create() => ProductItemNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$productItemNotifierHash() =>
    r'af77f92fc453054f5ab5f78766536a14577294a8';

abstract class _$ProductItemNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

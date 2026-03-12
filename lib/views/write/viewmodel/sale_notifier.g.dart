// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SaleNotifier)
final saleProvider = SaleNotifierProvider._();

final class SaleNotifierProvider
    extends $NotifierProvider<SaleNotifier, SaleState> {
  SaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleNotifierHash();

  @$internal
  @override
  SaleNotifier create() => SaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaleState>(value),
    );
  }
}

String _$saleNotifierHash() => r'e367c08b72495b6b6992fe0a67dcd33544f3e143';

abstract class _$SaleNotifier extends $Notifier<SaleState> {
  SaleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SaleState, SaleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SaleState, SaleState>,
              SaleState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

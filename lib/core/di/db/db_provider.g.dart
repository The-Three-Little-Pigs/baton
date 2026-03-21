// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(batonDatabase)
final batonDatabaseProvider = BatonDatabaseProvider._();

final class BatonDatabaseProvider
    extends $FunctionalProvider<BatonDatabase, BatonDatabase, BatonDatabase>
    with $Provider<BatonDatabase> {
  BatonDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batonDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batonDatabaseHash();

  @$internal
  @override
  $ProviderElement<BatonDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BatonDatabase create(Ref ref) {
    return batonDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatonDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatonDatabase>(value),
    );
  }
}

String _$batonDatabaseHash() => r'fc9fd0843acab1d0e09990304a5fd5284018b775';

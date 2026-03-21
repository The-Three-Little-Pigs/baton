// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algolia_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(algoliaService)
final algoliaServiceProvider = AlgoliaServiceProvider._();

final class AlgoliaServiceProvider
    extends $FunctionalProvider<AlgoliaService, AlgoliaService, AlgoliaService>
    with $Provider<AlgoliaService> {
  AlgoliaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'algoliaServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$algoliaServiceHash();

  @$internal
  @override
  $ProviderElement<AlgoliaService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AlgoliaService create(Ref ref) {
    return algoliaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlgoliaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlgoliaService>(value),
    );
  }
}

String _$algoliaServiceHash() => r'584eb8c7ad212435e542f40c188060faea972e2b';

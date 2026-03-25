// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(searchService)
final searchServiceProvider = SearchServiceProvider._();

final class SearchServiceProvider
    extends $FunctionalProvider<SearchService, SearchService, SearchService>
    with $Provider<SearchService> {
  SearchServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchServiceHash();

  @$internal
  @override
  $ProviderElement<SearchService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchService create(Ref ref) {
    return searchService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchService>(value),
    );
  }
}

String _$searchServiceHash() => r'b8d5eba46dbb3698bf4b3a2828a7f05356766115';

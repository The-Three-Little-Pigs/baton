// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_field_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchFieldNotifier)
final searchFieldProvider = SearchFieldNotifierProvider._();

final class SearchFieldNotifierProvider
    extends $NotifierProvider<SearchFieldNotifier, String> {
  SearchFieldNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFieldProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFieldNotifierHash();

  @$internal
  @override
  SearchFieldNotifier create() => SearchFieldNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchFieldNotifierHash() =>
    r'79cb7b862aebe58d2a5d960da1988591094d0892';

abstract class _$SearchFieldNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

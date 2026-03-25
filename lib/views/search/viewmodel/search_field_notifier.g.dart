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
    extends $NotifierProvider<SearchFieldNotifier, SearchFieldState> {
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
  Override overrideWithValue(SearchFieldState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFieldState>(value),
    );
  }
}

String _$searchFieldNotifierHash() =>
    r'3df0717eb3c7d26b4be2aadbb8c66ad44945a19e';

abstract class _$SearchFieldNotifier extends $Notifier<SearchFieldState> {
  SearchFieldState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchFieldState, SearchFieldState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFieldState, SearchFieldState>,
              SearchFieldState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

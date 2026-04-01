// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchResultViewModel)
final searchResultViewModelProvider = SearchResultViewModelFamily._();

final class SearchResultViewModelProvider
    extends $AsyncNotifierProvider<SearchResultViewModel, SearchResultState> {
  SearchResultViewModelProvider._({
    required SearchResultViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchResultViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchResultViewModelHash();

  @override
  String toString() {
    return r'searchResultViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SearchResultViewModel create() => SearchResultViewModel();

  @override
  bool operator ==(Object other) {
    return other is SearchResultViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchResultViewModelHash() =>
    r'5461b16e60787220eda41138e1137a70695c2ef6';

final class SearchResultViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SearchResultViewModel,
          AsyncValue<SearchResultState>,
          SearchResultState,
          FutureOr<SearchResultState>,
          String
        > {
  SearchResultViewModelFamily._()
    : super(
        retry: null,
        name: r'searchResultViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchResultViewModelProvider call(String keyword) =>
      SearchResultViewModelProvider._(argument: keyword, from: this);

  @override
  String toString() => r'searchResultViewModelProvider';
}

abstract class _$SearchResultViewModel
    extends $AsyncNotifier<SearchResultState> {
  late final _$args = ref.$arg as String;
  String get keyword => _$args;

  FutureOr<SearchResultState> build(String keyword);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SearchResultState>, SearchResultState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SearchResultState>, SearchResultState>,
              AsyncValue<SearchResultState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

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
    extends $AsyncNotifierProvider<SearchResultViewModel, List<Post>> {
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
    r'76eb43ed9d5a2cc05f977689396688ea8ff2f905';

final class SearchResultViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SearchResultViewModel,
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>,
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

abstract class _$SearchResultViewModel extends $AsyncNotifier<List<Post>> {
  late final _$args = ref.$arg as String;
  String get keyword => _$args;

  FutureOr<List<Post>> build(String keyword);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Post>>, List<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Post>>, List<Post>>,
              AsyncValue<List<Post>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

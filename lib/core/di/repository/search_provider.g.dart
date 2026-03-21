// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(searchRepository)
final searchRepositoryProvider = SearchRepositoryProvider._();

final class SearchRepositoryProvider
    extends
        $FunctionalProvider<
          SearchRepository,
          SearchRepository,
          SearchRepository
        >
    with $Provider<SearchRepository> {
  SearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchRepositoryHash();

  @$internal
  @override
  $ProviderElement<SearchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchRepository create(Ref ref) {
    return searchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchRepository>(value),
    );
  }
}

String _$searchRepositoryHash() => r'fa4eff181a1fe120c2536f6b2c6421127d0c49b9';

/// 로컬 검색 기록 스트림 프로바이더

@ProviderFor(recentlySearchHistory)
final recentlySearchHistoryProvider = RecentlySearchHistoryProvider._();

/// 로컬 검색 기록 스트림 프로바이더

final class RecentlySearchHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SearchHistory>>,
          List<SearchHistory>,
          Stream<List<SearchHistory>>
        >
    with
        $FutureModifier<List<SearchHistory>>,
        $StreamProvider<List<SearchHistory>> {
  /// 로컬 검색 기록 스트림 프로바이더
  RecentlySearchHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlySearchHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlySearchHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<SearchHistory>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SearchHistory>> create(Ref ref) {
    return recentlySearchHistory(ref);
  }
}

String _$recentlySearchHistoryHash() =>
    r'fb67548eb172e89b866bd8bcd19b4b668e284e56';

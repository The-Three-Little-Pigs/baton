// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentlySearchNotifier)
final recentlySearchProvider = RecentlySearchNotifierProvider._();

final class RecentlySearchNotifierProvider
    extends
        $StreamNotifierProvider<RecentlySearchNotifier, List<SearchHistory>> {
  RecentlySearchNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlySearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlySearchNotifierHash();

  @$internal
  @override
  RecentlySearchNotifier create() => RecentlySearchNotifier();
}

String _$recentlySearchNotifierHash() =>
    r'998d884b39663dafd5dd28b1ed7e5eefc8e626b4';

abstract class _$RecentlySearchNotifier
    extends $StreamNotifier<List<SearchHistory>> {
  Stream<List<SearchHistory>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SearchHistory>>, List<SearchHistory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SearchHistory>>, List<SearchHistory>>,
              AsyncValue<List<SearchHistory>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

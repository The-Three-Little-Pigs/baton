// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentlySearchActions)
final recentlySearchActionsProvider = RecentlySearchActionsProvider._();

final class RecentlySearchActionsProvider
    extends $NotifierProvider<RecentlySearchActions, void> {
  RecentlySearchActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlySearchActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlySearchActionsHash();

  @$internal
  @override
  RecentlySearchActions create() => RecentlySearchActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$recentlySearchActionsHash() =>
    r'e1452e1f6e442f715fdf081e0fdae3e483f6e6c4';

abstract class _$RecentlySearchActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

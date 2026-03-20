// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_keyword_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HotKeywordNotifier)
final hotKeywordProvider = HotKeywordNotifierProvider._();

final class HotKeywordNotifierProvider
    extends $AsyncNotifierProvider<HotKeywordNotifier, List<Keyword>> {
  HotKeywordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hotKeywordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hotKeywordNotifierHash();

  @$internal
  @override
  HotKeywordNotifier create() => HotKeywordNotifier();
}

String _$hotKeywordNotifierHash() =>
    r'03929677ce96321e9b15e6bb6fe483331d40af03';

abstract class _$HotKeywordNotifier extends $AsyncNotifier<List<Keyword>> {
  FutureOr<List<Keyword>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Keyword>>, List<Keyword>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Keyword>>, List<Keyword>>,
              AsyncValue<List<Keyword>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

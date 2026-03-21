// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_keyword_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hotKeyword)
final hotKeywordProvider = HotKeywordProvider._();

final class HotKeywordProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Keyword>>,
          List<Keyword>,
          FutureOr<List<Keyword>>
        >
    with $FutureModifier<List<Keyword>>, $FutureProvider<List<Keyword>> {
  HotKeywordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hotKeywordProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hotKeywordHash();

  @$internal
  @override
  $FutureProviderElement<List<Keyword>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Keyword>> create(Ref ref) {
    return hotKeyword(ref);
  }
}

String _$hotKeywordHash() => r'4258e232a3993201ba90a4f8164d24c92653ef3c';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContentNotifier)
final contentProvider = ContentNotifierProvider._();

final class ContentNotifierProvider
    extends $NotifierProvider<ContentNotifier, ContentState> {
  ContentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentNotifierHash();

  @$internal
  @override
  ContentNotifier create() => ContentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentState>(value),
    );
  }
}

String _$contentNotifierHash() => r'e9ca4971ed6631fad5966ccbc52340a0992ed42a';

abstract class _$ContentNotifier extends $Notifier<ContentState> {
  ContentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ContentState, ContentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContentState, ContentState>,
              ContentState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

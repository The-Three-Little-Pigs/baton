// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_write_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReviewWriteNotifier)
final reviewWriteProvider = ReviewWriteNotifierProvider._();

final class ReviewWriteNotifierProvider
    extends $NotifierProvider<ReviewWriteNotifier, ReviewWriteState> {
  ReviewWriteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewWriteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewWriteNotifierHash();

  @$internal
  @override
  ReviewWriteNotifier create() => ReviewWriteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewWriteState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewWriteState>(value),
    );
  }
}

String _$reviewWriteNotifierHash() =>
    r'641deac4bb8e8b58ccecda3241f7f69858dcfb6a';

abstract class _$ReviewWriteNotifier extends $Notifier<ReviewWriteState> {
  ReviewWriteState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ReviewWriteState, ReviewWriteState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReviewWriteState, ReviewWriteState>,
              ReviewWriteState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

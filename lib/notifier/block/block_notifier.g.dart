// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BlockNotifier)
final blockProvider = BlockNotifierProvider._();

final class BlockNotifierProvider
    extends $NotifierProvider<BlockNotifier, BlockState> {
  BlockNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockNotifierHash();

  @$internal
  @override
  BlockNotifier create() => BlockNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlockState>(value),
    );
  }
}

String _$blockNotifierHash() => r'3fd2fce2a4298a0cbb3ae58e9dae4445f667d0ca';

abstract class _$BlockNotifier extends $Notifier<BlockState> {
  BlockState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BlockState, BlockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BlockState, BlockState>,
              BlockState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(likeRepository)
final likeRepositoryProvider = LikeRepositoryProvider._();

final class LikeRepositoryProvider
    extends $FunctionalProvider<LikeRepository, LikeRepository, LikeRepository>
    with $Provider<LikeRepository> {
  LikeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likeRepositoryHash();

  @$internal
  @override
  $ProviderElement<LikeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LikeRepository create(Ref ref) {
    return likeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LikeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LikeRepository>(value),
    );
  }
}

String _$likeRepositoryHash() => r'1cc54e32fadcd565eed067fc3fa3c9012379e3b7';

@ProviderFor(LikeNotifier)
final likeProvider = LikeNotifierProvider._();

final class LikeNotifierProvider
    extends $AsyncNotifierProvider<LikeNotifier, List<Post>> {
  LikeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likeNotifierHash();

  @$internal
  @override
  LikeNotifier create() => LikeNotifier();
}

String _$likeNotifierHash() => r'c3854936ea0d810322c9adfebd03740639efa2d2';

abstract class _$LikeNotifier extends $AsyncNotifier<List<Post>> {
  FutureOr<List<Post>> build();
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
    element.handleCreate(ref, build);
  }
}

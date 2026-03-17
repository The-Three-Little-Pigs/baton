// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tap_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeTapViewModel)
final homeTapViewModelProvider = HomeTapViewModelProvider._();

final class HomeTapViewModelProvider
    extends $AsyncNotifierProvider<HomeTapViewModel, List<Post>> {
  HomeTapViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeTapViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeTapViewModelHash();

  @$internal
  @override
  HomeTapViewModel create() => HomeTapViewModel();
}

String _$homeTapViewModelHash() => r'80d05d8d6e490a4163c6b2aa7ea249106837a199';

abstract class _$HomeTapViewModel extends $AsyncNotifier<List<Post>> {
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

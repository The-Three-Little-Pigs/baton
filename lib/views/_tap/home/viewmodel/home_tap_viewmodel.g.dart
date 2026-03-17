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
    extends $AsyncNotifierProvider<HomeTapViewModel, HomeTapState> {
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

String _$homeTapViewModelHash() => r'cb8299e15efd47400895e5bfd3e31f25c8de0ede';

abstract class _$HomeTapViewModel extends $AsyncNotifier<HomeTapState> {
  FutureOr<HomeTapState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeTapState>, HomeTapState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeTapState>, HomeTapState>,
              AsyncValue<HomeTapState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

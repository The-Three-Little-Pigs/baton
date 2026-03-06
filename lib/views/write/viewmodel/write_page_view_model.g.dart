// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WritePageViewModel)
final writePageViewModelProvider = WritePageViewModelProvider._();

final class WritePageViewModelProvider
    extends $AsyncNotifierProvider<WritePageViewModel, void> {
  WritePageViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'writePageViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$writePageViewModelHash();

  @$internal
  @override
  WritePageViewModel create() => WritePageViewModel();
}

String _$writePageViewModelHash() =>
    r'a8d0e4300b119decd9f61ae1801d7c2b5b6d5a72';

abstract class _$WritePageViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

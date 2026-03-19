// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_page_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WritePageViewModel)
final writePageViewModelProvider = WritePageViewModelFamily._();

final class WritePageViewModelProvider
    extends $AsyncNotifierProvider<WritePageViewModel, void> {
  WritePageViewModelProvider._({
    required WritePageViewModelFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'writePageViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$writePageViewModelHash();

  @override
  String toString() {
    return r'writePageViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WritePageViewModel create() => WritePageViewModel();

  @override
  bool operator ==(Object other) {
    return other is WritePageViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$writePageViewModelHash() =>
    r'08ee7c75b2dfb9c9fd75fb2d3367dd47aaa739e8';

final class WritePageViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          WritePageViewModel,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          String?
        > {
  WritePageViewModelFamily._()
    : super(
        retry: null,
        name: r'writePageViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WritePageViewModelProvider call({String? postId}) =>
      WritePageViewModelProvider._(argument: postId, from: this);

  @override
  String toString() => r'writePageViewModelProvider';
}

abstract class _$WritePageViewModel extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as String?;
  String? get postId => _$args;

  FutureOr<void> build({String? postId});
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
    element.handleCreate(ref, () => build(postId: _$args));
  }
}

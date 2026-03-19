// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ImageNotifier)
final imageProvider = ImageNotifierProvider._();

final class ImageNotifierProvider
    extends $NotifierProvider<ImageNotifier, List<String>> {
  ImageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageNotifierHash();

  @$internal
  @override
  ImageNotifier create() => ImageNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$imageNotifierHash() => r'cb2710c9f71d4a652b7a4c076b268b0403fbfb9b';

abstract class _$ImageNotifier extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

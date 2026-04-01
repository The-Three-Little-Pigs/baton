// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_uploader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storageUploader)
final storageUploaderProvider = StorageUploaderProvider._();

final class StorageUploaderProvider
    extends
        $FunctionalProvider<
          FirebaseStorageUploader,
          FirebaseStorageUploader,
          FirebaseStorageUploader
        >
    with $Provider<FirebaseStorageUploader> {
  StorageUploaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageUploaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageUploaderHash();

  @$internal
  @override
  $ProviderElement<FirebaseStorageUploader> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseStorageUploader create(Ref ref) {
    return storageUploader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseStorageUploader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseStorageUploader>(value),
    );
  }
}

String _$storageUploaderHash() => r'52a1e931c84ae139175bab2e49686d36def0e6c8';

// lib/core/di/service/storage_uploader_provider.dart
import 'package:baton/service/firebase_storage_uploader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_uploader_provider.g.dart';

@riverpod
FirebaseStorageUploader storageUploader(Ref ref) {
  return FirebaseStorageUploader();
}

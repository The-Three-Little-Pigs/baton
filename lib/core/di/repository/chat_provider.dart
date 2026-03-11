// lib/core/di/repository/chat_provider.dart
import 'package:baton/models/repositories/repository/chat_repository.dart';
import 'package:baton/models/repositories/repository_impl/chat_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepositoryImpl(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
}

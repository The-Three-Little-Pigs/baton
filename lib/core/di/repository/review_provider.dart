// lib/core/di/repository/review_provider.dart
import 'package:baton/models/repositories/repository/review_repository.dart';
import 'package:baton/models/repositories/repository_impl/review_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_provider.g.dart';

@riverpod
ReviewRepository reviewRepository(Ref ref) {
  return ReviewRepositoryImpl(FirebaseFirestore.instance);
}

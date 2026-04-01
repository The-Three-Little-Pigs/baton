import 'package:baton/core/di/repository/chat_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_chat_count_provider.g.dart';

@riverpod
Stream<int> productChatCount(Ref ref, String postId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchChatCount(postId);
}

// lib/views/_tap/chat/viewmodel/chat_list_notifier.dart
import 'package:baton/core/di/repository/chat_provider.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/notifier/test/test_auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_notifier.g.dart';

@riverpod
class ChatListNotifier extends _$ChatListNotifier {
  @override
  Stream<List<Chatroom>> build() {
    final repository = ref.watch(chatRepositoryProvider); // 중개소에서 가져오기
    final myUserId =
        ref.watch(testAuthNotifierProvider) ?? ''; // String? -> String 처리

    // 만약 로그인 정보가 없다면 빈 스트림 반환 (에러 방지)
    if (myUserId.isEmpty) return const Stream.empty();

    return repository.watchChatRooms(myUserId);
  }
}

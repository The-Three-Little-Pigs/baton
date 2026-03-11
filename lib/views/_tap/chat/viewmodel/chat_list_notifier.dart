// lib/views/_tap/chat/viewmodel/chat_list_notifier.dart
import 'package:baton/core/di/repository/chat_provider.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_list_notifier.g.dart';

@riverpod
class ChatListNotifier extends _$ChatListNotifier {
  @override
  Stream<List<Chatroom>> build() {
    final repository = ref.watch(chatRepositoryProvider); // 중개소에서 가져오기
    final myUserId =
        ref.watch(userProvider).value?.uid ?? ''; // String? -> String 처리

    // 만약 로그인 정보가 없다면 빈 리스트 스트림 반환 (무한 로딩 방지)
    if (myUserId.isEmpty) return Stream.value([]);

    return repository.watchChatRooms(myUserId);
  }
}

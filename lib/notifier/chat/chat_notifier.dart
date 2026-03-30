import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_list_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_notifier.g.dart';

@riverpod
int totalUnreadCount(Ref ref) {
  final myUserId = ref.watch(userProvider).value?.uid;
  if (myUserId == null) return 0;
  // 채팅방 리스트를 구독하여 모든 방의 내 안읽은 개수를 더함
  final chatRoomsAsync = ref.watch(chatListProvider);
  return chatRoomsAsync.when(
    data: (rooms) =>
        rooms.fold(0, (sum, room) => sum + (room.unreadCounts[myUserId] ?? 0)),
    loading: () => 0,
    error: (_, __) => 0,
  );
}

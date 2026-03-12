// lib/views/_tap/chat/viewmodel/chat_room_action_notifier.dart
import 'package:baton/core/di/repository/chat_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_room_action_notifier.g.dart';

@riverpod
class ChatRoomActionNotifier extends _$ChatRoomActionNotifier {
  @override
  void build() {} // 상태를 유지하지 않는 Action 전용 클래스

  // 💡 Result 패턴을 사용하여 '성공(방ID)' 시와 '실패(에러 메시지)' 시를 명확히 구분
  Result<String, Failure> joinRoom({
    required String targetUserId,
    required String productId,
  }) {
    // 1. 내 UID 가져오기
    // TODO: targetUserId 검증 주석 해제하기
    // if (targetUserId.isEmpty) {
    //   return Error(UnknownFailure('판매자 정보가 올바르지 않습니다.'));
    // }
    final myUser = ref.read(userProvider).value; // 생성하신 UserNotifier 사용

    if (myUser == null) {
      return Error(UnknownFailure('로그인이 필요한 서비스입니다.'));
    }

    final myUserId = myUser.uid;

    // 2. 나와의 채팅 차단
    if (myUserId == targetUserId) {
      return Error(UnknownFailure('자신의 상품에는 채팅을 걸 수 없습니다.'));
    }

    // 3. 채팅방 ID 생성 (기본 로직 유지)
    final roomId = _createRoomId(myUserId, targetUserId, productId);

    // 성공 시 방 ID 반환
    return Success(roomId);
  }

  // 기존 ChatTap에 있던 방 ID 생성 규칙 (알파벳 순서 정렬)
  String _createRoomId(String userId1, String userId2, String productId) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return '${userIds[0]}_${userIds[1]}_$productId';
  }

  Future<Result<bool, Failure>> leaveChatRoom(String roomId) async {
    final myUid = ref.read(userProvider).value?.uid;
    if (myUid == null) return Error(UnknownFailure('로그인이 필요합니다.'));
    // 리포지토리의 leaveRoom 호출
    final result = await ref
        .read(chatRepositoryProvider)
        .leaveRoom(roomId, myUid);

    return result;
  }
}

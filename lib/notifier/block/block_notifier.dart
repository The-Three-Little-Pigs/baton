import 'package:baton/core/di/repository/block_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/block.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_notifier.g.dart';

class BlockState {
  final List<Block> myBlocks; // 내가 차단한 블락 목록
  final List<Block> blockedByBlocks; // 나를 차단한 블락 목록

  const BlockState({this.myBlocks = const [], this.blockedByBlocks = const []});

  // 내가 차단한 유저 ID 집합
  Set<String> get blockedUserIds => myBlocks.map((b) => b.blockedId).toSet();
  // 나를 차단한 유저 ID 집합
  Set<String> get blockedByUserIds =>
      blockedByBlocks.map((b) => b.blockerId).toSet();
  // 홈탭에서 숨겨야 할 사용자 ID 집합
  Set<String> get allHiddenUserIds => {...blockedUserIds, ...blockedByUserIds};
  // 내가 차단했는지 확인
  bool isBlockedByMe(String uid) => blockedUserIds.contains(uid);
  // 나를 차단했는지 확인
  bool isBlockedMe(String uid) => blockedByUserIds.contains(uid);

  // 차단 해제 시 필요한 문서 ID 조회
  String? blockDocIdFor(String uid) {
    final block = myBlocks.where((b) => b.blockedId == uid).firstOrNull;
    return block?.id;
  }
}

@Riverpod(keepAlive: true)
class BlockNotifier extends _$BlockNotifier {
  List<Block> _myBlocks = [];
  List<Block> _blockedByBlocks = [];
  @override
  BlockState build() {
    final myUid = FirebaseAuth.instance.currentUser?.uid;
    if (myUid == null) return const BlockState();

    final blockRepo = ref.read(blockRepositoryProvider);
    // 내가 차단한 목록 감시
    final myBlocksSub = blockRepo.watchMyBlocks(myUid).listen((result) {
      switch (result) {
        case Success(value: final blocks):
          _myBlocks = blocks;
          state = _createState();
        case Error():
          break;
      }
    });
    // 나를 차단한 목록 감시
    final blockedBySub = blockRepo.watchBlockedBy(myUid).listen((result) {
      switch (result) {
        case Success(value: final blocks):
          _blockedByBlocks = blocks;
          state = _createState();
        case Error():
          break;
      }
    });
    ref.onDispose(() {
      myBlocksSub.cancel();
      blockedBySub.cancel();
    });
    return const BlockState();
  }

  BlockState _createState() =>
      BlockState(myBlocks: _myBlocks, blockedByBlocks: _blockedByBlocks);

  Future<void> toggleBlock(String otherUid) async {
    final myUid = FirebaseAuth.instance.currentUser?.uid;
    if (myUid == null) return;
    final blockRepo = ref.read(blockRepositoryProvider);
    if (state.isBlockedByMe(otherUid)) {
      final docId = state.blockDocIdFor(otherUid);
      if (docId != null) {
        await blockRepo.unblockUser(docId);
      }
    } else {
      await blockRepo.blockUser(myUid, otherUid);
    }
  }
}

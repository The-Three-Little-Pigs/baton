import 'package:baton/core/di/db/db_provider.dart';
import 'package:baton/core/di/repository/block_provider.dart';
import 'package:baton/core/error/failure.dart';
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
  Set<String> _localBlockedIds = {};

  @override
  BlockState build() {
    final myUid = FirebaseAuth.instance.currentUser?.uid;
    if (myUid == null) return const BlockState();

    final blockRepo = ref.read(blockRepositoryProvider);
    final database = ref.watch(batonDatabaseProvider);

    // 1. 로컬 DB 감시 (즉각 반응용)
    final localBlocksSub = database.watchAllBlocks().listen((localBlocks) {
      _localBlockedIds = localBlocks.map((b) => b.blockedUid).toSet();
      state = _createState();
    });

    // 2. 내가 차단한 목록 감시 (Firestore)
    final myBlocksSub = blockRepo.watchMyBlocks(myUid).listen((result) {
      if (result is Success<List<Block>, Failure>) {
        _myBlocks = result.value;
        state = _createState();
      }
    });

    // 3. 나를 차단한 목록 감시 (Firestore)
    final blockedBySub = blockRepo.watchBlockedBy(myUid).listen((result) {
      if (result is Success<List<Block>, Failure>) {
        _blockedByBlocks = result.value;
        state = _createState();
      }
    });

    ref.onDispose(() {
      localBlocksSub.cancel();
      myBlocksSub.cancel();
      blockedBySub.cancel();
    });

    return const BlockState();
  }

  BlockState _createState() {
    // Firestore 데이터와 로컬 데이터를 합쳐서 상태 생성
    // 로컬 데이터를 우선순위에 두어 낙관적 업데이트 효과 극대화
    final combinedMyBlocks = [..._myBlocks];
    
    // 로컬에는 있지만 Firestore에는 아직 반영 안 된 것들 추가
    for (final localId in _localBlockedIds) {
      if (!combinedMyBlocks.any((b) => b.blockedId == localId)) {
        combinedMyBlocks.add(Block(
          id: 'local_$localId',
          blockerId: FirebaseAuth.instance.currentUser?.uid ?? '',
          blockedId: localId,
          createdAt: DateTime.now(),
        ));
      }
    }

    return BlockState(
      myBlocks: combinedMyBlocks,
      blockedByBlocks: _blockedByBlocks,
    );
  }

  Future<void> toggleBlock(String otherUid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid.isEmpty) return;
    
    final myUid = user.uid;
    final blockRepo = ref.read(blockRepositoryProvider);
    
    // 리포지토리가 이미 로컬 DB와 서버를 동시에 처리하므로 직접 호출만 하면 됨
    if (state.isBlockedByMe(otherUid)) {
      final docId = state.blockDocIdFor(otherUid);
      // Firestore 문서 ID가 없는 경우(로컬 전용 상태)에도 처리가 가능하도록 체크
      if (docId != null && !docId.startsWith('local_')) {
        await blockRepo.unblockUser(docId);
      } else {
        // 로컬에만 있는 상태면 로컬 DB에서 직접 제거 시도 (동기화 보정)
        final database = ref.read(batonDatabaseProvider);
        await database.removeBlock(otherUid);
      }
    } else {
      await blockRepo.blockUser(myUid, otherUid);
    }
  }
}

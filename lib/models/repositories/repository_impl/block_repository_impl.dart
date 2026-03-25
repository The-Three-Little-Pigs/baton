import 'package:baton/core/database/baton_database.dart' as db;
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/block.dart';
import 'package:baton/models/repositories/repository/block_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlockRepositoryImpl implements BlockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final db.BatonDatabase _database;

  BlockRepositoryImpl({required db.BatonDatabase database}) : _database = database;

  static const String _collectionPath = 'blocks';

  @override
  Future<Result<void, Failure>> blockUser(
    String blockerId,
    String blockedId,
  ) async {
    if (blockerId.isEmpty || blockedId.isEmpty) {
      return Error(ServerFailure('사용자 ID가 유효하지 않습니다. (blockerId: $blockerId, blockedId: $blockedId)'));
    }

    bool isLocalSuccess = false;
    try {
      // 1. 로컬 DB 선반영 (낙관적 업데이트)
      await _database.toggleBlock(blockedId);
      isLocalSuccess = true;

      // 2. 서버 반영
      final docRef = _firestore.collection(_collectionPath).doc();
      final block = Block(
        id: docRef.id,
        blockerId: blockerId,
        blockedId: blockedId,
        createdAt: DateTime.now(),
      );
      await docRef.set(block.toJson());
      return const Success(null);
    } on FirebaseException catch (e) {
      if (isLocalSuccess) {
        await _database.toggleBlock(blockedId).catchError((_) {});
      }
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      if (isLocalSuccess) {
        await _database.toggleBlock(blockedId).catchError((_) {});
      }
      return Error(ServerFailure('차단 실패: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> unblockUser(String blockDocId) async {
    String? capturedBlockedId;
    bool isLocalSuccess = false;
    try {
      // 로컬 DB에서 지우기 위해 먼저 정보를 가져옴
      final doc =
          await _firestore.collection(_collectionPath).doc(blockDocId).get();
      if (doc.exists) {
        capturedBlockedId = doc.data()?['blockedId'] as String?;
        if (capturedBlockedId != null) {
          await _database.removeBlock(capturedBlockedId);
          isLocalSuccess = true;
        }
      }

      await _firestore.collection(_collectionPath).doc(blockDocId).delete();
      return const Success(null);
    } on FirebaseException catch (e) {
      if (isLocalSuccess && capturedBlockedId != null) {
        await _database.toggleBlock(capturedBlockedId).catchError((_) {});
      }
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      if (isLocalSuccess && capturedBlockedId != null) {
        await _database.toggleBlock(capturedBlockedId).catchError((_) {});
      }
      return Error(ServerFailure('차단 해제 실패: $e'));
    }
  }

  @override
  Stream<Result<List<Block>, Failure>> watchMyBlocks(String myUid) {
    return _firestore
        .collection(_collectionPath)
        .where('blockerId', isEqualTo: myUid)
        .snapshots()
        .map((snapshot) {
          try {
            final blocks = snapshot.docs.map((doc) {
              return Block.fromJson(doc.data()).copyWith(id: doc.id);
            }).toList();
            return Success(blocks);
          } catch (e) {
            return Error(ServerFailure('차단 목록 로드 실패: $e'));
          }
        });
  }

  @override
  Stream<Result<List<Block>, Failure>> watchBlockedBy(String myUid) {
    return _firestore
        .collection(_collectionPath)
        .where('blockedId', isEqualTo: myUid)
        .snapshots()
        .map((snapshot) {
          try {
            final blocks = snapshot.docs.map((doc) {
              return Block.fromJson(doc.data()).copyWith(id: doc.id);
            }).toList();
            return Success(blocks);
          } catch (e) {
            return Error(ServerFailure('차단 목록 로드 실패: $e'));
          }
        });
  }
}

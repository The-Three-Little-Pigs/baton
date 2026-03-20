import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/block.dart';
import 'package:baton/models/repositories/repository/block_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlockRepositoryImpl implements BlockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collectionPath = 'blocks';

  @override
  Future<Result<void, Failure>> blockUser(
    String blockerId,
    String blockedId,
  ) async {
    try {
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
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('차단 실패: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> unblockUser(String blockDocId) async {
    try {
      await _firestore.collection(_collectionPath).doc(blockDocId).delete();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
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

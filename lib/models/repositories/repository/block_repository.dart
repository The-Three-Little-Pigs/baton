import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/block.dart';

abstract class BlockRepository {
  Future<Result<void, Failure>> blockUser(String blockerId, String blockedId);
  Future<Result<void, Failure>> unblockUser(String blockDocId);
  Stream<Result<List<Block>, Failure>> watchMyBlocks(String myUid);
  Stream<Result<List<Block>, Failure>> watchBlockedBy(String myUid);
}

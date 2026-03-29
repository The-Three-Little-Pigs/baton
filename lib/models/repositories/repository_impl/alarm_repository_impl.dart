import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/alarm.dart';
import 'package:baton/models/repositories/repository/alarm_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = "alarms";

  @override
  Future<Result<List<Alarm>, Failure>> fetchAlarms(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionPath)
          .where('receiver_id', isEqualTo: userId)
          .get();

      final alarms = snapshot.docs.map((doc) => Alarm.fromJson(doc.data())).toList();
      
      // 최신순 정렬 (index 에러 방지를 위해 클라이언트 단에서 수행)
      alarms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return Success(alarms);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Result<List<Alarm>, Failure>> watchAlarms(String userId) {
    return _firestore
        .collection(_collectionPath)
        .where('receiver_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      try {
        final alarms = snapshot.docs.map((doc) => Alarm.fromJson(doc.data())).toList();
        
        // 최신순 정렬 (index 에러 방지를 위해 클라이언트 단에서 수행)
        alarms.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        return Success(alarms);
      } on FirebaseException catch (e) {
        return Error(FirebaseErrorMapper.toFailure(e));
      } catch (e) {
        return Error(ServerFailure(e.toString()));
      }
    });
  }

  @override
  Future<Result<void, Failure>> markAsRead(String alarmId) async {
    try {
      await _firestore.collection(_collectionPath).doc(alarmId).update({
        'is_read': true,
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> markAllAsRead(String userId) async {
    try {
      final unreadAlarms = await _firestore
          .collection(_collectionPath)
          .where('receiver_id', isEqualTo: userId)
          .where('is_read', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in unreadAlarms.docs) {
        batch.update(doc.reference, {'is_read': true});
      }
      await batch.commit();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void, Failure>> deleteAlarm(String alarmId) async {
    try {
      await _firestore.collection(_collectionPath).doc(alarmId).delete();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}

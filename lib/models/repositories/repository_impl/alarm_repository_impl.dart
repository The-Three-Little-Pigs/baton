import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/alarm.dart';
import 'package:baton/models/repositories/repository/alarm_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<List<Alarm>, Failure>> getAlarms(String receiverId) async {
    try {
      final snapshot = await _firestore
          .collection('alarms')
          .where('receiver_id', isEqualTo: receiverId)
          .orderBy('created_at', descending: true)
          .get();

      final alarms = snapshot.docs
          .map((doc) => Alarm.fromJson(doc.data()))
          .toList();

      return Success(alarms);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알림을 불러오는 중 오류가 발생했습니다: $e'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteAlarms(List<String> alarmIds) async {
    try {
      final batch = _firestore.batch();

      for (final id in alarmIds) {
        batch.delete(_firestore.collection('alarms').doc(id));
      }

      await batch.commit();
      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알림 삭제 중 오류가 발생했습니다: $e'));
    }
  }
}

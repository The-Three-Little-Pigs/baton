import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/alarm.dart';

abstract class AlarmRepository {
  /// 유저의 알림 목록을 가져옵니다.
  Future<Result<List<Alarm>, Failure>> fetchAlarms(String userId);

  /// 유저의 알림 목록을 실시간으로 감시합니다.
  Stream<Result<List<Alarm>, Failure>> watchAlarms(String userId);

  /// 특정 알림을 읽음 처리합니다.
  Future<Result<void, Failure>> markAsRead(String alarmId);

  /// 모든 알림을 읽음 처리합니다.
  Future<Result<void, Failure>> markAllAsRead(String userId);

  /// 특정 알림을 삭제합니다.
  Future<Result<void, Failure>> deleteAlarm(String alarmId);
}

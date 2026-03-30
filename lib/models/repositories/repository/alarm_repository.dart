import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/alarm.dart';

abstract class AlarmRepository {
  /// 수신자의 알림 목록을 가져옵니다.
  Future<Result<List<Alarm>, Failure>> getAlarms(String receiverId);

  /// 선택된 알림들을 한꺼번에 삭제합니다.
  Future<Result<void, Failure>> deleteAlarms(List<String> alarmIds);
}

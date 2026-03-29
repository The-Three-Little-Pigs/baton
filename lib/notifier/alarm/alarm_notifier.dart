import 'package:baton/core/di/repository/alarm_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/alarm.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alarm_notifier.g.dart';

@riverpod
class AlarmNotifier extends _$AlarmNotifier {
  @override
  Stream<List<Alarm>> build() {
    // 1. 현재 로그인한 유저 정보 감시
    final user = ref.watch(userProvider).value;
    
    // 유저 정보가 없으면 빈 스트림 반환
    if (user == null || user.uid.isEmpty) {
      return Stream.value([]);
    }

    // 2. Repository를 통해 실시간 알림 스트림 구독
    return ref.watch(alarmRepositoryProvider).watchAlarms(user.uid).map((result) {
      return switch (result) {
        Success(:final value) => value,
        Error() => [], // 에러 시 빈 리스트 (필요 시 에러 처리 추가 가능)
      };
    });
  }

  /// 특정 알림을 읽음 처리합니다.
  Future<void> markAsRead(String alarmId) async {
    await ref.read(alarmRepositoryProvider).markAsRead(alarmId);
  }

  /// 모든 알림을 읽음 처리합니다.
  Future<void> markAllAsRead() async {
    final user = ref.read(userProvider).value;
    if (user != null) {
      await ref.read(alarmRepositoryProvider).markAllAsRead(user.uid);
    }
  }

  /// 특정 알림을 삭제합니다.
  Future<void> deleteAlarm(String alarmId) async {
    await ref.read(alarmRepositoryProvider).deleteAlarm(alarmId);
  }
}

/// 읽지 않은 알림 개수를 계산하는 Provider
@riverpod
int unreadAlarmCount(Ref ref) {
  final alarms = ref.watch(alarmProvider).value ?? [];
  return alarms.where((alarm) => !alarm.isRead).length;
}

import 'package:baton/core/di/repository/alarm_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/alarm.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alarm_notifier.g.dart';

class AlarmState {
  final List<Alarm> alarms;
  final bool isEditMode;
  final Set<String> selectedAlarmIds;

  AlarmState({
    required this.alarms,
    this.isEditMode = false,
    this.selectedAlarmIds = const {},
  });

  AlarmState copyWith({
    List<Alarm>? alarms,
    bool? isEditMode,
    Set<String>? selectedAlarmIds,
  }) {
    return AlarmState(
      alarms: alarms ?? this.alarms,
      isEditMode: isEditMode ?? this.isEditMode,
      selectedAlarmIds: selectedAlarmIds ?? this.selectedAlarmIds,
    );
  }
}

@riverpod
class AlarmNotifier extends _$AlarmNotifier {
  @override
  FutureOr<AlarmState> build() async {
    // 유저 정보를 구독하여 변경 시 자동 재로드
    final user = ref.watch(userProvider).value;
    if (user == null) return AlarmState(alarms: []);

    final alarmRepo = ref.read(alarmRepositoryProvider);
    final result = await alarmRepo.fetchAlarms(user.uid);

    return switch (result) {
      Success(value: final alarms) => AlarmState(alarms: alarms),
      Error(failure: final failure) => throw failure.message,
    };
  }

  /// 편집 모드 토글
  void toggleEditMode() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData(
      currentState.copyWith(
        isEditMode: !currentState.isEditMode,
        selectedAlarmIds: {}, // 모드 전환 시 선택 초기화
      ),
    );
  }

  /// 알림 선택/해제 토글
  void toggleSelection(String alarmId) {
    final currentState = state.value;
    if (currentState == null) return;

    final updated = Set<String>.from(currentState.selectedAlarmIds);
    if (updated.contains(alarmId)) {
      updated.remove(alarmId);
    } else {
      updated.add(alarmId);
    }
    state = AsyncData(currentState.copyWith(selectedAlarmIds: updated));
  }

  /// 선택된 알림들 삭제
  Future<void> deleteSelected() async {
    final currentState = state.value;
    if (currentState == null || currentState.selectedAlarmIds.isEmpty) return;

    final alarmRepo = ref.read(alarmRepositoryProvider);
    final result = await alarmRepo.deleteAlarms(
      currentState.selectedAlarmIds.toList(),
    );

    if (result is Success) {
      // 로컬 상태에서 즉각 제거하거나 리프레시
      ref.invalidateSelf();
    }
  }

  Future<void> markAllAsRead() async {
    final user = ref.read(userProvider).value;
    if (user == null) return;

    final alarmRepo = ref.read(alarmRepositoryProvider);
    final result = await alarmRepo.markAllAsRead(user.uid);

    if (result is Success) {
      ref.invalidateSelf();
    }
  }

  Future<void> markAsRead(String alarmId) async {
    final alarmRepo = ref.read(alarmRepositoryProvider);
    final result = await alarmRepo.markAsRead(alarmId);

    if (result is Success) {
      ref.invalidateSelf();
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
int unreadAlarmCount(Ref ref) {
  final alarmState = ref.watch(alarmProvider);
  return alarmState.maybeWhen(
    data: (state) => state.alarms.where((alarm) => !alarm.isRead).length,
    orElse: () => 0,
  );
}

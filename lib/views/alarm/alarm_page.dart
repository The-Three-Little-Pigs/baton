import 'package:baton/models/entities/alarm.dart';
import 'package:baton/notifier/alarm/alarm_notifier.dart';
import 'package:baton/views/alarm/widgets/alarm_item.dart';
import 'package:baton/views/alarm/widgets/edit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmPage extends ConsumerWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmAsync = ref.watch(alarmProvider);
    final isEditMode = alarmAsync.value?.isEditMode ?? false;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("알림"),
              IconButton(
                onPressed: () =>
                    ref.read(alarmProvider.notifier).toggleEditMode(),
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "전체 알림"),
              Tab(text: "상품 알림"),
            ],
          ),
        ),
        body: alarmAsync.when(
          data: (state) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TabBarView(
              children: [
                AlarmItemList(
                  alarms: state.alarms,
                  isEditMode: state.isEditMode,
                  selectedIds: state.selectedAlarmIds,
                ),
                AlarmItemList(
                  alarms: state.alarms, // 필터링 필요 시 여기서 처리
                  isEditMode: state.isEditMode,
                  selectedIds: state.selectedAlarmIds,
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text(e.toString())),
        ),
        bottomNavigationBar: isEditMode
            ? SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: EditButton(
                    onCancel: () =>
                        ref.read(alarmProvider.notifier).toggleEditMode(),
                    onDelete: () =>
                        ref.read(alarmProvider.notifier).deleteSelected(),
                    isDeleteEnabled:
                        alarmAsync.value?.selectedAlarmIds.isNotEmpty ?? false,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class AlarmItemList extends ConsumerWidget {
  const AlarmItemList({
    super.key,
    required this.alarms,
    required this.isEditMode,
    required this.selectedIds,
  });

  final List<Alarm> alarms;
  final bool isEditMode;
  final Set<String> selectedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (alarms.isEmpty) {
      return const Center(child: Text("알림이 없습니다."));
    }

    return ListView.separated(
      itemCount: alarms.length,
      itemBuilder: (context, index) {
        final alarm = alarms[index];
        return AlarmItem(
          icon: Icons.favorite,
          header: alarm.title,
          date: alarm.createdAt.toString().split(' ')[0], // 간단한 포맷팅
          imageUrl: alarm.imageUrl,
          content: Text(alarm.content),
          isEditMode: isEditMode,
          isSelected: selectedIds.contains(alarm.alarmId),
          onSelected: (_) =>
              ref.read(alarmProvider.notifier).toggleSelection(alarm.alarmId),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 32);
      },
    );
  }
}

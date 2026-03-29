import 'package:baton/models/entities/alarm.dart';
import 'package:baton/notifier/alarm/alarm_notifier.dart';
import 'package:baton/views/alarm/widgets/alarm_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AlarmPage extends ConsumerWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmAsyncValue = ref.watch(alarmProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("알림"),
          actions: [
            IconButton(
              onPressed: () {
                // 상단 메뉴 (모두 읽음 처리 등)
                _showMenu(context, ref);
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "전체 알림"),
              Tab(text: "상품 알림"),
            ],
          ),
        ),
        body: alarmAsyncValue.when(
          data: (alarms) => TabBarView(
            children: [
              // 전체 알림
              _AlarmList(alarms: alarms),
              // 상품 알림 (필터링 예시: 제목에 '찜'이나 '상품'이 들어간 것만)
              _AlarmList(
                alarms:
                    alarms
                        .where(
                          (a) =>
                              a.title.contains('찜') || a.title.contains('상품'),
                        )
                        .toList(),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('알림을 불러오지 못했습니다: $e')),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.done_all),
                title: const Text('모든 알림 읽음 처리'),
                onTap: () {
                  ref.read(alarmProvider.notifier).markAllAsRead();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlarmList extends ConsumerWidget {
  const _AlarmList({required this.alarms});

  final List<Alarm> alarms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (alarms.isEmpty) {
      return const Center(child: Text("알림이 없습니다."));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: alarms.length,
      itemBuilder: (context, index) {
        final alarm = alarms[index];
        return AlarmItem(
          icon: _getIcon(alarm.title),
          header: alarm.title,
          date: DateFormat('yyyy.MM.dd').format(alarm.createdAt),
          imageUrl: alarm.imageUrl,
          content: alarm.content,
          isRead: alarm.isRead,
          onTap: () {
            // 1. 읽음 처리
            ref.read(alarmProvider.notifier).markAsRead(alarm.alarmId);

            // 2. 이동 (예: 상품 상세 페이지 등)
            // TODO: 알림 타입에 따른 이동 로직 추가 (현재는 알림 상세가 없으므로 생략)
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 32);
      },
    );
  }

  IconData _getIcon(String title) {
    if (title.contains('찜')) return Icons.favorite_border;
    if (title.contains('채팅')) return Icons.chat_bubble_outline;
    return Icons.notifications_none;
  }
}

import 'package:baton/models/entities/alarm.dart';
import 'package:baton/views/alarm/widgets/alarm_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmPage extends ConsumerWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final alarmAsyncValue = ref.watch(alarmViewModelProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("알림"), Icon(Icons.more_vert)],
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "전체 알림"),
              Tab(text: "상품 알림"),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: TabBarView(
            children: [
              AlarmItemList(alarms: []),
              AlarmItemList(alarms: []),
            ],
          ),
        ),
      ),
    );
  }
}

class AlarmItemList extends StatelessWidget {
  const AlarmItemList({super.key, required this.alarms});

  final List<Alarm> alarms;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 2,
      itemBuilder: (context, index) {
        return AlarmItem(
          icon: Icons.favorite,
          header: "알림명",
          date: "2026-03-11",
          imageUrl: "https://picsum.photos/200",
          content: Text("알림 내용"),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(endIndent: 0, indent: 0);
      },
    );
  }
}

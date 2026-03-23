import 'dart:async';
import 'package:baton/core/di/repository/search_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/keyword.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hot_keyword_notifier.g.dart';

@Riverpod(keepAlive: true)
Future<List<Keyword>> hotKeyword(Ref ref) async {
  // 1. 다음 '정각'까지의 남은 시간 계산 (00분 00초 타겟)
  final now = DateTime.now();
  final nextHour = DateTime(now.year, now.month, now.day, now.hour + 1);
  final durationUntilNextHour = nextHour.difference(now);

  // 2. 정각에 맞춰 캐시를 무효화하는 타이머 설정
  final timer = Timer(durationUntilNextHour, () {
    ref.invalidateSelf();
  });

  // 2. 프로바이더가 해제되거나 다시 빌드될 때 타이머 취소
  ref.onDispose(() => timer.cancel());

  final result = await ref.read(searchRepositoryProvider).getHotKeywords();

  switch (result) {
    case Success(:final value):
      final sortedKeywords = List<Keyword>.from(value)
        ..sort((a, b) {
          if (a.count == b.count) {
            return a.keyword.compareTo(b.keyword);
          }
          return b.count.compareTo(a.count);
        });

      return sortedKeywords.take(10).toList();
    case Error(:final failure):
      throw Exception(failure.message);
  }
}

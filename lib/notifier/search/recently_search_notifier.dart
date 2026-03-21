import 'package:baton/core/di/repository/search_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recently_search_notifier.g.dart';

@riverpod
class RecentlySearchActions extends _$RecentlySearchActions {
  @override
  void build() {}

  /// 검색 기록 삭제
  Future<void> deleteHistory(int id) async {
    await ref.read(searchRepositoryProvider).deleteLocalSearchHistory(id);
  }

  /// 전체 검색 기록 초기화
  Future<void> clearAll() async {
    await ref.read(searchRepositoryProvider).clearLocalSearchHistory();
  }
}

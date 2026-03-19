import 'package:baton/core/di/repository/search_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/keyword.dart';
import 'package:baton/models/repositories/repository_impl/search_repository_impl.dart'; // 또는 provider import
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hot_keyword_notifier.g.dart';

@riverpod
class HotKeywordNotifier extends _$HotKeywordNotifier {
  @override
  FutureOr<List<Keyword>> build() async {
    return _fetchAndSortKeywords();
  }

  // 데이터 페칭 및 정렬 로직 (메인 로직)
  Future<List<Keyword>> _fetchAndSortKeywords() async {
    final result = await ref.read(searchRepositoryProvider).getHotKeywords();
    switch (result) {
      case Success(value: final keywords):
        final sortedKeywords = List<Keyword>.from(keywords)
          ..sort((a, b) {
            if (a.count == b.count) {
              return a.keyword.compareTo(b.keyword);
            }
            return b.count.compareTo(a.count);
          });

        return sortedKeywords.take(10).toList();
      case Error(failure: final failure):
        throw failure;
    }
  }
}

import 'package:baton/core/di/repository/search_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_field_notifier.g.dart';

@riverpod
class SearchFieldNotifier extends _$SearchFieldNotifier {
  @override
  String build() {
    return '';
  }

  void updateText(String text) {
    state = text;
  }

  /// 검색어 초기화 (X 버튼 누를 때 등)
  void clear() {
    state = '';
  }

  /// 검색 기록 저장 비즈니스 로직
  void recordSearch(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final repo = ref.read(searchRepositoryProvider);

    // 1. 서버 인기 검색어 집계 업데이트
    if (uid != null) {
      repo.updateSearchRecord(uid, trimmed);
    }

    // 2. 로컬 검색 기록(Drift) 저장
    repo.addLocalSearchHistory(trimmed);
  }
}

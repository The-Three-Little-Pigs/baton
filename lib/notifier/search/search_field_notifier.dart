import 'dart:async';
import 'package:baton/core/di/repository/search_provider.dart';
import 'package:baton/models/entities/search_field_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_field_notifier.g.dart';

@riverpod
class SearchFieldNotifier extends _$SearchFieldNotifier {
  @override
  SearchFieldState build() {
    return SearchFieldState.initial();
  }

  void updateText(String text) {
    state = state.copyWith(query: text);
  }

  /// 검색 실행 가능 여부 확인 및 쓰로틀링 적용 (상태 객체 내에서 관리)
  bool allowSearch(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return false;

    // 이미 쓰로틀링 중인지 확인
    if (state.throttledKeywords.contains(trimmed)) return false;

    // 쓰로틀링 상태 업데이트
    final newThrottled = Set<String>.from(state.throttledKeywords)
      ..add(trimmed);
    state = state.copyWith(throttledKeywords: newThrottled);

    // 쿨타임 후 쓰로틀링 해제 로직
    Timer(SearchFieldState.throttleDuration, () {
      // Notifier가 이미 dispose 되었을 경우 예외가 발생할 수 있으므로 가드
      try {
        final currentThrottled = Set<String>.from(state.throttledKeywords)
          ..remove(trimmed);
        state = state.copyWith(throttledKeywords: currentThrottled);
      } catch (_) {
        // 이미 해제된 프로바이더에 대한 업데이트는 무시
      }
    });

    return true;
  }

  /// 검색어 초기화 (X 버튼 누를 때 등)
  void clear() {
    state = state.copyWith(query: '');
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

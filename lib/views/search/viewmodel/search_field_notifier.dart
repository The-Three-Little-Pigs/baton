import 'package:baton/views/search/viewmodel/recently_search_term_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_field_notifier.g.dart';

@riverpod
class SearchFieldNotifier extends _$SearchFieldNotifier {
  @override
  String build() {
    return ''; // 초기 검색어 상태는 빈 문자열
  }

  /// 검색어 텍스트 업데이트
  /// 
  /// 사용자가 타이핑할 때마다 상태만 즉시 업데이트합니다.
  /// (검색 버튼 클릭 시에만 검색 동작을 수행하므로 디바운싱 사용 안 함)
  void updateText(String text) {
    state = text;
  }

  /// 검색어 초기화 (X 버튼 누를 때 등)
  void clear() {
    state = '';
  }

  /// 최종 검색 버튼 클릭 (제출)
  /// UI 단(View)에서 라우팅 처리를 직접 할 수 있도록, 
  /// 유효한 검색어일 경우 해당 키워드를 반환하고 아닐 경우 null을 반환합니다.
  String? submitSearch() {
    final keyword = state.trim();
    if (keyword.isEmpty) return null;

    // 로컬 최근 검색어 리스트에 추가 (내부적으로 Hive 등에 저장 처리됨)
    // 참고: 최근 검색어 Notifier의 프로바이더 이름을 프로젝트 상황에 맞게 수정하세요. 
    // (예: recentlySearchTermProvider 등)
    // ref.read(recentlySearchTermProvider.notifier).add(keyword);

    return keyword;
  }
}

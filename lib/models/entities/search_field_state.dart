class SearchFieldState {
  static const throttleDuration = Duration(seconds: 1);
  final String query;
  final Set<String> throttledKeywords;

  const SearchFieldState({
    required this.query,
    required this.throttledKeywords,
  });

  factory SearchFieldState.initial() => const SearchFieldState(
        query: '',
        throttledKeywords: {},
      );

  SearchFieldState copyWith({
    String? query,
    Set<String>? throttledKeywords,
  }) {
    return SearchFieldState(
      query: query ?? this.query,
      throttledKeywords: throttledKeywords ?? this.throttledKeywords,
    );
  }
}

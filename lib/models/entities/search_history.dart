// lib/models/entities/search_history.dart

class SearchHistory {
  final int id;
  final String query;
  final DateTime createdAt;

  SearchHistory({
    required this.id,
    required this.query,
    required this.createdAt,
  });

  SearchHistory copyWith({
    int? id,
    String? query,
    DateTime? createdAt,
  }) {
    return SearchHistory(
      id: id ?? this.id,
      query: query ?? this.query,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

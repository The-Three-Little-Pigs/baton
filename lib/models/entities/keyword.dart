class Keyword {
  final String keyword;
  final int count;

  Keyword({required this.keyword, required this.count});

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(keyword: json['keyword'] ?? '', count: json['count'] ?? 0);
  }

  Map<String, dynamic> toJson() => {'keyword': keyword, 'count': count};
}

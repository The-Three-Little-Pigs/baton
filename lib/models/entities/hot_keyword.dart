class HotKeyword {
  final String keyword;
  final int count;

  HotKeyword({required this.keyword, required this.count});

  factory HotKeyword.fromJson(Map<String, dynamic> json) {
    return HotKeyword(
      keyword: json['keyword'] ?? '',
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'keyword': keyword, 'count': count};
}

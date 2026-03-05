class WritePageState {
  final String title;
  final String content;
  final double price;
  final List<String> images;

  WritePageState({
    required this.title,
    required this.content,
    required this.price,
    required this.images,
  });

  WritePageState copyWith({
    String? title,
    String? content,
    String? tradeType,
    double? price,
    List<String>? images,
  }) {
    return WritePageState(
      title: title ?? this.title,
      content: content ?? this.content,
      price: price ?? this.price,
      images: images ?? this.images,
    );
  }
}

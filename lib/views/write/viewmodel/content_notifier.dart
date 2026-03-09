import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_notifier.g.dart';

class ContentState {
  final String title;
  final String content;
  final int contentLength;

  ContentState({
    required this.title,
    required this.content,
    required this.contentLength,
  });

  ContentState copyWith({String? title, String? content, int? contentLength}) {
    return ContentState(
      title: title ?? this.title,
      content: content ?? this.content,
      contentLength: contentLength ?? this.contentLength,
    );
  }
}

@riverpod
class ContentNotifier extends _$ContentNotifier {
  @override
  ContentState build() {
    return ContentState(title: "", content: "", contentLength: 0);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setContent(String content) {
    state = state.copyWith(content: content, contentLength: content.length);
  }
}

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
}

@riverpod
class ContentNotifier extends _$ContentNotifier {
  @override
  ContentState build() {
    return ContentState(title: "", content: "", contentLength: 0);
  }

  void setTitle(String title) {
    state = ContentState(
      title: title,
      content: state.content,
      contentLength: state.contentLength,
    );
  }

  void setContent(String content) {
    state = ContentState(
      title: state.title,
      content: content,
      contentLength: content.length,
    );
  }
}

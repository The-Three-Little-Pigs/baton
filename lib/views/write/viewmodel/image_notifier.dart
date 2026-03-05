import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_notifier.g.dart';

@riverpod
class ImageNotifier extends _$ImageNotifier {
  @override
  List<String> build() {
    return [];
  }

  void addImage(String xFilePath) {
    state = [...state, xFilePath];
  }

  void removeAt(int index) {
    state = [...state]..removeAt(index);
  }
}

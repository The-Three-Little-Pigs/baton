import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_notifier.g.dart';

@riverpod
class ImageNotifier extends _$ImageNotifier {
  @override
  List<String> build() {
    return [];
  }

  /// 이미지 추가 (낙관적 업데이트: 즉시 로컬 경로로 추가)
  void addImage(String xFilePath) {
    state = [...state, xFilePath];
  }

  /// 이미지 제거
  void removeAt(int index) {
    state = [...state]..removeAt(index);
  }
}

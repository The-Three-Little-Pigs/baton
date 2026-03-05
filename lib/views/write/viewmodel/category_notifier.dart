import 'package:baton/models/enum/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_notifier.g.dart';

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  String? build() {
    return null;
  }

  void setCategory(String category) {
    state = category;
  }
}

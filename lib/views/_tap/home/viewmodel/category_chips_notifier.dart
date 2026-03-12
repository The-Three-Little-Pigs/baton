import 'package:baton/models/enum/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_chips_notifier.g.dart';

@riverpod
class CategoryChipsNotifier extends _$CategoryChipsNotifier {
  @override
  Set<Category> build() {
    return {};
  }

  void toggleCategory(Category category) {
    state = state.contains(category)
        ? state.where((c) => c != category).toSet()
        : {...state, category};
  }

  void clear() {
    state = {};
  }
}

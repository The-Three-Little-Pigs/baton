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
    if (state.contains(category)) {
      state = {...state}..remove(category);
    } else {
      state = {...state, category};
    }
  }

  void reset() {
    state = {};
  }
}

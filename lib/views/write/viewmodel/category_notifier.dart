import 'package:baton/models/enum/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_notifier.g.dart';

sealed class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategorySelected extends CategoryState {
  final Category category;
  const CategorySelected(this.category);
}

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  CategoryState build() {
    return CategoryInitial();
  }

  void setCategory(Category category) {
    state = CategorySelected(category);
  }
}

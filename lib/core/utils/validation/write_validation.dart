import 'package:baton/views/write/viewmodel/category_notifier.dart';

class WriteValidation {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '제목을 입력해 주세요.';
    }
    if (value.trim().length < 2) {
      return '제목은 최소 2자 이상 입력해 주세요.';
    }
    if (value.trim().length > 50) {
      return '제목은 최대 50자까지 입력 가능합니다.';
    }
    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '내용을 입력해 주세요.';
    }
    if (value.trim().length < 10) {
      return '상세한 설명을 위해 10자 이상 입력해 주세요.';
    }
    return null;
  }

  static String? validateCategory(CategoryState state) {
    if (state is CategoryInitial) {
      return '카테고리를 선택해 주세요.';
    }
    return null;
  }

  static String? validatePrice(double? value) {
    if (value == null) {
      return '가격을 입력해 주세요. (0원 가능)';
    }

    final price = value.toInt();
    if (price < 0) {
      return '가격은 0원 이상이어야 합니다.';
    }

    if (price >= 1000000000) {
      return '10억 미만의 금액만 입력 가능합니다.';
    }

    return null;
  }
}

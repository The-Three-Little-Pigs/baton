import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/utils/validation/write_validation.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/service/image_picker_service.dart';
import 'package:baton/views/write/viewmodel/category_notifier.dart';
import 'package:baton/views/write/viewmodel/content_notifier.dart';
import 'package:baton/views/write/viewmodel/image_notifier.dart';
import 'package:baton/views/write/viewmodel/sale_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'write_page_view_model.g.dart';

@riverpod
class WritePageViewModel extends _$WritePageViewModel {
  @override
  Future<void> build() async {}

  String? validate() {
    final contentState = ref.read(contentProvider);
    final saleState = ref.read(saleProvider);
    final category = ref.read(categoryProvider);

    final titleValidate = WriteValidation.validateTitle(contentState.title);
    final categoryValidate = WriteValidation.validateCategory(category);
    final contentValidate = WriteValidation.validateContent(
      contentState.content,
    );
    final saleValidate = WriteValidation.validatePrice(saleState.purchasePrice);

    if (titleValidate != null) {
      return titleValidate;
    }

    if (categoryValidate != null) {
      return categoryValidate;
    }

    if (contentValidate != null) {
      return contentValidate;
    }

    if (saleValidate != null) {
      return saleValidate;
    }

    return null;
  }

  Future<String?> createPost() async {
    if (state.isLoading) return null;

    final contentState = ref.read(contentProvider);
    final saleState = ref.read(saleProvider);
    final category = ref.read(categoryProvider);
    final images = ref.read(imageProvider);

    if (category is! CategorySelected) {
      return '카테고리를 선택해 주세요.';
    }

    final selectedCategory = category.category;

    state = const AsyncLoading();

    List<String> imageUrls = [];

    // 이미지 업로드 수행
    if (images.isNotEmpty) {
      final uploadResult = await ImagePickerService().getDownloadUrls(images);

      switch (uploadResult) {
        case Success(value: final urls):
          imageUrls = urls;
        case Error(failure: final f):
          state = AsyncError(f, StackTrace.current);
          return f.message;
      }
    }

    final String? thumbnailUrl = imageUrls.isNotEmpty ? imageUrls.first : null;

    final post = Post(
      imageUrls: imageUrls,
      title: contentState.title,
      content: contentState.content,
      category: selectedCategory,
      purchasePrice: saleState.purchasePrice,
      salePrice: saleState.salePrice ?? 0,
      likeCount: 0,
      chatCount: 0,
      thumbnailUrl: thumbnailUrl,
      createdAt: DateTime.now().toIso8601String(),
      authorId: "",
      postId: "",
      status: ProductStatus.available,
    );

    final result = await ref.read(postRepositoryProvider).createPost(post);

    switch (result) {
      case Success():
        state = const AsyncData(null);
        return null;
      case Error(failure: final f):
        state = AsyncError(f, StackTrace.current);
        return f.message;
    }
  }
}

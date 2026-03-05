import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/utils/validation/write_validation.dart';
import 'package:baton/models/entities/post.dart';
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
    final user = ref.read(userProvider);

    final post = Post(
      imageUrls: images,
      title: contentState.title,
      content: contentState.content,
      category: category!,
      purchasePrice: saleState.purchasePrice,
      salePrice: saleState.salePrice ?? 0,
      likeCount: 0,
      chatCount: 0,
      createdAt: DateTime.now().toString(),
      authorId: user.uid,
      postId: "",
    );

    state = const AsyncLoading();

    final result = await ref
        .read(postRepositoryProviderProvider)
        .createPost(post);

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

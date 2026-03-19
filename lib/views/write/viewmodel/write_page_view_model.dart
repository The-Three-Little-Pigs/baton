import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/utils/validation/write_validation.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/service/firebase_storage_uploader.dart';
import 'package:baton/views/write/viewmodel/category_notifier.dart';
import 'package:baton/views/write/viewmodel/content_notifier.dart';
import 'package:baton/views/write/viewmodel/image_notifier.dart';
import 'package:baton/views/write/viewmodel/sale_notifier.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'write_page_view_model.g.dart';

@riverpod
class WritePageViewModel extends _$WritePageViewModel {
  @override
  FutureOr<void> build({String? postId}) async {
    if (postId != null) {
      // initState와 같은 역할: build 시점에 데이터를 가져와 다른 Notifier들을 초기화
      final result = await ref.read(postRepositoryProvider).getPostById(postId);

      if (result is Success<Post, Failure>) {
        final post = result.value;
        // build 도중 다른 Notifier의 상태를 직접 수정하기보다는
        // addPostFrameCallback 혹은 차후 프레임에서 안전하게 동기화
        WidgetsBinding.instance.addPostFrameCallback((_) {
          initWithPost(post);
        });
      }
    }
  }

  void initWithPost(Post post) {
    ref.read(contentProvider.notifier).initWithPost(post.title, post.content);
    ref.read(categoryProvider.notifier).setCategory(post.category);
    ref
        .read(saleProvider.notifier)
        .initWithPost(post.purchasePrice, post.salePrice);
    ref.read(imageProvider.notifier).initImages(post.imageUrls);
  }

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

    if (titleValidate != null) return titleValidate;
    if (categoryValidate != null) return categoryValidate;
    if (contentValidate != null) return contentValidate;
    if (saleValidate != null) return saleValidate;

    return null;
  }

  Future<String?> submitPost() async {
    if (state.isLoading) return null;

    final contentState = ref.read(contentProvider);
    final saleState = ref.read(saleProvider);
    final category = ref.read(categoryProvider);
    final images = ref.read(imageProvider);

    state = const AsyncLoading();

    List<String> imageUrls = [];

    // 이미지 처리 (새 파일 업로드 및 기존 URL 유지)
    final List<String> newFiles = images
        .where((path) => !path.startsWith('http'))
        .toList();
    final List<String> existingUrls = images
        .where((path) => path.startsWith('http'))
        .toList();

    if (newFiles.isNotEmpty) {
      final uploadResult = await FirebaseStorageUploader().getDownloadUrls(newFiles);
      switch (uploadResult) {
        case Success(value: final urls):
          imageUrls = [...existingUrls, ...urls];
        case Error(failure: final f):
          state = AsyncError(f, StackTrace.current);
          return f.message;
      }
    } else {
      imageUrls = existingUrls;
    }

    final String? thumbnailUrl = imageUrls.isNotEmpty ? imageUrls.first : null;
    final authorResult = ref.read(userProvider);
    if (authorResult is Error || authorResult.value == null) {
      state = AsyncError(
        UnknownFailure("유저 정보를 불러올 수 없습니다."),
        StackTrace.current,
      );
      return "author_error";
    }

    final post = Post(
      postId: postId ?? "",
      title: contentState.title,
      content: contentState.content,
      category: category!,
      purchasePrice: saleState.purchasePrice,
      salePrice: saleState.salePrice ?? 0,
      likeCount: 0,
      chatCount: 0,
      createdAt: DateTime.now(),
      authorId: authorResult.value!.uid,
      status: ProductStatus.available,
      imageUrls: imageUrls,
      viewCount: 0, // 🔥 신규 작성 시 0으로 초기화
    );

    final result = (postId != null)
        ? await ref.read(postRepositoryProvider).updatePost(post)
        : await ref.read(postRepositoryProvider).createPost(post);

    switch (result) {
      case Success():
        state = const AsyncData(null);
        return "success";
      case Error(failure: final f):
        state = AsyncError(f, StackTrace.current);
        return f.message;
    }
  }
}

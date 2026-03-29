import 'package:baton/core/utils/logger.dart';
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
    final images = ref.read(imageProvider);

    final imageValidate = WriteValidation.validateImage(images);
    final titleValidate = WriteValidation.validateTitle(contentState.title);
    final categoryValidate = WriteValidation.validateCategory(category);
    final contentValidate = WriteValidation.validateContent(
      contentState.content,
    );
    final saleValidate = WriteValidation.validatePrice(saleState.purchasePrice);

    if (imageValidate != null) return imageValidate;
    if (titleValidate != null) return titleValidate;
    if (categoryValidate != null) return categoryValidate;
    if (contentValidate != null) return contentValidate;
    if (saleValidate != null) return saleValidate;

    return null;
  }

  Future<String?> submitPost() async {
    if (state.isLoading) return null;
    logger.i("[Submit] Clicked Submit Button (postId: $postId)");

    try {
      final contentState = ref.read(contentProvider);
      final saleState = ref.read(saleProvider);
      final category = ref.read(categoryProvider);
      final images = ref.read(imageProvider);

      if (category == null) {
        logger.w("[Submit] Category is null. Aborting.");
        return "카테고리를 선택해 주세요.";
      }

      state = const AsyncLoading();

      // 1. 이미지 처리 (새 파일 업로드 및 기존 URL 유지)
      logger.i("[Submit] Processing images (Count: ${images.length})");
      List<String> imageUrls = [];
      final List<String> newFiles =
          images.where((path) => !path.startsWith('http')).toList();
      final List<String> existingUrls =
          images.where((path) => path.startsWith('http')).toList();

      if (newFiles.isNotEmpty) {
        logger.d("[Submit] Uploading ${newFiles.length} new image files...");
        final uploadResult =
            await FirebaseStorageUploader().getDownloadUrls(newFiles);
        switch (uploadResult) {
          case Success(value: final urls):
            imageUrls = [...existingUrls, ...urls];
            logger.d("[Submit] Image upload success.");
          case Error(failure: final f):
            logger.e("[Submit] Image upload failed: ${f.message}");
            state = AsyncError(f, StackTrace.current);
            return "이미지 업로드 실패: ${f.message}";
        }
      } else {
        imageUrls = existingUrls;
      }

      // 2. 유저 정보 체크
      logger.d("[Submit] Checking user information...");
      final authorResult = ref.read(userProvider);
      final currentUser = authorResult.asData?.value;

      if (currentUser == null) {
        logger.e("[Submit] Current user data is null. Cannot proceed.");
        final failure = UnknownFailure("필요한 유저 정보를 불러올 수 없습니다. 다시 로그인해주세요.");
        state = AsyncError(failure, StackTrace.current);
        return failure.message;
      }

      // 3. Post 객체 생성 (수정 vs 신규)
      logger.i("[Submit] Preparing Post object...");
      Post submittingPost;
      if (postId != null) {
        logger.d("[Submit] Fetching existing post data for update...");
        final existingResult =
            await ref.read(postRepositoryProvider).getPostById(postId!);
        switch (existingResult) {
          case Success(value: final existingPost):
            submittingPost = existingPost.copyWith(
              title: contentState.title.trim(),
              content: contentState.content.trim(),
              category: category,
              purchasePrice: saleState.purchasePrice,
              salePrice: saleState.salePrice ?? 0,
              imageUrls: imageUrls,
            );
          case Error(failure: final f):
            logger.e("[Submit] Failed to fetch existing post: ${f.message}");
            state = AsyncError(f, StackTrace.current);
            return f.message;
        }
      } else {
        submittingPost = Post(
          postId: "",
          title: contentState.title.trim(),
          content: contentState.content.trim(),
          category: category,
          purchasePrice: saleState.purchasePrice,
          salePrice: saleState.salePrice ?? 0,
          likeCount: 0,
          chatCount: 0,
          createdAt: DateTime.now(),
          authorId: currentUser.uid,
          status: ProductStatus.available,
          imageUrls: imageUrls,
          viewCount: 0,
        );
      }

      // 4. Firestore 최종 저장
      logger.i("[Submit] Saving to Firestore...");
      final result = (postId != null)
          ? await ref.read(postRepositoryProvider).updatePost(submittingPost)
          : await ref.read(postRepositoryProvider).createPost(submittingPost);

      switch (result) {
        case Success():
          logger.i("[Submit] 🎉 Success! Post ${postId ?? 'created'} successfully.");
          state = const AsyncData(null);
          return "success";
        case Error(failure: final f):
          logger.e("[Submit] Firestore save failed: ${f.message}");
          state = AsyncError(f, StackTrace.current);
          return "게시글 저장 실패: ${f.message}";
      }
    } catch (e, stack) {
      logger.e("[Submit] ❌ CRITICAL ERROR: $e", error: e, stackTrace: stack); // 스택트레이스 포함 출력
      state = AsyncError(e, stack);
      return "데이터 저장 중 예상치 못한 오류가 발생했습니다: $e";
    }
  }
}

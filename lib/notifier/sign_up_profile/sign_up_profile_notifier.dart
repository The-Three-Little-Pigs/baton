import 'dart:io';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/core/di/repository/user_provider.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/service/notification_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_profile_notifier.g.dart';

class SignUpProfileState {
  final File? selectedImage;
  final bool isLoading;
  SignUpProfileState({this.selectedImage, this.isLoading = false});
  SignUpProfileState copyWith({File? selectedImage, bool? isLoading}) =>
      SignUpProfileState(
        selectedImage: selectedImage ?? this.selectedImage,
        isLoading: isLoading ?? this.isLoading,
      );
}

@riverpod
class SignUpProfile extends _$SignUpProfile {
  @override
  SignUpProfileState build() => SignUpProfileState();

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) state = state.copyWith(selectedImage: File(image.path));
  }

  // 🔥 불필요한 email, password 삭제하고 uid와 nickname만 남겼어요!
  Future<bool> completeSignUp({
    required String uid,
    required String nickname,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      String profileUrl = '';

      final userRepo = ref.read(userRepositoryProvider);

      // 1. 이미지가 선택되었다면 업로드 수행
      if (state.selectedImage != null) {
        final uploadResult = await userRepo.uploadProfileImage(
          uid,
          state.selectedImage!,
        );
        if (uploadResult is Success<String, Failure>) {
          profileUrl = uploadResult.value;
        }
      }

      // 2. 가입 시점에 기기 토큰 가져오기 (비어있지 않도록)
      String fcmToken = '';
      try {
        fcmToken = await NotificationService().getToken() ?? '';
      } catch (e) {}

      // 3. 넘겨받은 UID와 닉네임, 업로드된 이미지 URL로 'user' 엔티티 생성
      final newUser = User(
        uid: uid,
        nickname: nickname,
        profileUrl: profileUrl,
        score: 36.5,
        favorites: {},
        
        deletedAt: null,
        
      );

      // 4. Firestore 'user' 컬렉션에 저장
      final createResult = await userRepo.userCreate(newUser);

      if (createResult is Error) {
        return false;
      }

      // 5. [추가] 토큰 갱신 리스너 등록 (백그라운드 등에서 바뀔 경우 대비)
      NotificationService().updateFCMToken(uid, userRepository: userRepo);

      // 6. 유저 정보 상태 즉시 업데이트 (라우터 리다이렉션 트리거)
      ref.read(userProvider.notifier).updateState(newUser);

      return true;
    } catch (e) {
      print("가입 데이터 저장 에러: $e");
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

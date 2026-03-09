import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/notifier/user/providers/user_provider.dart'; // userRepositoryProvider가 있는 곳

// 1. 회원가입 단계의 상태 정의 (선택된 이미지와 로딩 여부)
class SignUpProfileState {
  final File? selectedImage;
  final bool isLoading;

  SignUpProfileState({this.selectedImage, this.isLoading = false});

  SignUpProfileState copyWith({File? selectedImage, bool? isLoading}) {
    return SignUpProfileState(
      selectedImage: selectedImage ?? this.selectedImage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// 2. 외부에서 접근할 프로바이더
final signUpProfileProvider =
    StateNotifierProvider<SignUpProfileNotifier, SignUpProfileState>((ref) {
      final repo = ref.watch(userRepositoryProvider);
      return SignUpProfileNotifier(repo);
    });

// 3. 비즈니스 로직을 담당하는 노티파이어
class SignUpProfileNotifier extends StateNotifier<SignUpProfileState> {
  final UserRepositoryImpl _repository;
  final ImagePicker _picker = ImagePicker();

  SignUpProfileNotifier(this._repository) : super(SignUpProfileState());

  // [기능 1] 갤러리에서 사진 가져오기
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // 용량 최적화
    );

    if (image != null) {
      state = state.copyWith(selectedImage: File(image.path));
    }
  }

  // [기능 2] 최종 가입 버튼 클릭 시 실행
  Future<bool> completeSignUp({
    required String uid,
    required String nickname,
  }) async {
    state = state.copyWith(isLoading: true);
    String? imageUrl;

    try {
      // 1. 이미지가 선택되었다면 Firebase Storage에 먼저 업로드
      if (state.selectedImage != null) {
        final uploadResult = await _repository.uploadProfileImage(
          uid,
          state.selectedImage!,
        );

        if (uploadResult is Success<String, dynamic>) {
          imageUrl = (uploadResult as Success<String, dynamic>).value;
        } else {
          // 업로드 실패 시 로직 처리 (필요시)
          state = state.copyWith(isLoading: false);
          return false;
        }
      }

      // 2. 업로드된 URL(있을 경우)과 함께 유저 정보 생성
      final newUser = User(
        uid: uid,
        nickname: nickname,
        profileImageUrl: imageUrl,
        profileUrl: imageUrl ?? '',
        score: 36.5,
        fcmToken: '',
      );

      // 3. Firestore에 최종 저장
      final result = await _repository.userCreate(newUser);
      state = state.copyWith(isLoading: false);

      return result is Success;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}

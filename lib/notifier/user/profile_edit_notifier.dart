import 'dart:io';
import 'package:baton/core/di/repository/user_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_notifier.g.dart';

class ProfileEditState {
  final String nickname;
  final File? selectedImage;
  final bool? isNicknameDuplicate;
  final bool isLoading;
  final String? errorMessage;

  ProfileEditState({
    required this.nickname,
    this.selectedImage,
    this.isNicknameDuplicate,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileEditState copyWith({
    String? nickname,
    File? selectedImage,
    bool? isNicknameDuplicate,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileEditState(
      nickname: nickname ?? this.nickname,
      selectedImage: selectedImage ?? this.selectedImage,
      isNicknameDuplicate: isNicknameDuplicate ?? this.isNicknameDuplicate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class ProfileEditNotifier extends _$ProfileEditNotifier {
  @override
  ProfileEditState build() {
    final user = ref.watch(userProvider).value;
    return ProfileEditState(
      nickname: user?.nickname ?? '',
    );
  }

  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname, isNicknameDuplicate: null);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = state.copyWith(selectedImage: File(image.path));
    }
  }

  Future<void> checkDuplicate() async {
    if (state.nickname.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: '닉네임을 입력해 주세요.',
        isNicknameDuplicate: true,
      );
      return;
    }
    
    // 현재 내 닉네임과 동일한 경우 중복 아님으로 처리
    final currentUser = ref.read(userProvider).value;
    if (state.nickname == currentUser?.nickname) {
      state = state.copyWith(
        isNicknameDuplicate: false,
        errorMessage: '현재 사용 중인 닉네임입니다.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await ref.read(userRepositoryProvider).checkNicknameDuplicate(state.nickname);
    
    state = switch (result) {
      Success(:final value) => state.copyWith(
          isNicknameDuplicate: value,
          isLoading: false,
          errorMessage: value ? '이미 사용 중인 닉네임입니다.' : '사용 가능한 닉네임입니다.',
        ),
      Error(:final failure) => state.copyWith(
          errorMessage: failure.message,
          isLoading: false,
          isNicknameDuplicate: true, // 에러 발생 시 진행 방지
        ),
    };
  }

  Future<void> saveProfile({
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    final user = ref.read(userProvider).value;
    if (user == null) {
      onError('사용자 정보를 찾을 수 없습니다.');
      return;
    }

    state = state.copyWith(isLoading: true);

    String? profileUrl = user.profileUrl;

    // 1. 이미지 업로드 (변경된 경우)
    if (state.selectedImage != null) {
      final uploadResult = await ref.read(userRepositoryProvider).uploadProfileImage(
        user.uid,
        state.selectedImage!,
      );
      
      switch (uploadResult) {
        case Success(:final value):
          profileUrl = value;
        case Error(:final failure):
          state = state.copyWith(isLoading: false, errorMessage: failure.message);
          onError(failure.message);
          return;
      }
    }

    // 2. 유저 정보 업데이트
    final updatedUser = user.copyWith(
      nickname: state.nickname,
      profileUrl: profileUrl,
    );

    final updateResult = await ref.read(userRepositoryProvider).updateUserData(updatedUser);

    state = switch (updateResult) {
      Success() => state.copyWith(isLoading: false),
      Error(:final failure) => state.copyWith(errorMessage: failure.message, isLoading: false),
    };

    if (updateResult is Success) {
      onSuccess();
    } else if (updateResult is Error<void, Failure>) {
      onError(updateResult.failure.message);
    }
  }
}

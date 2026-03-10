import 'dart:io';
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';

import 'package:image_picker/image_picker.dart';
import 'package:baton/models/entities/user.dart' as entity;

import 'package:baton/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 1. 💡 이 파일의 이름이 'sign_up_profile_notifier.dart'인지 꼭 확인!
part 'sign_up_profile_notifier.g.dart';

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

// 2. 💡 클래스 이름을 명확하게 'SignUpProfile'로 고칩니다.
@riverpod
class SignUpProfile extends _$SignUpProfile {
  @override
  SignUpProfileState build() => SignUpProfileState();

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) state = state.copyWith(selectedImage: File(image.path));
  }

  Future<bool> completeSignUp({
    required String uid,
    required String nickname,
  }) async {
    state = state.copyWith(isLoading: true);
    final userRepo = ref.read(userRepositoryProvider);
    try {
      final newUser = entity.User(
        uid: uid,
        nickname: nickname,
        profileUrl: '',
        score: 36.5,
        fcmToken: '',
      );
      final result = await userRepo.userCreate(newUser);
      state = state.copyWith(isLoading: false);
      return result is Success;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}

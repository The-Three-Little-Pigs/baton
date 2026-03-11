import 'dart:io';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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
      // 1. 이미 로그인된 상태이므로 계정 생성 로직은 지우고
      //    넘겨받은 UID와 닉네임으로 'user' 엔티티만 만듭니다.
      final newUser = User(
        uid: uid,
        nickname: nickname,
        profileUrl: '', // 이미지 업로드 로직은 나중에!
        score: 36.5,
        fcmToken: '',
        favorites: [],
        blockedUsers: [],
      );

      // 2. Firestore 'user' 컬렉션에 저장 (repository에서 'user'로 되어있는지 확인!)
      await ref.read(userRepositoryProvider).userCreate(newUser);

      // 3. 유저 정보 상태 즉시 업데이트 (라우터 리다이렉션 트리거)
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

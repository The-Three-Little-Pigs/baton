import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baton/views/sign_up_profile_page/viewmodel/sign_up_profile_notifier.dart';
import 'package:go_router/go_router.dart';

// 닉네임을 저장하고 있는 프로바이더를 임포트해야 합니다.
// 예: import 'package:baton/presentation/sign_up/provider/nickname_provider.dart';

class SignUpProfilePage extends ConsumerWidget {
  // GoRouter 에러 방지를 위해 생성자에서 인자를 제거했습니다.
  const SignUpProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final nickname = ref.watch(userProvider).value?.nickname ?? '';
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final signUpState = ref.watch(signUpProfileProvider);
    final signUpNotifier = ref.read(signUpProfileProvider.notifier);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 72),
          // --- 상단 헤더 영역 ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 8, color: colors.secondary),
                    const SizedBox(width: 4),
                    Icon(Icons.circle, size: 8, color: colors.primary),
                  ],
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final success = await signUpNotifier.completeSignUp(
                        uid: uid,
                        nickname: nickname,
                      );

                      if (success && context.mounted) {
                        context.go('/home');
                      }
                    },
                    child: Text(
                      "건너뛰기",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: appColors?.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- 안내 문구 영역 ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 29.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 77),
                Row(
                  children: [
                    Container(width: 2, height: 20, color: colors.onSurface),
                    const SizedBox(width: 8),
                    Text(
                      "프로필 이미지를 등록해주세요.",
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "이미지는 가입 후에도 언제든 변경할 수 있어요",
                  style: TextStyle(
                    color: appColors?.textTertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 34),

          // --- 프로필 이미지 설정 영역 (Image Picker 연결됨) ---
          Center(
            child: GestureDetector(
              onTap: () => signUpNotifier.pickImage(), // 클릭 시 사진 선택 기능 실행
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: colors.surfaceContainerHighest,
                    // 선택된 사진이 있으면 보여주고, 없으면 기본 아이콘 표시
                    backgroundImage: signUpState.selectedImage != null
                        ? FileImage(signUpState.selectedImage!)
                        : null,
                    child: signUpState.selectedImage == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                            color: appColors?.textTertiary,
                          )
                        : null,
                  ),
                  // 카메라 아이콘 오버레이
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colors.primary,
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: colors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Expanded(child: SizedBox()),

          // --- 하단 가입 완료 버튼 ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 21.0),
            child: Center(
              child: GestureDetector(
                onTap: signUpState.isLoading
                    ? null
                    : () async {
                        final success = await signUpNotifier.completeSignUp(
                          uid: uid,
                          nickname: nickname,
                        );
                        if (success && context.mounted) {
                          context.go('/home');
                        }
                      },
                child: Container(
                  width: 350,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: signUpState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "가입 완료",
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/sign_up_profile/sign_up_profile_notifier.dart';
import 'package:baton/views/sign_up/widgets/sign_up_header.dart';
import 'package:baton/views/widgets/complete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpProfilePage extends ConsumerWidget {
  final String nickname; // 1페이지에서 넘어온 닉네임

  const SignUpProfilePage({super.key, required this.nickname});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final signUpState = ref.watch(signUpProfileProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 34),
            // --- 상단 헤더 ---
            Stack(
              children: [
                const SignUpHeader(step: 2),
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap:
                          (signUpState.isLoading ||
                              signUpState.selectedImage != null)
                          ? null
                          : () async {
                              await ref
                                  .read(signUpProfileProvider.notifier)
                                  .completeSignUp(uid: uid, nickname: nickname);
                            },
                      child: Text(
                        "건너뛰기",
                        style: TextStyle(
                          color:
                              (signUpState.isLoading ||
                                  signUpState.selectedImage != null)
                              ? AppColors.textDisabled
                              : AppColors.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 77),

            // --- 안내 문구 ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "사진은 나중에 마이페이지에서도 바꿀 수 있어요.",
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 59),

            // --- 🔥 [핵심] 프로필 이미지 선택 영역 (원상복구) ---
            Center(
              child: GestureDetector(
                onTap: () =>
                    ref.read(signUpProfileProvider.notifier).pickImage(),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade100,
                      // 선택한 이미지가 있으면 보여주고, 없으면 기본 아이콘
                      backgroundImage: signUpState.selectedImage != null
                          ? FileImage(signUpState.selectedImage!)
                          : null,
                      child: signUpState.selectedImage == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey.shade400,
                            )
                          : null,
                    ),
                    // 카메라 아이콘 버튼
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colors.primary,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // --- 가입 완료 버튼 ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 21),
              child: CompleteButton(
                label: "가입 완료",
                isLoading: signUpState.isLoading,
                onPressed: () async {
                  await ref
                      .read(signUpProfileProvider.notifier)
                      .completeSignUp(uid: uid, nickname: nickname);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

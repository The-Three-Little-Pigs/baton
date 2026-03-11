import 'package:baton/notifier/sign_up_profile/sign_up_profile_notifier.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 72),
          // --- 상단 헤더 ---
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
                    ),
                  ),
                ),
                // 파란색 점 디자인
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: colors.secondary.withOpacity(0.3),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.circle, size: 8, color: colors.primary),
                  ],
                ),
                Expanded(
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
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color:
                            (signUpState.isLoading ||
                                signUpState.selectedImage != null)
                            ? Colors.grey[300]
                            : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),

          // --- 🔥 [핵심] 프로필 이미지 선택 영역 (원상복구) ---
          Center(
            child: GestureDetector(
              onTap: () => ref.read(signUpProfileProvider.notifier).pickImage(),
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
            child: GestureDetector(
              onTap:
                  (signUpState.isLoading || signUpState.selectedImage == null)
                  ? null
                  : () async {
                      await ref
                          .read(signUpProfileProvider.notifier)
                          .completeSignUp(uid: uid, nickname: nickname);
                    },
              child: Container(
                width: double.infinity,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: (signUpState.selectedImage != null)
                      ? colors.primary
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: signUpState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "가입 완료",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

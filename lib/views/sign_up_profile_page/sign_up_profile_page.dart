import 'package:baton/core/theme/app_color_extension.dart';
import 'package:flutter/material.dart';

class SignUpProfilePage extends StatelessWidget {
  const SignUpProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 72),
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
                  child: Text(
                    "건너뛰기",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: appColors?.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 안내 문구 영역
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
                  "이미지는 가입 후에 도 언제든 변경할 수 있어요",
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
          // 프로필 이미지 영역
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: colors.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: appColors?.textTertiary,
                  ),
                ),
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
          const Expanded(child: SizedBox()),

          // 하단 가입 완료 버튼
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 21.0),
            child: Center(
              child: Container(
                width: 350,
                height: 54,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "가입 완료",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
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

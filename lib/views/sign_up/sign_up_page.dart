import 'package:baton/core/theme/app_color_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    Icon(Icons.circle, size: 8, color: colors.primary),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: appColors?.textTertiary ?? Colors.grey,
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          // 1. 닉네임 안내 영역
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
                      "닉네임을 설정해주세요.",
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
                  "닉네임은 가입후에도 언제든 변경할 수 있어요.",
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
          const SizedBox(height: 59),
          // 2. 텍스트 입력 영역
          Padding(
            padding: const EdgeInsets.only(left: 37.0, right: 32.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.outline, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "입력해주세요.",
                        hintStyle: TextStyle(
                          color: appColors?.textHint,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const Text("0/8"),
                  const SizedBox(width: 8),
                  Container(
                    width: 68,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: appColors?.textDisabled,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "중복 확인",
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Expanded(child: SizedBox()),

          // 3. 하단 버튼 영역
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 21.0,
            ),
            child: GestureDetector(
              onTap: () {
                context.go('/signUpProfile');
              },
              child: Container(
                width: double.infinity,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "다음",
                  style: TextStyle(
                    color: colors.onPrimary,
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

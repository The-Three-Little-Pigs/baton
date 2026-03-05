import 'package:baton/core/theme/app_color_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FocusNode _nicknameFocusNode = FocusNode();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 글자 수 제한 및 실시간 업데이트를 위해 리스너 등록
    _nicknameController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nicknameFocusNode.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 72),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
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
                        color: Theme.of(context).colorScheme.outline,
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
                    color: const Color(0xFF8894A3),
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
            child: GestureDetector(
              onTap: () {
                _nicknameFocusNode.requestFocus();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nicknameController,
                        focusNode: _nicknameFocusNode,
                        maxLength: 8,
                        decoration: const InputDecoration(
                          hintText: "입력해주세요.",
                          counterText: "", // 기본 counter 숨김
                          hintStyle: TextStyle(
                            color: Colors.grey,
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
                    Text("${_nicknameController.text.length}/8"),
                    const SizedBox(width: 8),
                    Container(
                      width: 68,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "중복 확인",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
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
          ),

          const Expanded(child: SizedBox()),

          // 3. 하단 버튼 영역
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 21.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (_nicknameController.text.length >= 2) {
                    context.go('/signUpProfile');
                  }
                },
                child: Container(
                  width: 350,
                  height: 54,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _nicknameController.text.length >= 2
                        ? Colors.blueAccent
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "다음",
                    style: TextStyle(
                      color: Colors.white,
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

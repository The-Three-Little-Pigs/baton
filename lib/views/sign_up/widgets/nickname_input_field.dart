// lib/views/sign_up/widgets/nickname_input_field.dart
import 'package:flutter/material.dart';

class NicknameInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onCheckDuplicate;
  final ValueChanged<String> onChanged;
  final bool isLoading;
  final bool isDuplicateChecked;
  final bool isAvailable;
  final String? errorMessage;

  const NicknameInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCheckDuplicate,
    required this.onChanged, // 추가
    required this.isLoading,
    this.isDuplicateChecked = false,
    this.isAvailable = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 닉네임 안내 영역 (기존 유지)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 77),
              Row(
                children: [
                  Container(
                    width: 2,
                    height: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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
              const Text(
                "닉네임은 가입후에도 언제든 변경할 수 있어요.",
                style: TextStyle(
                  color: Color(0xFF8894A3),
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
            onTap: () => focusNode.requestFocus(),
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
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged, // Notifier와 연결
                      maxLength: 8,
                      decoration: const InputDecoration(
                        hintText: "입력해주세요.",
                        counterText: "",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Text("${controller.text.length}/8"),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: controller.text.length >= 2 && !isLoading
                        ? onCheckDuplicate
                        : null,
                    child: Container(
                      width: 68,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.text.length >= 2
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "중복 확인",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

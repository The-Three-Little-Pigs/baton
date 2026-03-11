import 'package:baton/notifier/sign_up/sign_up_notifier.dart';
import 'package:baton/views/sign_up/widgets/nickname_input_field.dart';
import 'package:baton/views/sign_up/widgets/sign_up_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final FocusNode _nicknameFocusNode = FocusNode();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() {
      if (mounted) {
        ref
            .read(signUpProvider.notifier)
            .updateNickname(_nicknameController.text);
      }
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
    final signUpState = ref.watch(signUpProvider);
    final bool canProceed = signUpState.canProceedNext;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 72),
          const SignUpHeader(),

          NicknameInputField(
            controller: _nicknameController,
            focusNode: _nicknameFocusNode,
            isLoading: signUpState.isLoading,
            isDuplicateChecked: signUpState.isDuplicateChecked,
            isAvailable: signUpState.isAvailable,

            // 1. 실시간 입력 감지를 위해 onChanged 추가
            onChanged: (value) {
              ref.read(signUpProvider.notifier).updateNickname(value);
            },
            // 2. 중복 확인 버튼 클릭 시 로직
            onCheckDuplicate: () {
              ref.read(signUpProvider.notifier).checkDuplicate();
            },
          ),

          const Expanded(child: SizedBox()),
          if (signUpState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      // 사용 가능(isAvailable)할 때만 체크, 나머지는 느낌표 아이콘
                      signUpState.isAvailable
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      size: 16,
                      color: const Color(0xFF4897FF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      signUpState.errorMessage!, // Notifier에서 보낸 문구 그대로 출력
                      style: const TextStyle(
                        color: Color(0xFF4897FF),
                        fontFamily: 'Pretendard',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 21.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (canProceed) {
                    context.go(
                      '/signUpProfile',
                      extra: _nicknameController.text,
                    );
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
                    color: canProceed ? Colors.blueAccent : Colors.grey[300],
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

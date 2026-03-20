import 'package:baton/notifier/sign_up/sign_up_notifier.dart';
import 'package:baton/views/sign_up/widgets/nickname_input_field.dart';
import 'package:baton/views/sign_up/widgets/sign_up_header.dart';
import 'package:baton/views/sign_up/widgets/speech_bubble.dart';
import 'package:baton/views/widgets/complete_button.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 34),
            const SignUpHeader(),
            NicknameInputField(
              controller: _nicknameController,
              focusNode: _nicknameFocusNode,
              isLoading: signUpState.isLoading,
              isDuplicateChecked: signUpState.isDuplicateChecked,
              isAvailable: signUpState.isAvailable,
              errorMessage: signUpState.errorMessage,
              onChanged: (value) {
                ref.read(signUpProvider.notifier).updateNickname(value);
              },
              onCheckDuplicate: () {
                ref.read(signUpProvider.notifier).checkDuplicate();
              },
            ),
            const Spacer(),
            // 다음 버튼 영역
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 21.0,
              ),
              child: Column(
                children: [
                  if (signUpState.guideMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SpeechBubble(message: signUpState.guideMessage!),
                    ),
                  CompleteButton(
                    label: "다음",
                    onPressed: canProceed
                        ? () {
                            context.pushNamed(
                              'signUpProfile',
                              extra: _nicknameController.text,
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

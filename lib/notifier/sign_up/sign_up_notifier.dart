import 'package:baton/core/di/repository/user_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_notifier.g.dart';

class SignUpState {
  final String nickname;
  final bool isDuplicateChecked;
  final bool isAvailable;
  final bool isLoading;
  final String? errorMessage;
  final String? guideMessage;

  const SignUpState({
    this.nickname = '',
    this.isDuplicateChecked = false,
    this.isAvailable = false,
    this.isLoading = false,
    this.errorMessage,
    this.guideMessage = "닉네임을 입력해주세요.",
  });

  bool get isValidLength => nickname.length >= 2 && nickname.length <= 8;
  bool get canProceedNext => isValidLength && isDuplicateChecked && isAvailable;

  SignUpState copyWith({
    String? nickname,
    bool? isDuplicateChecked,
    bool? isAvailable,
    bool? isLoading,
    String? errorMessage,
    String? guideMessage,
    bool clearError = false,
    bool clearGuide = false,
  }) {
    return SignUpState(
      nickname: nickname ?? this.nickname,
      isDuplicateChecked: isDuplicateChecked ?? this.isDuplicateChecked,
      isAvailable: isAvailable ?? this.isAvailable,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      guideMessage: clearGuide ? null : (guideMessage ?? this.guideMessage),
    );
  }
}

@riverpod
class SignUpNotifier extends _$SignUpNotifier {
  @override
  SignUpState build() {
    return const SignUpState();
  }

  void updateNickname(String nickname) {
    if (state.nickname == nickname) return;

    String? errorMessage;
    String? guideMessage;

    if (nickname.isEmpty) {
      guideMessage = "닉네임을 입력해주세요.";
    } else if (nickname.length == 1) {
      guideMessage = "2자 이상 입력해주세요.";
    } else if (nickname.length < 8) {
      guideMessage = "중복 확인을 진행해 주세요.";
    } else if (nickname.length >= 8) {
      guideMessage = "8글자까지 입력 가능합니다.";
    }

    // 닉네임이 변경되면 중복 확인 상태 초기화
    state = state.copyWith(
      nickname: nickname,
      isDuplicateChecked: false,
      isAvailable: false,
      errorMessage: errorMessage,
      guideMessage: guideMessage,
      clearError: true,
      clearGuide:
          nickname.length >= 2 && nickname.length < 8 && false, // Logic below
    );

    // 중복 확인이 필요 없는 상태(성공)면 가이드를 비울 수도 있으나,
    // 여기서는 기본적으로 "중복 확인을 진행해 주세요"를 유지
  }

  Future<void> checkDuplicate() async {
    if (state.nickname.length < 2) {
      state = state.copyWith(guideMessage: "2자 이상 입력해주세요.");
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final repository = ref.read(userRepositoryProvider);
    final result = await repository.checkNicknameDuplicate(state.nickname);

    switch (result) {
      case Success(value: final isDuplicated):
        state = state.copyWith(
          isLoading: false,
          isDuplicateChecked: true,
          isAvailable: !isDuplicated,
          errorMessage: isDuplicated ? "이미 사용 중인 닉네임입니다." : "사용 가능한 닉네임입니다.",
          guideMessage: isDuplicated ? "중복 확인을 진행해 주세요." : null,
          clearGuide: !isDuplicated, // 사용 가능하면 가이드 제거
        );
      case Error(failure: _):
        state = state.copyWith(
          isLoading: false,
          errorMessage: "중복 확인 중 오류가 발생했습니다.",
        );
    }
  }
}

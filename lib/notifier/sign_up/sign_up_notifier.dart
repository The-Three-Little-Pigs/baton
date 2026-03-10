// lib/notifier/sign_up/sign_up_notifier.dart
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

  const SignUpState({
    this.nickname = '',
    this.isDuplicateChecked = false,
    this.isAvailable = false,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isValidLength => nickname.length >= 2 && nickname.length <= 8;
  bool get canProceedNext => isValidLength && isDuplicateChecked && isAvailable;

  SignUpState copyWith({
    String? nickname,
    bool? isDuplicateChecked,
    bool? isAvailable,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignUpState(
      nickname: nickname ?? this.nickname,
      isDuplicateChecked: isDuplicateChecked ?? this.isDuplicateChecked,
      isAvailable: isAvailable ?? this.isAvailable,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
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

    // 1. 실시간 글자 수 체크 로직 추가
    if (nickname.length == 1) {
      errorMessage = "2자 이상 입력해주세요";
    } else if (nickname.length >= 8) {
      errorMessage = "8글자까지 입력 가능합니다.";
    }

    // 닉네임이 변경되면 중복 확인 상태 초기화 및 메시지 업데이트
    state = state.copyWith(
      nickname: nickname,
      isDuplicateChecked: false,
      isAvailable: false,
      errorMessage: errorMessage, // 계산된 메시지 적용
      clearError: errorMessage == null, // 에러가 없으면 기존 에러 삭제
    );
  }

  Future<void> checkDuplicate() async {
    // 2. 버튼 클릭 시(중복 확인 시) 최종 유효성 검사
    if (state.nickname.length < 2) {
      state = state.copyWith(errorMessage: "2자 이상 입력해주세요");
      return;
    }

    // 로딩 상태 시작
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
        );
      case Error(failure: _):
        state = state.copyWith(
          isLoading: false,
          errorMessage: "중복 확인 중 오류가 발생했습니다.",
        );
    }
  }
}

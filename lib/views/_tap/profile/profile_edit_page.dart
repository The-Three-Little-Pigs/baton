import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';
import 'package:baton/notifier/user/profile_edit_notifier.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late final TextEditingController _nicknameController;
  late final FocusNode _nicknameFocusNode;

  @override
  void initState() {
    super.initState();
    // 초기 닉네임은 build 단계에서 userProvider.when을 통해 설정하거나 
    // ref.listen을 통해 설정합니다.
    _nicknameController = TextEditingController();
    _nicknameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileEditProvider);
    final notifier = ref.read(profileEditProvider.notifier);
    final userAsync = ref.watch(userProvider);

    // 닉네임 초기화 로직 (한 번만 실행되도록 리스너 활용)
    ref.listen(userProvider, (previous, next) {
      if (next is AsyncData && next.value != null && _nicknameController.text.isEmpty) {
        _nicknameController.text = next.value!.nickname;
      }
    });

    return userAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(backgroundColor: AppColors.white, elevation: 0),
        body: Center(child: Text('사용자 정보를 불러올 수 없습니다: $error')),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            backgroundColor: AppColors.white,
            body: Center(child: Text('사용자 정보가 존재하지 않습니다.')),
          );
        }

        // 초기 진입 시 데이터가 이미 있을 경우를 대비하여 컨트롤러 초기화
        if (_nicknameController.text.isEmpty && user.nickname.isNotEmpty) {
          Future.microtask(() => _nicknameController.text = user.nickname);
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              '프로필 수정',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        // 프로필 이미지 영역
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: notifier.pickImage,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    // 배경색을 투명하게 하거나 SVG와 동일하게 유지
                                  ),
                                  child: ClipOval(
                  child: state.selectedImage != null
                      ? Image.file(state.selectedImage!, fit: BoxFit.cover)
                      : _buildProfileImage(user.profileUrl),
                ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: notifier.pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF67A1FF), // 바톤 포인트 블루
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2), // 화이트 테두리로 분리감 강화
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // 닉네임 입력 영역
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: state.errorMessage != null && (state.isNicknameDuplicate == true || state.errorMessage!.contains('실패'))
                                        ? AppColors.error
                                        : (state.isNicknameDuplicate == false
                                              ? AppColors.primary
                                              : const Color(0xFFE5E5E5)),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _nicknameController,
                                      focusNode: _nicknameFocusNode,
                                      maxLength: 8,
                                      onChanged: (val) {
                                        notifier.updateNickname(val);
                                        setState(() {});
                                      },
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: '닉네임을 입력해주세요',
                                        hintStyle: TextStyle(color: AppColors.textHint, fontSize: 16),
                                        contentPadding: EdgeInsets.only(top: 20, bottom: 6),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${_nicknameController.text.length}/8',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: (_nicknameController.text.length >= 2 && !state.isLoading) ? notifier.checkDuplicate : null,
                                          child: Container(
                                            width: 68,
                                            height: 36,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE7EBF1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: state.isLoading
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                                                  )
                                                : const Text(
                                                    '중복 확인',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.textPrimary,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      state.errorMessage!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: state.isNicknameDuplicate == false ? AppColors.primary : AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        state.isNicknameDuplicate == false ? Icons.check : Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 하단 완료 버튼
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (state.isLoading || (state.isNicknameDuplicate == true))
                          ? null
                          : () {
                              if (state.isNicknameDuplicate == null && _nicknameController.text != user.nickname) {
                                  AppSnackBar.show(context, '닉네임 중복 확인을 먼저 해주세요.');
                                  return;
                              }
    
                              notifier.saveProfile(
                                onSuccess: () {
                                  AppSnackBar.show(context, '프로필이 수정되었습니다.');
                                  context.pop();
                                },
                                onError: (msg) {
                                  AppSnackBar.show(context, '수정 실패: $msg');
                                },
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (state.isNicknameDuplicate == false || (state.isNicknameDuplicate == null && _nicknameController.text == user.nickname)) 
                            ? AppColors.primary 
                            : const Color(0xFFBDC8D6),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: const Color(0xFFE5E5E5),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                            )
                          : const Text(
                              '완료',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  /// 프로필 이미지를 원형에 꽉 채워서 아름답게 빌드합니다.
  Widget _buildProfileImage(String? url) {
    // 1. 기본 아이콘 (Placeholder)
    // SvgPicture가 전체 원(120x120)을 꽉 채우도록 핵심 수정
    final placeholder = SvgPicture.asset(
      'assets/images/profile_image_60.svg',
      fit: BoxFit.cover, 
      width: 120,
      height: 120,
    );

    if (url == null || url.isEmpty || !url.startsWith('http')) {
      return placeholder;
    }

    // 2. 네트워크 이미지
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder; // 로딩 중에도 플레이스홀더 표시
      },
      errorBuilder: (context, error, stackTrace) {
        return placeholder; // 에러 시 플레이스홀더 표시
      },
    );
  }
}

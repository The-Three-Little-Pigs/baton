// lib/views/chat_detail/widgets/chat_input_field.dart
import 'dart:io';

import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/chat_detail/viewmodel/chat_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String roomId; // 부모로부터 방 ID를 받습니다.

  const ChatInputField({super.key, required this.roomId});

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  // 텍스트를 감지하고 조작하기 위한 컨트롤러
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false; // 텍스트가 있는지 여부를 저장하는 상태 변수

  // 📸 이미지 피커 및 선택된 이미지 상태 관리
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage; // 🌟 1. 유저가 선택한 이미지를 임시로 담아두는 변수
  bool _isUploading = false; // 업로드 중 로딩 표시용

  @override
  void initState() {
    super.initState();
    // 텍스트 필드의 변화를 실시간으로 감지
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 🌟 2. 갤러리를 띄워서 사진만 선택하고 화면(UI)에 미리보기로 띄움 (서버 전송 X)
  Future<void> _pickImageOnly() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // 용량 최적화
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile; // 상태 업데이트 -> UI에 미리보기 박스가 나타남
      });
    }
  }

  // 🌟 3. 파란색 전송(Send) 버튼을 눌렀을 때 실행되는 최종 전송 로직
  Future<void> _sendMessage() async {
    final text = _controller.text;

    // 텍스트도 없고 이미지도 안 골랐으면 무시
    if (text.trim().isEmpty && _selectedImage == null) return;

    final myUserId = ref.read(userProvider).value?.uid;
    if (myUserId == null) return;

    final chatroomState = ref.read(chatRoomStreamProvider(widget.roomId));
    final hasRoom = chatroomState.value != null;

    // 타겟 유저 결정 (Firestore 방이 있으면 참가자 목록에서, 없으면 roomId 파싱)
    String targetUserId = '';
    if (hasRoom) {
      targetUserId = chatroomState.value!.participants.firstWhere(
        (id) => id != myUserId,
        orElse: () => '',
      );
    } else {
      final parts = widget.roomId.split('_');
      if (parts.length >= 2) {
        targetUserId = parts[0] == myUserId ? parts[1] : parts[0];
      }
    }

    if (targetUserId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('에러: 대화 상대를 찾을 수 없습니다.')));
      print(
        '디버그: widget.roomId=${widget.roomId}, myUserId=$myUserId, targetUserId가 빈칸입니다. 파싱 실패.',
      );
      return;
    }

    // ==========================================
    // [A] 이미지가 선택되어 있다면 이미지부터 앱 서버에 업로드 후 전송
    // ==========================================
    if (_selectedImage != null) {
      setState(() {
        _isUploading = true; // 로딩 스피너 작동
      });

      try {
        final errorMsg = await ref
            .read(chatDetailProvider(widget.roomId).notifier)
            .sendImageMessage(
              widget.roomId,
              targetUserId,
              File(_selectedImage!.path),
              hasRoom,
            );

        if (errorMsg != null) {
          throw Exception(errorMsg);
        }

        // 이미지 전송 성공 시 화면의 미리보기 박스 지우기
        setState(() {
          _selectedImage = null;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('이미지 전송에 실패했습니다.')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false; // 로딩 스피너 종료
          });
        }
      }
    }

    // ==========================================
    // [B] 텍스트가 있다면 텍스트 전송
    // ==========================================
    if (text.trim().isNotEmpty) {
      _controller.clear(); // 입력창 비우기
      _focusNode.requestFocus(); // 타자 치던 키보드가 내려가지 않게 계속 유지

      try {
        final errorMsg = await ref
            .read(chatDetailProvider(widget.roomId).notifier)
            .sendTextMessage(widget.roomId, targetUserId, text, hasRoom);

        if (errorMsg != null) {
          throw Exception(errorMsg);
        }
      } catch (e, st) {
        print('메시지 전송 에러: $e');
        print(st);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('메시지 전송 실패: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 4. '입력한 텍스트'가 있거나 '선택한 사진'이 1개라도 있으면 전송 버튼을 파란색으로 활성화
    final canSend = _hasText || _selectedImage != null;

    return Column(
      mainAxisSize: MainAxisSize.min, // 키보드 위쪽 공간만큼만 차지
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        // 🌟 5. 선택된 이미지가 있을 때 입력창 위에 보여줄 미리보기 컨테이너
        if (_selectedImage != null)
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 8),
            height: 60,
            width: 60,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 사진 썸네일
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_selectedImage!.path),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                // 🌟 업로드 중일 때는 사진 위에 반투명 검은 배경과 로딩 스피너 띄우기
                if (_isUploading)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                // 사진 취소(X) 버튼 (업로드 중이 아닐 때만 보임)
                if (!_isUploading)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImage = null; // 취소하면 변수 초기화로 컨테이너가 닫힘
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // 기존 텍스트 입력창 (Row)
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary),
            borderRadius: BorderRadius.circular(22), // 둥근 입력창
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end, // 여러 줄일 때 하단 맞춤
            children: [
              // 갤러리 띄우기 버튼
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: IconButton(
                  // 업로드 중이 아닐 때만 갤러리 열기 허용!
                  onPressed: _isUploading ? null : _pickImageOnly,
                  icon: Icon(
                    Icons.image,
                    size: 24,
                    color: Colors.grey.shade500,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              // 텍스트 치는 영역
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 7,
                  minLines: 1,
                  // 무제한 줄바꿈 가능
                  decoration: const InputDecoration(
                    hintText: '메세지 입력',
                    hintStyle: TextStyle(color: AppColors.secondary),
                    contentPadding: EdgeInsets.symmetric(vertical: 12), // 패딩 조절
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              // 🌟 전송 버튼
              Padding(
                padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
                child: IconButton(
                  // 텍스트나 사진이 1개라도 있고, 현재 업로드 중이 아닐 때만 전송 가동
                  onPressed: (canSend && !_isUploading) ? _sendMessage : null,
                  icon: Icon(
                    Icons.send,
                    size: 24,
                    color: (canSend && !_isUploading)
                        ? AppColors.primary
                        : Colors.grey.shade500, // 활성화 시 파란색
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// lib/views/chat_detail/widgets/chat_input_field.dart
import 'dart:io';

import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/test/test_auth_notifier.dart';
import 'package:baton/views/chat_detail/viewmodel.dart/chat_detail_viewmodel.dart';
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
  bool _hasText = false; // 👈 1. 텍스트가 있는지 여부를 저장하는 상태 변수
  // 📸 이미지 피커 인스턴스
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false; // 업로드 중 로딩 표시용

  @override
  void initState() {
    super.initState();
    // 👈 2. 컨트롤러에 리스너를 달아서 텍스트가 바뀔 때마다 상태를 업데이트합니다.
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // 메모리 누수 방지
    _focusNode.dispose();
    super.dispose();
  }

  // 메시지 전송 핵심 로직
  Future<void> _sendMessage() async {
    final text = _controller.text;

    // 빈 문자는 무시
    if (text.trim().isEmpty) return;

    // 1. 현재 접속자 확인
    final myUserId = ref.read(testAuthNotifierProvider);
    if (myUserId == null) return; // 방어 로직

    // 2. 상대방 유저 ID 계산 (마찬가지로 임시 로직)
    final targetUserId = myUserId == 'BUYER_999' ? 'SELLER_123' : 'BUYER_999';

    // 3. 현재 텍스트 입력창 비우기
    _controller.clear();

    _focusNode.requestFocus();

    // 4. 이 채팅방이 파이어스토어에 이미(hasRoom) 존재하는지 확인
    final chatroomState = ref.read(chatRoomStreamProvider(widget.roomId));
    final hasRoom = chatroomState.value != null;

    try {
      // 5. 뷰모델(chatActionProvider)을 통해 실제 파이어스토어에 전송
      await ref
          .read(chatActionProvider)
          .sendMessage(widget.roomId, myUserId, targetUserId, text, hasRoom);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('메시지 전송 실패')));
      }
    }
  }

  Future<void> _pickAndSendImage() async {
    try {
      // 1. 갤러리 띄우기 (XFile 반환)
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // 용량 최적화 (70% 수준으로 압축)
      );
      if (pickedFile == null) return; // 유저가 선택 취소함
      // 유저 식별 코드 (임시)
      final myUserId = ref.read(testAuthNotifierProvider);
      if (myUserId == null) return;
      final targetUserId = myUserId == 'BUYER_999' ? 'SELLER_123' : 'BUYER_999';
      final chatroomState = ref.read(chatRoomStreamProvider(widget.roomId));
      final hasRoom = chatroomState.value != null;
      // 2. 업로드 UI 시작 (버튼 등을 비활성화 시킴)
      setState(() {
        _isUploading = true;
      });
      // 3. 뷰모델 호출하여 Storage 업로드 & Firestore 저장 동시 진행
      await ref
          .read(chatActionProvider)
          .sendImageMessage(
            widget.roomId,
            myUserId,
            targetUserId,
            File(pickedFile.path),
            hasRoom,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이미지 전송에 실패했습니다.')));
      }
    } finally {
      // 4. 업로드 완료 후 로딩 해제
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: IconButton(
              onPressed: _isUploading ? null : _pickAndSendImage,

              icon: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.image, size: 24, color: Colors.grey.shade500),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller, // 컨트롤러 연결
              focusNode: _focusNode,
              textInputAction:
                  TextInputAction.newline, // 👈 1. 키보드의 엔터키를 '줄바꿈' 용도로 변경
              keyboardType: TextInputType.multiline, // 👈 2. 여러 줄 입력 모드 활성화
              maxLines: null, // 👈 3. 텍스트가 길어지면 입력창이 위아래로 자동으로 늘어남
              decoration: const InputDecoration(
                hintText: '메시지를 입력하세요', // 힌트 텍스트 추가
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              onPressed: _hasText
                  ? _sendMessage
                  : null, // 👈 3. 텍스트가 없으면 버튼 비활성화 (선택 사항)
              icon: Icon(
                Icons.send,
                size: 24,
                color: _hasText
                    ? AppColors.primary
                    : Colors.grey.shade500, // 👈 4. 값이 있으면 파란색, 없으면 회색
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}

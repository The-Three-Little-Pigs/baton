import 'package:flutter/material.dart';

/// 소셜 로그인(구글, 카카오, 애플 등)을 위한 공통 버튼 위젯입니다.
class SocialLoginButton extends StatelessWidget {
  final String text; // 버튼에 표시될 텍스트
  final Color backgroundColor; // 버튼의 배경색
  final VoidCallback onTap; // 클릭 시 실행될 비즈니스 로직
  final Color textColor; // 텍스트 색상 (기본값 검정)
  final String? iconPath; // 아이콘 이미지 경로

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onTap,
    this.textColor = Colors.black,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: backgroundColor == Colors.white
                ? Border.all(color: const Color(0xFFF2F2F2))
                : null,
          ),
          child: Stack(
            children: [
              if (iconPath != null)
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Image.asset(iconPath!, width: 20, height: 20),
                ),
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

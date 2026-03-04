import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  children: const [
                    Icon(Icons.circle, size: 8, color: Colors.blue),
                    SizedBox(width: 4),
                    Icon(Icons.circle, size: 8, color: Colors.grey),
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
                    Container(width: 2, height: 20, color: Colors.black),
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
          SizedBox(height: 59),
          // 2. 텍스트 입력 영역
          Padding(
            padding: const EdgeInsets.only(left: 37.0, right: 32.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "입력해주세요.",
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
                  Text("0/8"),
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

          const Expanded(child: SizedBox()),

          // 3. 하단 버튼 영역
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 21.0,
            ),
            child: GestureDetector(
              onTap: () {
                context.go('/signUpProfile');
              },
              child: Container(
                width: double.infinity,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
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
        ],
      ),
    );
  }
}

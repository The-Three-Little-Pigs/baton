// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // 1. Notifier 상속: 관리할 상태의 타입을 꺾쇠(<>) 안에 적어줍니다. 여기선 유저 아이디니까 String? 입니다.
// class TestAuthNotifier extends Notifier<String?> {
//   // 2. 초기값 설정: 앱이 켜질 때 최초로 들고 있을 값을 리턴합니다.
//   @override
//   String? build() {
//     return 'BUYER_999'; // 테스트용 임시 구매자 아이디
//   }

//   // 3. 상태 변경 함수: state 변수에 값을 넣으면 앱 전체에 알림이 갑니다.
//   void login(String userId) {
//     state = userId;
//   }
// }

// // 4. Provider 선언: 전역 변수처럼 앱 어디서든 위 클래스에 접근하게 해주는 연결통로입니다.
// // 제네레이터를 안 쓰면 우리가 이 변수를 직접 손으로 써줘야 합니다.
// final testAuthNotifierProvider = NotifierProvider<TestAuthNotifier, String?>(
//   () {
//     return TestAuthNotifier();
//   },
// );

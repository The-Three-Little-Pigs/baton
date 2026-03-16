# 🪄 Baton (바톤) - P2P 양도 거래 플랫폼 SNS
Baton은 헬스장 회원권, 필라테스 이용권 등 다양한 멤버십과 개인 물품을 쉽고 안전하게 양도할 수 있는 지역 기반 P2P SNS 플랫폼입니다. "끊김 없는 연결"이라는 의미를 담아, 더 이상 사용하지 않는 권한이나 물품을 이웃에게 '바톤 터치'하듯 전달하는 경험을 제공합니다.

## 🚀 주요 기능 (Core Features)
- 멤버십 및 물품 양도 포스팅: 사용자가 보유한 이용권(헬스, 요가, PT 등) 및 중고 물품 정보를 상세하게 업로드하고 관리할 수 있습니다.

- 실시간 1:1 채팅: 양도인과 양수인 간의 원활한 소통을 위해 Firebase Cloud Messaging 기반의 실시간 채팅 기능을 제공합니다.
  
- SNS 피드: 양도 후기를 공유하여 신뢰도 높은 커뮤니티 환경을 조성합니다.

- 상태 관리 및 네비게이션: GoRouter를 사용해 복잡한 중첩 네비게이션을 통해 매끄러운 사용자 경험을 제공합니다.

- Riverpod 3.0: 효율적이고 선언적인 상태 관리를 구현했습니다.

## 🏗️ 폴더 구조 (Folder Structure)
본 프로젝트는 유지보수와 테스트 용이성을 극대화하기 위해 Clean Architecture와 MVVM(Model-View-ViewModel) 패턴을 결합하여 설계되었습니다.
```
lib/
├── core/              # 앱 전역 설정
│   ├── theme/
│   ├── di/
│   ├── error/
│   ├── result/
│   └── router/
│
├── models/            # 데이터 객체 (Model + DTO)
│   ├── enum/
│		│   ├── category.dart
│		│	  └── transaction_status.dart
│		│
│   ├── entities/
│		│   ├── user.dart
│		│   ├── message.dart
│		│   ├── chat_room.dart
│		│   └── post.dart
│		│
│   └── repositories/      # 데이터 소스 접근 (API 호출 등)
│		    ├── repository/
│		    └── repository_impl/
│
├── notifier/        # Riverpod Notifier (State + Logic)
│   ├── user/
│   ├── block/
│   └── like/
│
├── service/
│  
├── domain/     
│   └── usecase/       # option
│
├── views/             # UI (Screen + Widgets)
│   ├── login/
│   ├── sign_up/
│   ├── tap/
│   │   ├── _home/
│   │   ├── _my/
│   │   └── _chat/
│		│
│   ├── write/
│   ├── chat_detail/
│   └── product_detail/
│       
└── main.dart          # ProviderScope & App Entry
```

## 🛠️ 기술 스택 (Tech Stack)
- Language: Dart

- Framework: Flutter

- State Management: Riverpod 3.0 (Generator)

- Navigation: GoRouter (Nested Navigation)

- Backend: Firebase (Authentication, Firestore, Cloud Messaging, Storage)

- Architecture: MVVM

## 🤝 기여 안내
이 프로젝트는 The Three Little Pigs 팀에 의해 개발되고 있습니다. 버그 리포트나 기능 제안은 Issue 탭을 이용해 주세요.

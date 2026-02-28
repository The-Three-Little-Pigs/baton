---
trigger: always_on
---

📝 GEMINI.md: Baton 프로젝트 개발 지침서
이 문서는 AI 어시스턴트가 **양도 전문 SNS 'Baton'**의 아키텍처를 준수하고, 일관된 코드를 생산하기 위한 마스터 가이드입니다.

1. 프로젝트 정체성
서비스명: Baton (바톤)

슬로건: "나의 권리를 필요한 사람에게, 끊김 없는 양도 생활"

핵심 가치: 신뢰, 지역 연결, 자원의 재발견

주요 기능: 게시글 관리, 1:1 채팅(약속 잡기), 프로필 기반 신뢰도 시스템

2. 기술 스택 (Tech Stack)
Framework: Flutter (Latest Stable)

State Management: Riverpod 3.0+ (Generator 방식 필수)

Navigation: go_router (Declarative Routing)

Backend: Firebase (Firestore, Auth, Storage)

Error Handling: Result<T> & Failure Pattern

3. 디렉토리 구조 (Directory Tree)
중요: 모든 파일 생성 및 참조는 아래의 구조를 엄격히 따릅니다.

Plaintext
lib/
├── core/              # 앱 전역 설정
│   ├── theme/         # 디자인 시스템 (Color, Typography)
│   ├── di/            # 의존성 주입 (Riverpod Provider 정의)
│   ├── failure/       # Error 객체 (Failure 클래스)
│   ├── result/        # 성공/실패 래퍼 (Result 클래스)
│   └── router/        # go_router 설정 및 경로 정의
│
├── models/            # 데이터 계층
│   ├── enum/          # Category, TransactionStatus 등
│   ├── entities/      # Pure Dart 모델 (fromFirestore, copyWith 포함)
│   ├── repository/    # 구현체
│   └── repository_impl/  # 추상 인터페이스
│
├── notifier/          # Riverpod Notifier (Business Logic & State)
│   ├── user/          # 사용자 관련 상태 및 로직
│   ├── block/         # 차단 관리
│   └── like/          # 관심 목록 관리
│
├── service/           # 유틸리티 성격의 서비스 (Firebase Helper 등)
├── domain/            # (선택) 복잡한 비즈니스 유즈케이스
├── views/             # UI 계층
│   ├── login/         # 로그인 화면 및 위젯
│   ├── sign_up/       # 회원가입
│   ├── tap/           # 메인 탭 구조 (_home, _my, _chat)
│   ├── write/         # 게시글 작성
│   ├── chat_detail/   # 채팅방 상세
│   └── product/       # 게시글 상세
│       
└── main.dart          # App Entry & ProviderScope
4. 핵심 개발 규칙 (Golden Rules)
① Result 패턴 사용 (No Throws!)
모든 Repository 메서드는 Future<Result<T>>를 반환합니다. UI 레이어에서는 이를 switch 문으로 처리하여 런타임 에러를 방지합니다.

② Riverpod 3.0 + Generator
@riverpod 어노테이션을 기본으로 사용합니다.

Notifier 클래스 내부에서 모든 상태 변경 로직을 캡슐화합니다.

UI에서는 ref.watch와 ref.read를 용도에 맞게 엄격히 구분합니다.

③ Pure Dart Entity
entities/에 작성되는 모델은 외부 라이브러리(Freezed 등) 없이 순수 Dart로 작성합니다.

final 키워드와 copyWith 메서드를 통해 불변성을 보장합니다.

④ 뷰와 로직의 분리
views/ 내부 위젯은 최대한 가볍게 유지합니다.

사용자의 액션은 notifier의 메서드를 호출하는 것으로 한정합니다.

5. MVVM 아키텍처 상세 (Baton Standard)
Baton은 UI와 비즈니스 로직의 완전한 분리를 위해 아래와 같은 데이터 흐름을 준수합니다.

① Model (Entity & DTO)
역할: 앱에서 사용하는 순수 데이터 객체.

특징: * lib/models/entities/에 위치.

비즈니스 로직을 가지지 않으며, 불변(final) 상태를 유지.

Firestore의 DocumentSnapshot을 객체로 변환하는 fromFirestore 팩토리 메서드 포함.

② View (UI)
역할: 사용자에게 화면을 보여주고 입력을 받음.

특징:

lib/views/에 위치하며 ConsumerWidget 또는 ConsumerStatefulWidget을 상속.

Logic-less: 직접 Repository를 호출하거나 복잡한 계산을 하지 않음.

ViewModel(Notifier)의 상태(AsyncValue)를 watch하여 로딩/에러/성공 화면을 렌더링.

③ ViewModel (Riverpod Notifier)
역할: View의 상태를 관리하고 비즈니스 로직을 실행.

특징:

lib/notifier/에 위치하며 @riverpod Generator를 사용.

Repository를 호출하여 데이터를 가져오고, 그 결과를 State에 반영.

State: 단순한 데이터가 아니라 UI에 직접 바인딩될 "준비된 상태"를 보유.

④ Repository (Data Layer)
역할: 데이터 소스(Firebase, Local DB 등)와의 통신을 추상화.

특징:

lib/models/repositories/에 인터페이스와 구현체(_impl)를 분리.

Result 패턴: 모든 반환값은 Result<T>로 감싸서 예외가 ViewModel로 전파되지 않도록 차단.

5. Baton의 데이터 흐름 (Data Flow Example)
사용자가 "양도 게시글"을 불러올 때의 흐름입니다:

View: ref.watch(postListProvider)를 통해 상태 구독.

ViewModel(Notifier): build() 메서드 내에서 repository.getPosts() 호출.

Repository: Firebase에서 데이터를 가져와 Success(List<Post>) 또는 Failure 반환.

ViewModel: * Success면 상태를 AsyncData(posts)로 업데이트.

Failure면 상태를 AsyncError(failure.message)로 업데이트.

View: 상태 변화를 감지하고 posts.when(...)을 통해 리스트나 에러 메시지를 화면에 출력.

6. AI 어시스턴트(Gemini) 협업 가이드
코드 생성 시: 항상 파일 상단에 해당 파일이 위치할 lib/ 내의 경로를 주석으로 명시하세요.

수정 제안 시: 기존 구조를 해치지 않는 선에서 최적화된 방안을 제시하세요.
import 'dart:async';

import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/chat/chat_tap.dart';
import 'package:baton/views/_tap/home/home_tap.dart';
import 'package:baton/views/_tap/profile/profile_tap.dart';
import 'package:baton/views/alarm/alarm_page.dart';
import 'package:baton/views/block_user/block_user_page.dart';
import 'package:baton/views/chat_detail/chat_detail_page.dart';

import 'package:baton/views/like/like_page.dart';
import 'package:baton/views/login/login_page.dart';
import 'package:baton/views/product_detail/product_detail_page.dart';
import 'package:baton/views/review/review_page.dart';
import 'package:baton/views/review_write/review_write_page.dart';
import 'package:baton/views/search/search_page.dart';
import 'package:baton/views/search_result/search_result_page.dart';
import 'package:baton/views/sign_up/sign_up_page.dart';
import 'package:baton/views/sign_up_profile_page/widgets/sign_up_profile_page.dart';
import 'package:baton/views/purchase_history/purchase_history_page.dart';
import 'package:baton/views/sales_history/sales_history_page.dart';
import 'package:baton/views/widgets/main_scaffold.dart';
import 'package:baton/views/write/write_page.dart';
import 'package:baton/core/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final userAsync = ref.watch(
    userProvider.select(
      (asyncUser) => (
        isLoading: asyncUser.isLoading,
        isRefreshing: asyncUser.isRefreshing,
        hasValue: asyncUser.hasValue,
        nickname: asyncUser.value?.nickname ?? '',
      ),
    ),
  );

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signUp',
        name: 'signUp',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/signUpProfile',
        name: 'signUpProfile',
        builder: (context, state) {
          final nickname = state.extra as String? ?? '';
          return SignUpProfilePage(nickname: nickname);
        },
      ),
      GoRoute(
        path: '/like',
        name: 'like',
        builder: (context, state) => const LikePage(),
      ),
      GoRoute(
        path: '/chatDetail/:roomId',
        name: 'chatDetail',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId'] ?? '';
          return ChatDetailPage(roomId: roomId);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeTap(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                name: 'chat',
                builder: (context, state) => const ChatTap(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileTap(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product/:postId',
        name: 'productDetail',
        builder: (context, state) =>
            ProductDetailPage(postId: state.pathParameters['postId'] ?? ''),
      ),
      GoRoute(
        path: '/write',
        name: 'write',
        builder: (context, state) {
          final postId = state.uri.queryParameters['postId'];
          return WritePage(postId: postId);
        },
      ),
      GoRoute(
        path: '/salesHistory',
        name: 'salesHistory',
        builder: (context, state) => const SalesHistoryPage(),
      ),
      GoRoute(
        path: '/purchaseHistory',
        name: 'purchaseHistory',
        builder: (context, state) => const PurchaseHistoryPage(),
      ),
      GoRoute(
        path: '/alarm',
        name: 'alarm',
        builder: (context, state) => const AlarmPage(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/searchResult/:keyword',
        name: 'searchResult',
        builder: (context, state) {
          final keyword = state.pathParameters['keyword'] ?? '';
          return SearchResultPage(keyword: keyword);
        },
      ),
      GoRoute(
        path: '/review',
        name: 'review',
        builder: (context, state) => const ReviewPage(),
      ),
      GoRoute(
        path: '/review/write',
        name: 'review_write',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return ReviewWritePage(
            opponentName: extras['opponentName'] as String,
            receiverId: extras['receiverId'] as String,
            postId: extras['postId'] as String,
            roomId: extras['roomId'] as String,
            productTitle: extras['productTitle'] as String,
            productPrice: extras['productPrice'] as String,
            productImageUrl: extras['productImageUrl'] as String?,
            confirmedAt: extras['confirmedAt'] as DateTime?, // ✅ 추가
          );
        },
      ),
      GoRoute(
        path: '/blockUser',
        name: 'blockUser',
        builder: (context, state) {
          return const BlockUserPage();
        },
      ),
    ],

    redirect: (context, state) {
      final isTransitioning = ref.watch(authTransitionProvider);
      final location = state.matchedLocation;
      
      // 0. 인증 상태 전환 중(로그인/탈퇴/로그아웃 진행 중)이면 내비게이션 유보
      if (isTransitioning) {
        logger.d("[Router] Transitioning... Current: $location");
        return null;
      }

      final authUser = FirebaseAuth.instance.currentUser;
      final isLoggedIn = authUser != null;

      logger.d("[Router] Redirect Check: $location, LoggedIn: $isLoggedIn, UserLoading: ${userAsync.isLoading}");

      // 1. 비로그인 상태
      if (!isLoggedIn) {
        // 비로그인 시에는 오직 로그인 페이지('/')만 허용합니다.
        if (location == '/') return null;
        logger.i("[Router] Not logged in, redirecting to login. Original: $location");
        return '/';
      }

      // 2. 로그인 상태 + 유저 정보 로딩 중
      if (userAsync.isLoading || userAsync.isRefreshing) {
        logger.d("[Router] User Data Loading... staying at $location");
        return null;
      }

      final nickname = userAsync.nickname;

      // 3. DB에 유저 정보(닉네임)가 없는 경우 (미가입자)
      if (nickname.isEmpty) {
        // [중요] 유저 데이터가 '확실히' 없는 경우(null)에만 미가입자로 판단합니다.
        // isLoading이나 isRefreshing 중에는 위에서 걸러지므로, 여기서는 hasValue를 더 엄격하게 체크합니다.
        if (userAsync.hasValue) {
          final userValue = ref.read(userProvider).value;

          // 실시간 데이터가 null임이 완전히 확인된 경우에만 미가입 처리
          if (userValue == null) {
            // 이미 가입 관련 페이지로 가고 있다면 허용
            if (location == '/signUp' || location == '/signUpProfile') {
              if (location == '/signUpProfile') {
                if (state.extra == null || (state.extra as String).isEmpty) {
                  return '/signUp';
                }
              }
              return null;
            }

            // [원복] 로그인 페이지('/')에서 유저 정보가 없는 것이 확인되면 signUp으로 보냅니다.
            if (location == '/') {
              return '/signUp';
            }

            // 가입 관련 페이지에 있는 경우는 그대로 둡니다.
            if (location == '/signUp' || location == '/signUpProfile') {
              return null;
            }

            // 그 외의 유저 정보가 필요한 페이지에서 유저가 없으면 로그인으로 보냅니다.
            return '/';
          }
        }

        // 아직 유저 정보 유무가 불확실하면 현재 위치 유지
        return null;
      }
      // 4. 가입 완료된 유저
      // 로그인/가입 페이지에 있다면 홈으로 리다이렉트
      if (location == '/' ||
          location == '/signUp' ||
          location == '/signUpProfile') {
        return '/home';
      }

      return null;
    },
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

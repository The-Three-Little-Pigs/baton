import 'dart:async';

import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/chat/chat_tap.dart';
import 'package:baton/views/_tap/home/home_tap.dart';
import 'package:baton/views/_tap/profile/profile_tap.dart';
import 'package:baton/views/chat_detail/chat_detail_page.dart';

import 'package:baton/views/like/like_page.dart';
import 'package:baton/views/login/login_page.dart';
import 'package:baton/views/product_detail/product_detail_page.dart';
import 'package:baton/views/sign_up/sign_up_page.dart';
import 'package:baton/views/sign_up_profile_page/widgets/sign_up_profile_page.dart';
import 'package:baton/views/purchase_history/purchase_history_page.dart';
import 'package:baton/views/sales_history/sales_history_page.dart';
import 'package:baton/views/widgets/main_scaffold.dart';
import 'package:baton/views/write/write_page.dart';
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
    ],

    redirect: (context, state) {
      final authUser = FirebaseAuth.instance.currentUser;
      final isLoggedIn = authUser != null;
      final location = state.matchedLocation;

      // 1. 비로그인 상태
      if (!isLoggedIn) {
        if (location == '/' ||
            location == '/signUp' ||
            location == '/signUpProfile') {
          return null;
        }
        return '/';
      }

      // 2. 로그인 상태 + 유저 정보 로딩 중
      // 가주입된 데이터가 있거나 로딩 중이 아닐 때만 아래 로직 진행
      if (userAsync.isLoading || userAsync.isRefreshing) {
        // 가입 완료 직후라면 /home으로 가려고 할 텐데, 이때 로딩 때문에 가로막히면 안 됨
        return null;
      }

      final nickname = userAsync.nickname;

      // 3. DB에 유저 정보(닉네임)가 없는 경우 (미가입자)
      if (nickname.isEmpty) {
        // [중요] 만약 userProvider가 데이터를 가지고 있는데 null이라면 (로딩 완료 후에도 데이터 없음),
        // 그때 비로소 미가입자로 판단하고 이동시킵니다.
        // 유저 정보가 정말로 없는 것이 확실할 때만 리다이렉트
        if (userAsync.hasValue) {
          // 이미 가입 관련 페이지로 가고 있다면 허용
          if (location == '/signUp' || location == '/signUpProfile') {
            if (location == '/signUpProfile') {
              if (state.extra == null || (state.extra as String).isEmpty) {
                return '/signUp';
              }
            }
            return null;
          }

          // 로그인 페이지('/')에 있다면 -> 신규 가입 페이지로 자동 이동
          if (location == '/') return '/signUp';

          // 그 외 보호된 페이지(예: /home) 접근 시 로그인 페이지('/')로 유도
          return '/';
        }

        // 아직 유저 정보 유무가 불확실하면 현재 위치 유지 (Loading 상태 등)
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

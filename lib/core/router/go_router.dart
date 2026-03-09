import 'package:baton/views/_tap/chat/chat_tap.dart';
import 'package:baton/views/_tap/home/home_tap.dart';
import 'package:baton/views/_tap/profile/profile_tap.dart';
import 'package:baton/views/chat_detail/chat_detail_page.dart';
import 'package:baton/views/like/like_page.dart';
import 'package:baton/views/login/login_page.dart';
import 'package:baton/views/product_detail/product_detail_page.dart';
import 'package:baton/views/sign_up/sign_up_page.dart';
import 'package:baton/views/sign_up_profile_page/widgets/sign_up_profile_page.dart';
import 'package:baton/views/widgets/main_scaffold.dart';
import 'package:baton/views/write/write_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: FirebaseAuth.instance.currentUser != null ? '/home' : '/',

  // initialLocation: '/chat/chatDetail',
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
      builder: (context, state) => const SignUpProfilePage(),
    ),
    GoRoute(
      path: '/like',
      name: 'like',
      builder: (context, state) => const LikePage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
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
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: ':roomId',
                  name: 'chatDetail',
                  builder: (context, state) {
                    final roomId = state.pathParameters['roomId']!;
                    return ChatDetailPage(roomId: roomId);
                  },
                ),
              ],
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
      builder: (context, state) {
        final postId = state.pathParameters['postId']!;
        return ProductDetailPage(postId: postId);
      },
    ),
    GoRoute(
      path: '/write',
      name: 'write',
      builder: (context, state) => const WritePage(),
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isLoggingIn = state.matchedLocation == '/';
    final isSigningUp =
        state.matchedLocation == '/signUp' ||
        state.matchedLocation == '/signUpProfile';

    // 로그인 안 됐는데 홈으로 가려 하면 로그인 페이지로 이동
    if (!isLoggedIn && !isLoggingIn && !isSigningUp) return '/';

    // 로그인 됐는데 로그인 페이지나 회원가입 페이지로 가려 하면 홈으로 이동
    if (isLoggedIn && (isLoggingIn || isSigningUp)) return '/home';

    return null;
  },
);

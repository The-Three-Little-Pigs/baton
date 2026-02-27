import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {},
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeTap(),
            ),
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
      path: '/product/:productId',
      name: 'productDetail',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return ProductDetailPage(productId: productId);
      },
    ),
  ],
);

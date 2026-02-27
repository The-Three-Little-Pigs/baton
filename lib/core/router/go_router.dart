import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const SignUpPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main',
              name: 'main',
              builder: (context, state) => const HomeTap(),
            ),
            GoRoute(
              path: '/chat',
              name: 'chat',
              builder: (context, state) => const ChatTap(),
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
      path: '/product',
      name: 'product',
      builder: (context, state) => const ProductPage(),
    ),
    GoRoute(
      path: ':chatId',
      name: 'chatDetail',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;

        return ChatDetailPage(chatId: chatId);
      },
    ),
  ],
);

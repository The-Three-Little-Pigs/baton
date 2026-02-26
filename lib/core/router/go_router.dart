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
      builder: (context, state) => const RegisterPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/main',
              name: 'main',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/chat',
              name: 'chat',
              builder: (context, state) => const ChatPage(),
              routes: [
                GoRoute(
                  path: ':chatId',
                  name: 'chatDetail',
                  builder: (context, state) {
                    final chatId = state.pathParameters['chatId']!;

                    return ChatDetailPage(chatId: chatId);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
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
  ],
);

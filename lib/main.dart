import 'package:baton/core/router/go_router.dart';
import 'package:baton/service/notification_service.dart';
import 'package:baton/core/theme/app_theme.dart';
import 'package:baton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await initializeDateFormatting('ko_KR', null);

  NotificationService().initialize().catchError((e) {});

  KakaoSdk.init(nativeAppKey: '7f7a429c53f5e3bf1973da1c75a934df');

  runApp(const ProviderScope(child: BatonApp()));
}

class BatonApp extends ConsumerWidget {
  const BatonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // routerProvider를 읽어옵니다.
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Baton',
      routerConfig: goRouter, // 생성된 라우터 연결
      theme: AppTheme.light,
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

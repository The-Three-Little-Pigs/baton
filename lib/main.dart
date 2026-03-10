import 'package:baton/core/router/go_router.dart';
import 'package:baton/service/notification_service.dart';
import 'package:baton/core/theme/app_theme.dart';
import 'package:baton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('ko_KR', null);

  // FCM 초기화가 앱의 시작(runApp)을 방해하지 않도록 await 제거
  NotificationService().initialize().catchError((e) {
    print('FCM 초기화 에러: $e');
  });

  // .env 파일에 안전하게 보관
  KakaoSdk.init(nativeAppKey: '7f7a429c53f5e3bf1973da1c75a934df');

  runApp(const ProviderScope(child: BatonApp()));
}

class BatonApp extends StatelessWidget {
  const BatonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Baton',
      routerConfig: router,
      theme: AppTheme.light,
    );
  }
}

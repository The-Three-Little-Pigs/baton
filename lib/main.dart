import 'package:baton/core/router/go_router.dart';
import 'package:baton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // .env 파일에 안전하게 보관
  KakaoSdk.init(nativeAppKey: '7f7a429c53f5e3bf1973da1c75a934df');

  runApp(const ProviderScope(child: BatonApp()));
}

class BatonApp extends StatelessWidget {
  const BatonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'Baton', routerConfig: router);
  }
}

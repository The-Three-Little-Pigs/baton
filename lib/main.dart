import 'package:baton/firebase_options.dart';
import 'package:baton/views/login/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:baton/core/router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

//11
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kakao SDK 초기화
  KakaoSdk.init(nativeAppKey: '7f7a429c53f5e3bf1973da1c75a934df');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'Baton', routerConfig: router);
  }
}

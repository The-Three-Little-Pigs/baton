import 'dart:io';
import 'package:baton/models/entities/fcm_token.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // 싱글톤 패턴 (어디서든 하나의 인스턴스만 사용)
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _setupPlatformConfigs(); // 플랫폼별 전용 설정
      await _manageToken(); // 토큰 관리 (발행 및 서버 전송)
      _configureListeners(); // 메시지 수신 감시
    } else {
      return;
    }
  }

  Future<void> _setupPlatformConfigs() async {
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'baton_main_channel',
        'Baton 주요 알림',
        description: '채팅 및 서비스 주요 알림을 수신합니다.',
        importance: Importance.max,
      );

      await _localNotifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
    } else if (Platform.isIOS) {
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // 3. 토큰 관리 (발행 및 갱신 감시)
  Future<void> _manageToken() async {
    String? token = await _fcm.getToken();
    if (token != null) {
      final fcmToken = FCMToken(
        token: token,
        uid: FirebaseAuth.instance.currentUser!.uid,
        deviceType: Platform.isAndroid ? 'android' : 'ios',
      );
    }

    // 앱 실행 중 토큰이 바뀌는 경우 대응
    _fcm.onTokenRefresh.listen((newToken) {});
  }

  // 4. 메시지 수신 리스너 (상태별 대응)
  void _configureListeners() {
    // [포그라운드] 앱 사용 중 메시지 수신
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Android는 포그라운드에서 배너가 안 뜨므로 로컬 알림으로 직접 띄움
      if (Platform.isAndroid) {
        _displayLocalNotification(message);
      }
    });

    // [백그라운드/종료] 알림을 클릭해서 앱을 열었을 때
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // TODO: 클릭 시 특정 페이지(예: 채팅방)로 이동하는 로직
    });
  }

  // Android 포그라운드 전용: 배너 강제 노출 함수
  void _displayLocalNotification(RemoteMessage message) {
    _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'baton_main_channel',
          'Baton 주요 알림',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
    );
  }
}

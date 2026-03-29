import 'dart:io';
import 'package:baton/models/entities/fcm_token.dart';
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

  /// 알림 클릭 시 이동을 위한 Router (main.dart에서 주입)
  dynamic _router;

  bool _isTokenRefreshRegistered = false;

  void setRouter(dynamic router) {
    _router = router;
  }

  /// 기기의 FCM 토큰을 가져옵니다. (iOS의 경우 APNs 토큰 준비를 기다립니다.)
  Future<String?> getToken() async {
    if (Platform.isIOS) {
      int retryCount = 0;
      while (retryCount < 10) {
        final apnsToken = await _fcm.getAPNSToken();
        if (apnsToken != null) break;
        await Future.delayed(const Duration(seconds: 1));
        retryCount++;
      }
    }
    return _fcm.getToken();
  }

  /// 알림 서비스 초기화 및 권한 요청을 수행합니다.
  Future<void> initialize() async {
    print("ℹ️ [FCM] NotificationService Initializing...");
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("ℹ️ [FCM] AuthorizationStatus: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _setupPlatformConfigs(); // 플랫폼별 전용 설정
      _configureListeners(); // 메시지 수신 감시
      await _handleInitialMessage(); // 종료 상태에서 알림으로 진입한 경우 처리
      print("✅ [FCM] Initialization Complete.");
    } else {
      print("⚠️ [FCM] User declined or has not yet granted permission.");
    }
  }

  /// 앱이 완전히 종료된 상태에서 알림을 클릭해 열린 경우를 처리합니다.
  Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print("ℹ️ [FCM] App opened from terminated state via notification.");
      // 약간의 지연을 주어 라우터가 완전히 준비된 후 이동하도록 함
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleMessageNavigation(initialMessage);
      });
    }
  }

  /// 현재 앱의 알림 권한 상태를 확인합니다.
  Future<bool> hasPermission() async {
    final settings = await _fcm.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Android 채널 설정 및 iOS 포그라운드 알림 옵션 등 플랫폼별 초기 설정을 진행합니다.
  Future<void> _setupPlatformConfigs() async {
    if (Platform.isAndroid) {
      print("ℹ️ [FCM] Configuring Android channel...");
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
      print("✅ [FCM] Android channel configured.");
    } else if (Platform.isIOS) {
      print("ℹ️ [FCM] Configuring iOS foreground options...");
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      print("✅ [FCM] iOS foreground options configured.");
    }
  }

  /// FCM 토큰을 가져와 Firestore 서브 컬렉션에 저장하고 토큰 갱신 리스너를 등록합니다.
  Future<void> updateFCMToken(
    String uid, {
    required dynamic userRepository,
  }) async {
    try {
      String? token;

      // iOS의 경우 APNs 토큰이 준비될 때까지 최대 10초간 대기합니다. (실제 기기 필수)
      if (Platform.isIOS) {
        print("ℹ️ [FCM] iOS detected. Waiting for APNs token...");
        int retryCount = 0;
        while (retryCount < 10) {
          try {
            final apnsToken = await _fcm.getAPNSToken();
            if (apnsToken != null) {
              print("✅ [FCM] APNs Token acquired.");
              break;
            }
          } catch (e) {
            print(
              "⏳ [FCM] Waiting for APNs token... (retry ${retryCount + 1}/10)",
            );
          }
          await Future.delayed(const Duration(seconds: 1));
          retryCount++;
        }
      }

      try {
        token = await _fcm.getToken();
      } catch (e) {
        print("⚠️ [FCM] Failed to fetch FCM token: $e");
      }

      if (token != null && token.isNotEmpty) {
        final fcmTokenEntity = FCMToken(
          token: token,
          uid: uid,
          os: Platform.isIOS ? 'ios' : 'android',
          isActive: true,
        );

        // Firestore 서브 컬렉션에 토큰 정보 업데이트
        await userRepository.updateFCMToken(uid, fcmTokenEntity);
        print("✅ [FCM] Token Updated for $uid: $token");
      }

      // 앱 실행 중 토큰이 바뀌는 경우 대응
      if (!_isTokenRefreshRegistered) {
        _fcm.onTokenRefresh.listen((newToken) async {
          try {
            final fcmTokenEntity = FCMToken(
              token: newToken,
              uid: uid,
              os: Platform.isIOS ? 'ios' : 'android',
              isActive: true,
            );
            await userRepository.updateFCMToken(uid, fcmTokenEntity);
            print("🔄 [FCM] Token Refreshed: $newToken");
          } catch (e) {
            print("❌ [FCM] Error updating refreshed token: $e");
          }
        });
        _isTokenRefreshRegistered = true;
      }
    } catch (e) {
      print("❌ [FCM] Unexpected Error: $e");
    }
  }

  /// 로그아웃 또는 탈퇴 시 기기의 FCM 토큰을 비활성화합니다. (상태 변경)
  Future<void> deleteFCMToken(
    String uid, {
    required dynamic userRepository,
  }) async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        // Firestore에서 토큰 활성화 상태를 false로 변경 (상태 기반 관리)
        await userRepository.toggleFCMTokenStatus(uid, token, false);
        print("FCM Token Deactivated (isActive: false) for $uid");
      }
    } catch (e) {
      print("FCM Token Deactivate Error: $e");
    }
  }

  /// 포그라운드 메시지 수신 및 알림 클릭 시의 동작을 설정합니다.
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
      print("ℹ️ [FCM] Notification clicked (Background): ${message.data}");
      _handleMessageNavigation(message);
    });
  }

  /// 알림 데이터의 'type'과 'id'를 분석하여 적절한 화면으로 이동시킵니다.
  void _handleMessageNavigation(RemoteMessage message) {
    if (_router == null) {
      print("⚠️ [FCM] Router not set. Navigation aborted.");
      return;
    }

    final data = message.data;
    final String? type = data['type'];
    final String? id = data['id'];

    print("ℹ️ [FCM] Navigating to type: $type, id: $id");

    try {
      if (type == 'chat') {
        // 채팅 상세 화면으로 이동 (chatId가 있다고 가정)
        // _router.push('/chat/$id'); // 라우터 설정에 따라 수정 필요
        _router.go('/chat');
      } else if (type == 'product') {
        // 상품 상세 화면으로 이동
        if (id != null) {
          _router.push('/product/$id');
        }
      } else {
        // 기본값: 홈으로 이동
        _router.go('/home');
      }
    } catch (e) {
      print("❌ [FCM] Navigation Error: $e");
    }
  }

  /// Android 포그라운드에서 알림 배너를 강제로 노출 시키는 함수입니다.
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

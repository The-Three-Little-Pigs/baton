import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get algoliaAppId => dotenv.env['ALGOLIA_APP_ID'] ?? '';
  static String get algoliaSearchApiKey =>
      dotenv.env['ALGOLIA_SEARCH_API_KEY'] ?? '';
  static String get kakaoNativeAppKey =>
      dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }
}

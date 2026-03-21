import 'package:baton/core/config/app_config.dart';

class AlgoliaConfig {
  static String get appId => AppConfig.algoliaAppId;
  static String get apiKey => AppConfig.algoliaSearchApiKey;
  static const String indexName = 'posts'; // Firestore extension에서 설정한 인덱스 이름
}

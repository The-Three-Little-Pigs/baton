// lib/service/algolia/algolia_service.dart

import 'package:algoliasearch/algoliasearch.dart';
import 'package:baton/core/config/algolia_config.dart';

class AlgoliaService {
  final SearchClient _client;

  AlgoliaService()
    : _client = SearchClient(
        appId: AlgoliaConfig.appId,
        apiKey: AlgoliaConfig.apiKey,
      );

  Future<List<Map<String, dynamic>>> search(
    String query, {
    int page = 0,
  }) async {
    if (AlgoliaConfig.appId.isEmpty ||
        AlgoliaConfig.apiKey.isEmpty ||
        AlgoliaConfig.appId == 'YOUR_APP_ID') {
      print('Algolia Config is incomplete. AppID: ${AlgoliaConfig.appId}');
      return [];
    }

    try {
      final response = await _client.search(
        searchMethodParams: SearchMethodParams(
          requests: [
            SearchForHits(
              indexName: AlgoliaConfig.indexName,
              query: query,
              hitsPerPage: 20,
              page: page,
            ),
          ],
        ),
      );

      final firstResult = response.results.first;

      if (firstResult is SearchResponse) {
        return firstResult.hits.map((hit) => hit.toJson()).toList();
      } else {
        // 일부 상황에서 Map으로 반환될 경우를 대비
        final searchResponse = SearchResponse.fromJson(
          firstResult as Map<String, dynamic>,
        );
        return searchResponse.hits.map((hit) => hit.toJson()).toList();
      }
    } catch (e) {
      print('Algolia Search Error: $e');
      rethrow;
    }
  }

  void dispose() {
    _client.dispose();
  }
}

import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/keyword.dart';
import 'package:baton/models/entities/search_history.dart';

abstract class SearchRepository {
  Future<Result<List<Keyword>, Failure>> getHotKeywords();
  Future<Result<void, Failure>> updateSearchRecord(String uid, String keyword);

  // 로컬 검색 기록(Drift) 관련 메서드
  Future<Result<void, Failure>> addLocalSearchHistory(String query);
  Stream<List<SearchHistory>> watchLocalSearchHistory();
  Future<Result<void, Failure>> deleteLocalSearchHistory(int id);
  Future<Result<void, Failure>> clearLocalSearchHistory();
}

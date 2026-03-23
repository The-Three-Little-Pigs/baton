import 'package:baton/core/database/baton_database.dart' as db;
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/error/mapper/firebase_error_mapper.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/keyword.dart';
import 'package:baton/models/entities/search_history.dart';
import 'package:baton/models/repositories/repository/search_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';

class SearchRepositoryImpl implements SearchRepository {
  final FirebaseFirestore firestore;
  final db.BatonDatabase database;

  SearchRepositoryImpl({
    required this.firestore,
    required this.database,
  });

  @override
  Future<Result<List<Keyword>, Failure>> getHotKeywords() async {
    try {
      final snapshot = await firestore
          .collection('keywords')
          .orderBy('count', descending: true)
          .limit(10)
          .get();

      final keywords = snapshot.docs.map((doc) {
        final data = doc.data();
        data['keyword'] = data['keyword'] ?? doc.id;
        return Keyword.fromJson(data);
      }).toList();

      return Success(keywords);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알 수 없는 에러가 발생했습니다.'));
    }
  }

  @override
  Future<Result<void, Failure>> updateSearchRecord(
    String uid,
    String keyword,
  ) async {
    try {
      // 1. 키워드 검색량 증가 (Hot Keywords 관리용)
      final keywordRef = firestore.collection('keywords').doc(keyword);
      await keywordRef.set({
        'keyword': keyword,
        'count': FieldValue.increment(1),
      }, SetOptions(merge: true));

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(FirebaseErrorMapper.toFailure(e));
    } catch (e) {
      return Error(ServerFailure('알 수 없는 에러가 발생했습니다.'));
    }
  }

  // --- 로컬 검색 기록(Drift) 구현 ---

  @override
  Future<Result<void, Failure>> addLocalSearchHistory(String query) async {
    try {
      await database.addSearchHistory(query);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure('검색 기록 저장 중 오류가 발생했습니다.'));
    }
  }

  @override
  Stream<List<SearchHistory>> watchLocalSearchHistory() {
    return (database.select(database.searchHistories)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((rows) => rows
            .map((row) => SearchHistory(
                  id: row.id,
                  query: row.query,
                  createdAt: row.createdAt,
                ))
            .toList());
  }

  @override
  Future<Result<void, Failure>> deleteLocalSearchHistory(int id) async {
    try {
      await database.deleteSearchHistory(id);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure('검색 기록 삭제 중 오류가 발생했습니다.'));
    }
  }

  @override
  Future<Result<void, Failure>> clearLocalSearchHistory() async {
    try {
      await database.clearAllSearchHistories();
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure('검색 기록 초기화 중 오류가 발생했습니다.'));
    }
  }
}
